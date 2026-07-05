import os

folder = "results/mcscanx/output"

summary = []

for f in os.listdir(folder):
    if f.endswith(".collinearity"):
        path = os.path.join(folder, f)
        count = sum(1 for _ in open(path) if not _.startswith("#"))
        summary.append((f, count))

out = open("results/figures/summaries/synteny_summary.tsv", "w")
out.write("file\tblocks\n")

for row in summary:
    out.write(f"{row[0]}\t{row[1]}\n")

out.close()

print("Summary generated ✔")
