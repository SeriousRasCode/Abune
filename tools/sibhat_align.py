"""One-time transcription and alignment for the supplied Sibhat recording."""

import re
from pathlib import Path

import stable_whisper


def main() -> None:
    source = Path("lib/data/sibhat_prayer.dart").read_text(encoding="utf-8")
    lines = re.findall(r"'([^']+)'", source)
    spoken = lines[:2] * 3 + lines[2:]
    model = stable_whisper.load_model("small", device="cpu")
    audio = "assets/audio/sibhat_tselot.m4a"
    transcription = model.transcribe(audio, language="am")
    for segment in transcription.segments:
        print(f"HEARD {segment.start:.2f}-{segment.end:.2f} {segment.text}", flush=True)
    alignment = model.align(audio, "\n".join(spoken), language="am", original_split=True)
    if alignment is None:
        raise RuntimeError("Alignment returned no result")
    for index, segment in enumerate(alignment.segments):
        print(f"LINE {index + 1:02d} {segment.start:.2f}-{segment.end:.2f} {segment.text}", flush=True)


if __name__ == "__main__":
    main()
