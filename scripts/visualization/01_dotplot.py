import sys
import pandas as pd
import matplotlib.pyplot as plt

# input: MCScanX collinearity file
file = sys.argv[1]

pairs = []

with open(file) as f:
    for line in f:
        if line.startswith("#"):
            continue
        cols = line.strip().split()
        if len(cols) < 2:
            continue
        pairs.append((cols[0], cols[1]))

df = pd.DataFrame(pairs, columns=["gene1", "gene2"])

plt.figure(figsize=(8, 8))
plt.scatter(df.index, df.index, s=1)
plt.title("Synteny Dotplot")
plt.xlabel("Genome 1 genes")
plt.ylabel("Genome 2 genes")

out = file.replace(".collinearity", "_dotplot.png")
plt.savefig(out, dpi=300)
print("Saved:", out)
