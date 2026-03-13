#!/usr/bin/env python3
"""
Alignment with Dynamic Programming
===================================
This script implements Needleman-Wunsch (global) and Smith-Waterman (local)
alignment algorithms from scratch, for educational purposes.

Module 3 – Sequence Analysis
Course: Bioinformatics Fundamentals
"""


# ---------------------------------------------------------------------------
# Helper: print a scoring matrix in a readable format
# ---------------------------------------------------------------------------

def print_matrix(matrix, seq1, seq2):
    """
    Prints the scoring matrix with row/column headers.
    seq1 goes across the top (columns), seq2 goes down the left (rows).
    """
    header = ["-"] + list(seq1)
    row_labels = ["-"] + list(seq2)

    # Column headers
    print(f"{'':>6s}", end="")
    for ch in header:
        print(f"{ch:>6s}", end="")
    print()

    # Each row
    for i, row in enumerate(matrix):
        print(f"{row_labels[i]:>6s}", end="")
        for val in row:
            print(f"{val:>6d}", end="")
        print()
    print()


# ---------------------------------------------------------------------------
# Needleman-Wunsch  (Global Alignment)
# ---------------------------------------------------------------------------

def needleman_wunsch(seq1, seq2, match=1, mismatch=-1, gap=-2):
    """
    Performs global alignment using the Needleman-Wunsch algorithm.

    Parameters
    ----------
    seq1 : str   – first sequence  (displayed across the top / columns)
    seq2 : str   – second sequence (displayed on the left / rows)
    match : int   – score for a matching position
    mismatch : int – penalty for a mismatch
    gap : int     – penalty for a gap (linear model)

    Returns
    -------
    aligned1 : str – aligned version of seq1
    aligned2 : str – aligned version of seq2
    score    : int – optimal alignment score
    matrix   : list[list[int]] – the filled scoring matrix
    """
    n = len(seq1)
    m = len(seq2)

    # Step 1: initialise the matrix
    matrix = [[0] * (n + 1) for _ in range(m + 1)]
    for j in range(1, n + 1):
        matrix[0][j] = matrix[0][j - 1] + gap
    for i in range(1, m + 1):
        matrix[i][0] = matrix[i - 1][0] + gap

    # Step 2: fill the matrix
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if seq1[j - 1] == seq2[i - 1]:
                diag = matrix[i - 1][j - 1] + match
            else:
                diag = matrix[i - 1][j - 1] + mismatch
            up   = matrix[i - 1][j] + gap
            left = matrix[i][j - 1] + gap
            matrix[i][j] = max(diag, up, left)

    # Step 3: traceback (from bottom-right corner)
    aligned1 = ""
    aligned2 = ""
    i, j = m, n
    while i > 0 or j > 0:
        # Compute diagonal score when both indices are valid
        if i > 0 and j > 0:
            s = match if seq1[j - 1] == seq2[i - 1] else mismatch
            came_from_diag = (matrix[i][j] == matrix[i - 1][j - 1] + s)
        else:
            came_from_diag = False

        if came_from_diag:
            aligned1 = seq1[j - 1] + aligned1
            aligned2 = seq2[i - 1] + aligned2
            i -= 1
            j -= 1
        elif i > 0 and matrix[i][j] == matrix[i - 1][j] + gap:
            aligned1 = "-" + aligned1
            aligned2 = seq2[i - 1] + aligned2
            i -= 1
        else:
            aligned1 = seq1[j - 1] + aligned1
            aligned2 = "-" + aligned2
            j -= 1

    score = matrix[m][n]
    return aligned1, aligned2, score, matrix


# ---------------------------------------------------------------------------
# Smith-Waterman  (Local Alignment)
# ---------------------------------------------------------------------------

def smith_waterman(seq1, seq2, match=1, mismatch=-1, gap=-2):
    """
    Performs local alignment using the Smith-Waterman algorithm.

    Parameters and return values follow the same convention as
    needleman_wunsch, except the alignment is local.
    """
    n = len(seq1)
    m = len(seq2)

    # Step 1: initialise the matrix (all zeros)
    matrix = [[0] * (n + 1) for _ in range(m + 1)]

    # Step 2: fill the matrix (negative values become 0)
    max_score = 0
    max_pos = (0, 0)
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if seq1[j - 1] == seq2[i - 1]:
                diag = matrix[i - 1][j - 1] + match
            else:
                diag = matrix[i - 1][j - 1] + mismatch
            up   = matrix[i - 1][j] + gap
            left = matrix[i][j - 1] + gap
            matrix[i][j] = max(0, diag, up, left)

            if matrix[i][j] > max_score:
                max_score = matrix[i][j]
                max_pos = (i, j)

    # Step 3: traceback (from the cell with the highest score, stop at 0)
    aligned1 = ""
    aligned2 = ""
    i, j = max_pos
    while i > 0 and j > 0 and matrix[i][j] > 0:
        s = match if seq1[j - 1] == seq2[i - 1] else mismatch

        if matrix[i][j] == matrix[i - 1][j - 1] + s:
            aligned1 = seq1[j - 1] + aligned1
            aligned2 = seq2[i - 1] + aligned2
            i -= 1
            j -= 1
        elif matrix[i][j] == matrix[i - 1][j] + gap:
            aligned1 = "-" + aligned1
            aligned2 = seq2[i - 1] + aligned2
            i -= 1
        else:
            aligned1 = seq1[j - 1] + aligned1
            aligned2 = "-" + aligned2
            j -= 1

    return aligned1, aligned2, max_score, matrix


# ---------------------------------------------------------------------------
# Main: run both algorithms with example sequences
# ---------------------------------------------------------------------------

if __name__ == "__main__":

    # Same sequences used in the README examples
    seq1 = "GCATG"
    seq2 = "GATTG"

    MATCH    =  1
    MISMATCH = -1
    GAP      = -2

    # --- Needleman-Wunsch (Global) ---
    print("=" * 55)
    print("  NEEDLEMAN-WUNSCH  (Global Alignment)")
    print("=" * 55)
    print(f"\nSequences: '{seq1}' vs '{seq2}'")
    print(f"Scoring:   match={MATCH:+d}, mismatch={MISMATCH:+d}, gap={GAP:+d}\n")

    aln1, aln2, score, mat = needleman_wunsch(seq1, seq2, MATCH, MISMATCH, GAP)

    print("Scoring matrix:")
    print_matrix(mat, seq1, seq2)

    print("Alignment:")
    print(f"  {aln1}")
    print(f"  {aln2}")
    # Build match line
    match_line = ""
    for a, b in zip(aln1, aln2):
        if a == b:
            match_line += "*"
        elif a == "-" or b == "-":
            match_line += " "
        else:
            match_line += "."
    print(f"  {match_line}")
    print(f"\nScore: {score}\n")

    # --- Smith-Waterman (Local) ---
    print("=" * 55)
    print("  SMITH-WATERMAN  (Local Alignment)")
    print("=" * 55)
    print(f"\nSequences: '{seq1}' vs '{seq2}'")
    print(f"Scoring:   match={MATCH:+d}, mismatch={MISMATCH:+d}, gap={GAP:+d}\n")

    aln1, aln2, score, mat = smith_waterman(seq1, seq2, MATCH, MISMATCH, GAP)

    print("Scoring matrix:")
    print_matrix(mat, seq1, seq2)

    print("Local alignment:")
    print(f"  {aln1}")
    print(f"  {aln2}")
    match_line = ""
    for a, b in zip(aln1, aln2):
        if a == b:
            match_line += "*"
        elif a == "-" or b == "-":
            match_line += " "
        else:
            match_line += "."
    print(f"  {match_line}")
    print(f"\nScore: {score}\n")

    # --- Bonus: try with longer biological sequences ---
    print("=" * 55)
    print("  BONUS: Longer sequences")
    print("=" * 55)

    gene_fragment1 = "ATGCGTACGTTAGCAATCG"
    gene_fragment2 = "ATGCGTACGCTAGCAATCA"

    print(f"\nSequences:")
    print(f"  Seq1: {gene_fragment1}")
    print(f"  Seq2: {gene_fragment2}\n")

    aln1, aln2, score, _ = needleman_wunsch(gene_fragment1, gene_fragment2, MATCH, MISMATCH, GAP)

    print("Global alignment:")
    print(f"  {aln1}")
    print(f"  {aln2}")
    match_line = ""
    for a, b in zip(aln1, aln2):
        if a == b:
            match_line += "*"
        elif a == "-" or b == "-":
            match_line += " "
        else:
            match_line += "."
    print(f"  {match_line}")

    # Calculate identity
    matches = sum(1 for a, b in zip(aln1, aln2) if a == b)
    identity = matches / len(aln1) * 100
    print(f"\nScore: {score}")
    print(f"Identity: {matches}/{len(aln1)} ({identity:.1f}%)")
    print()

