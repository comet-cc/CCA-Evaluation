import sys

def count_lines_by_pattern_matrix(filename, pattern_matrix):
    total_lines = 0
    row_counts = [0 for _ in pattern_matrix]  # Initialize counts for each row

    try:
        with open(filename, 'r') as file:
            for line in file:
                total_lines += 1
                for i, patterns in enumerate(pattern_matrix):
                    # Filter out empty strings and check if any pattern is in the line
                    if all(pattern in line for pattern in patterns if pattern.strip()):
                        row_counts[i] += 1

    except FileNotFoundError:
        print("File not found. Please check the filename and try again.")
        return

    return total_lines, row_counts

def main():
    if len(sys.argv) < 2:
        print("Usage: python3 count_matrix.py file_name.txt")
        sys.exit(1)

    filename = sys.argv[1]
    pattern_matrix = [
        ['MODE=EL0t', 'SECURITY_STATE=NS'],
	['MODE=EL0t', 'SECURITY_STATE=RL'],
	['MODE=EL0h', 'SECURITY_STATE=NS'],
	['MODE=EL0h', 'SECURITY_STATE=RL'],
	['MODE=EL1t', 'SECURITY_STATE=NS'],
	['MODE=EL1t', 'SECURITY_STATE=RL'],
	['MODE=EL1h', 'SECURITY_STATE=NS'],
	['MODE=EL1h', 'SECURITY_STATE=RL'],
        ['MODE=EL2h', 'SECURITY_STATE=NS'],
        ['MODE=EL2h', 'SECURITY_STATE=RL'],
	['MODE=EL2t', 'SECURITY_STATE=NS'],
	['MODE=EL2t', 'SECURITY_STATE=RL'],
	['MODE=EL3h', ' '],
        ['MODE=EL3t', ' ']
    ]

    total_lines, row_counts = count_lines_by_pattern_matrix(filename, pattern_matrix)

    print(f"Total number of lines in file: {total_lines}")
    for i, count in enumerate(row_counts):
        print(f"Number of lines containing pattern {pattern_matrix[i]} = {count}")

if __name__ == '__main__':
    main()

