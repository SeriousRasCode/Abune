"""One-time MMS alignment of the bundled Sibhat recording and known text."""

import re
import subprocess
from pathlib import Path

import torch
import uroman
from torchaudio.pipelines import MMS_FA


def main() -> None:
    source = Path('lib/data/sibhat_prayer.dart').read_text(encoding='utf-8')
    lines = re.findall(r"^  '([^']+)'", source, re.M)
    spoken = [lines[0], lines[0], lines[0], *lines[1:]]
    romanizer = uroman.Uroman()
    normalized = []
    for line in spoken:
        roman = romanizer.romanize_string(line, lcode='amh').lower()
        roman = re.sub("[^a-z' ]", ' ', roman)
        normalized.append(re.sub(r' +', ' ', roman).strip())
    transcript = [word for line in normalized for word in line.split()]
    print(f'Lines: {len(spoken)}; words: {len(transcript)}', flush=True)
    for index, line in enumerate(normalized):
        print(f'TEXT {index + 1:02d} {line}', flush=True)

    pcm = subprocess.run(
        ['ffmpeg', '-v', 'error', '-i', 'assets/audio/sibhat_tselot.m4a',
         '-ar', '16000', '-ac', '1', '-f', 'f32le', 'pipe:1'],
        check=True, capture_output=True,
    ).stdout
    waveform = torch.frombuffer(pcm, dtype=torch.float32).clone().unsqueeze(0)
    model = MMS_FA.get_model()
    model.eval()
    with torch.inference_mode():
        emission, _ = model(waveform)
        spans = MMS_FA.get_aligner()(emission[0], MMS_FA.get_tokenizer()(transcript))
    frame_seconds = waveform.size(1) / 16000 / emission.size(1)
    cursor = 0
    for index, line in enumerate(normalized):
        words = line.split()
        first = spans[cursor][0]
        last = spans[cursor + len(words) - 1][-1]
        word_spans = spans[cursor:cursor + len(words)]
        score = sum(span.score for group in word_spans for span in group) / sum(len(group) for group in word_spans)
        print(f'CUE {index + 1:02d} {first.start * frame_seconds:.2f}-{last.end * frame_seconds:.2f} score={score:.2f}', flush=True)
        cursor += len(words)


if __name__ == '__main__':
    main()
