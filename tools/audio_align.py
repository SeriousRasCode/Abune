"""One-time forced alignment of the known Ge'ez prayer text to the recording."""

import re
from pathlib import Path

import stable_whisper


def main() -> None:
    source = Path("lib/data/prayers.dart").read_text(encoding="utf-8")
    blocks = re.findall(r"lines:\s*\[(.*?)\]", source, flags=re.S)
    lines = [line for block in blocks for line in re.findall(r"'([^']+)'", block)]
    print(f"Aligning {len(lines)} lines", flush=True)

    model = stable_whisper.load_model("small", device="cpu")
    result = model.align(
        "assets/audio/abune_tselot.mp3",
        "\n".join(lines),
        language="am",
        original_split=True,
    )
    if result is None:
        raise RuntimeError("Alignment returned no result")
    for index, segment in enumerate(result.segments):
        print(
            f"{index + 1:02d} {segment.start:.2f}-{segment.end:.2f} "
            f"{segment.text}",
            flush=True,
        )
    print(f"Expected {len(lines)} lines; got {len(result.segments)} segments", flush=True)


if __name__ == "__main__":
    main()
