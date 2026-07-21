import os

input_dir = "results/report/input_data"
output_file = "results/report/syteny_summary.txt"

collinear_files = [f for f in os.listdir(input_dir) if f.endswith(".collinearity")]

summary = []

summary.append("MCScanX Synteny Analysis Summary\n")
summary.append("="*50 + "\n")

summary.append(f"Total species comparisons: {len(collinear_files)}\n")

total_blocks = 0

for f in collinear_files:
    path = os.path.join(input_dir, f)
    with open(path) as fh:
        blocks = sum(1 for line in fh if not line.startswith("#"))
    summary.append(f"{f}: {blocks} syntenic blocks\n")
    total_blocks += blocks

summary.append("\nTotal syntenic blocks across dataset: {}\n".format(total_blocks))

with open(output_file, "w") as out:
    out.writelines(summary)

print("Summary written:", output_file)
