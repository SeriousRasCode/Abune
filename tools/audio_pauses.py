"""Print pause locations in the bundled recording for line cue review."""

from array import array
import math
import subprocess
import sys


def main() -> None:
    path = sys.argv[1] if len(sys.argv) > 1 else "assets/audio/abune_tselot.mp3"
    result = subprocess.run(
        [
            "ffmpeg", "-v", "error", "-i", path,
            "-f", "s16le", "-ac", "1", "-ar", "8000", "pipe:1",
        ],
        capture_output=True,
        check=True,
    )
    samples = array("h")
    samples.frombytes(result.stdout)
    if sys.byteorder != "little":
        samples.byteswap()
    step = 160  # 20 ms at 8 kHz.
    levels = []
    for start in range(0, len(samples), step):
        window = samples[start:start + step]
        rms = math.sqrt(sum(value * value for value in window) / len(window))
        levels.append(20 * math.log10(max(rms, 1) / 32768))

    print(f"Duration: {len(samples) / 8000:.2f} s")
    for threshold in (-40, -35, -30, -25):
        pauses = []
        start = None
        for index, level in enumerate(levels + [100]):
            if level < threshold and start is None:
                start = index
            elif level >= threshold and start is not None:
                duration = (index - start) * 0.02
                if duration >= 0.14:
                    pauses.append((start * 0.02, index * 0.02, duration))
                start = None
        print(f"Threshold {threshold} dB: {len(pauses)} pauses")
        print(" ".join(f"{a:.2f}-{b:.2f}({d:.2f})" for a, b, d in pauses))


if __name__ == "__main__":
    main()
