import re
import numpy as np
import sys
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import math
global_results = {}

def find_hex_differences(content, patterns, experiment_id):
    global global_results

    pattern_dict = {pattern[0]: [] for pattern in patterns}

    # Process each line to find matches for each pattern
    for line_number, line in enumerate(content, 1):
        for pattern, description in patterns:
            # Define a regex to extract hexadecimal numbers following the specific format
            regex = rf"INST_COUNT=0x([0-9A-Fa-f]+).*{pattern}"
            match = re.search(regex, line)
            if match:
                hex_value = int(match.group(1), 16)
                pattern_dict[pattern].append((hex_value, line_number))

    # Check differences for each pattern
    for pattern, values in pattern_dict.items():
        description = next(d for p, d in patterns if p == pattern)
        if len(values) < 2:
            print(f"Less than two hexadecimal numbers were found for {description}.")
        else:
            # Initialize nested dictionaries if they do not exist
            if pattern not in global_results:
                global_results[pattern] = {}
            if experiment_id not in global_results[pattern]:
                global_results[pattern][experiment_id] = []

            # Compute and print differences for consecutive pairs of the pattern
            difference = [0] * (len(values) // 2)
            for i in range(1, len(values), 2):
                difference[(i-1)//2] = values[i][0] - values[i-1][0]
                if difference[(i-1)//2] != 0:
                    print(f"{description} markers in line {values[i][1]} and {values[i-1][1]} difference: {difference[(i-1)//2]}")
                global_results[pattern][experiment_id].append(difference[(i-1)//2])

    return global_results

def find_hex_summation(content, patterns):
     # Dictionary to store lists of hex numbers for each pattern
     pattern_dict = {pattern[0]: [] for pattern in patterns}
     sum_results = []
     # Process each line to find matches for each pattern
     for line_number, line in enumerate(content, 1):
        for pattern, description in patterns:
            # Define a regex to extract hexadecimal numbers following the specific format
            regex = rf"INST_COUNT=0x([0-9A-Fa-f]+).*{pattern}"
            match = re.search(regex, line)
            if match:
                hex_value = int(match.group(1), 16)
                pattern_dict[pattern].append((hex_value, line_number))
                #print(f"Found hex number {match.group(1)} (decimal: {hex_value}) on line {line_number} for {description}")

     # Check differences for each pattern
     for pattern, values in pattern_dict.items():
        description = next(d for p, d in patterns if p == pattern)
        if len(values) < 2:
            print(f"Less than two hexadecimal numbers were found for {description}.")
        else:
            # Compute and print differences for consecutive pairs
            difference = [0] * (len(values)// 2)
            for i in range(1, len(values), 2):
                difference[(i-1)//2] = values[i][0] - values[i-1][0]
                #if difference[(i-1)//2] != 0:
                     #print(f"Difference between numbers on lines {values[i][1]} and {values[i-1][1]} (decimal): {difference[(i-1)//2]} for {description}")
            sum_value = int(np.sum(difference))
            sum_results.append(f"sum of {description} = {sum_value} (On {len(difference)} numbers)")

     for i in range(len(sum_results)):
        print(f"{sum_results[i]}")


def split_and_process(content, patterns, sum_patterns, experiment_patterns):
    try:
        # Find all experiment points based on the experiment patterns
        experiment_indices = []
        experiment_pattern_info = {}
        for experiment_id, (experiment_pattern, description_experiment) in enumerate(experiment_patterns):
            experiment_regex = re.compile(experiment_pattern)
            for i, line in enumerate(content):
  
              if experiment_regex.search(line):
                    experiment_indices.append(i)
                    experiment_pattern_info[i] = experiment_id

        experiment_indices = sorted(set(experiment_indices))  # Ensure indices are unique and sorted

        if not experiment_indices:
            # No experiment pattern found, process the entire file
            print("No experiment pattern found. Processing the entire file:")
            #print("\nSummation:")
            #find_hex_summation(content, sum_patterns)
        else:
            if experiment_indices[-1] != len(content):
                experiment_indices.append(len(content))

            # Process each segment separately
            for experiment_id, (experiment_pattern, description_experiment) in enumerate(experiment_patterns):
                for i in range(len(experiment_indices) - 1):
                   if experiment_id == experiment_pattern_info[experiment_indices[i]]:
                        segment = content[experiment_indices[i]:experiment_indices[i+1]]
                        experiment_pattern_used = experiment_pattern_info[experiment_indices[i]]
                        print("---------------------------------------------------------")
                        print(f"Processing part {i + 1} with type {experiment_patterns[experiment_pattern_used][1]}")
                        find_hex_differences(segment, patterns, experiment_pattern_used)
                        #print("\nSummation:")
                        #find_hex_summation(segment, sum_patterns)
    except Exception as e:
        print(f"An error occurred: {e}")

def remove_outliers(values):
    if len(values) > 1:
        Q1 = np.percentile(values, 25)
        Q3 = np.percentile(values, 75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR
        return [x for x in values if lower_bound <= x <= upper_bound]
    else:
        return values  # Return the original list if it has one or no members

def plot_results(patterns, experiment_patterns, output_file):
    num_patterns = len(patterns)
    cols = 3  # Number of columns for subplots
    rows = math.ceil(num_patterns / cols)  # Calculate the number of rows required
    fig, axes = plt.subplots(rows, cols, figsize=(15, 5 * rows))
    axes = axes.flatten()  # Flatten the axes array for easy iteration

    # Define colors and markers for different experiment_ids
    colors = ['blue', 'orange', 'green', 'red', 'purple']
    markers = ['o', 'x', '*', 's', 'd']

    # Plot data and collect handles and labels for the legend
    legend_lines = []
    for experiment_id, (experiment_pattern, description_experiment) in enumerate(experiment_patterns):
        color = colors[experiment_id % len(colors)]
        marker = markers[experiment_id % len(markers)]
        legend_lines.append(mlines.Line2D([], [], color=color, marker=marker, markersize=5, label=f'{description_experiment} Experiment'))
    
    # Add entries for mean and std dev
    legend_lines.append(mlines.Line2D([], [], color='black', marker='P', markersize=10, label='Mean'))
    legend_lines.append(mlines.Line2D([], [], color='black', linestyle='--', label='Std Dev'))

    for i, (pattern, description) in enumerate(patterns):
        all_values = []
        all_labels = []
        means = []
        stds = []
        print("----------------------------------------------------")
        for experiment_id, (experiment_pattern, description_experiment) in enumerate(experiment_patterns):
            values = global_results.get(pattern, {}).get(experiment_id, [])
            cleaned_values = remove_outliers(values)
            # Collect data for boxplot
            print(". . . . . . .")
            if values:
                mean_value = np.mean(values)
                std_value = np.std(values)
                print(f'{description} for {description_experiment} - Mean: {mean_value}, Std: {std_value}')
                all_values.append(values)
                all_labels.append(f"{description_experiment}")
                means.append(mean_value)
                stds.append(std_value)
                mean_value_cleaned = np.mean(cleaned_values)
                std_value_cleaned = np.std(cleaned_values)
                print(f'{description} for {description_experiment} - removed outliers - Mean: {mean_value_cleaned}, Std: {std_value_cleaned}')

        if all_values:
            # Create a box plot for the current pattern
            bplot = axes[i].boxplot(all_values, patch_artist=True, tick_labels=all_labels)
            for patch, color in zip(bplot['boxes'], colors):
                patch.set_facecolor(color)

            # Overlay mean and std dev
            for j, (mean, std, color) in enumerate(zip(means, stds, colors)):
                x_pos = j + 1  # Positions of the boxes
                print(f'Box {j+1}: Mean = {mean:.2f}, Std Dev = {std:.2f}')
                axes[i].scatter(x_pos, mean, color='black', marker='P', s=100, zorder=3)  # Mean
                axes[i].hlines(mean, x_pos - 0.2, x_pos + 0.2, colors='black', linestyles='--', linewidth=2)  # Std Dev

            axes[i].set_xlabel('Experiment')
            axes[i].set_ylabel('Number of Instructions (Million)')
            axes[i].set_title(f'{description}')

    # Create a single legend for all subplots using proxy artists
    handles, labels = zip(*[(line, line.get_label()) for line in legend_lines])
    fig.legend(handles, labels, loc='lower right', bbox_to_anchor=(1.05, 0.), ncol=1, prop={'size': 10})
    # Remove any extra axes that don't have data
    for j in range(num_patterns, len(axes)):
        fig.delaxes(axes[j])

    plt.tight_layout(rect=[0, 0, 1, 0.95])  # Adjust layout to make space for the legend
    if not (len(output_file) == 1 and output_file[0] == '0'):
         plt.savefig(f'{output_file}.png', format='png', dpi=300)
    plt.close()

def merge_files(file_paths):
    try:
        content = []
        for file_path in file_paths:
            print(f"\n{file_path}")
            with open(file_path, 'r') as file:
                 content.extend(file.readlines())
        return content
    except FileNotFoundError:
        print(f"Error: The file {file_path} was not found.")

if __name__ == "__main__":
    # Hard-coded file path and patterns with descriptions for demonstration
    output_file = sys.argv[1]
    file_paths = sys.argv[2:]
    content = merge_files(file_paths)
    sum_patterns = [
        ("MOV      xzr,#0x110", "Realm_computation"),
	("MOV      xzr,#0x111", "REC_RUN1_computation"),
	("MOV      xzr,#0x112", "REC_RUN2_computation")
    ]
    experiment_patterns = [
    ("MOV      xzr,#0x280", "Realm VM"),
    ("MOV      xzr,#0x281", "NW VM"),
    ("MOV      xzr,#0x282", "NW"),
    ("MOV      xzr,#0x283", "Realm VM QEMU"),
    ("MOV      xzr,#0x284", "NW VM QEMU")
    ]
    patterns11111 = [
        ("MOV      xzr,#0x100", "Start_End_Marker"),
        ("MOV      xzr,#0x200", "Initialisation"),
        ("MOV      xzr,#0x180", "READ_INPUT_ADDR"),
        ("MOV      xzr,#0x210", "Read_Input "),
        ("MOV      xzr,#0x220", "Inference"),
        ("MOV      xzr,#0x230", "Write_Output"), 
        ("MOV      xzr,#0x240", "Update_State"), 
        ("MOV      xzr,#0x250", "VM_Creation"), 
	("MOV      xzr,#0x251", "Realm_Creation_After_Activation"),
	("MOV      xzr,#0x252", "Realm_Creation_Before_Activation"),
        ("MOV      xzr,#0x260", "VM_Destruction"), 
        ("MOV      xzr,#0x271", "Memory_Delegation100"), 
        ("MOV      xzr,#0x272", "Memory_Delegation200"),
        ("MOV      xzr,#0x273", "Memory_Delegation300"),
        ("MOV      xzr,#0x274", "Memory_Delegation400"),
        ("MOV      xzr,#0x275", "Memory_Delegation500"), 
        ("MOV      xzr,#0x280", "Custom")
    ]
    patterns = [
        ("MOV      xzr,#0x100", "Start End Marker"),
        ("MOV      xzr,#0x200", "Initialisation"),
        ("MOV      xzr,#0x180", "Read Input Addr"),
        ("MOV      xzr,#0x210", "Read Input"),
        ("MOV      xzr,#0x220", "Inference"),
        ("MOV      xzr,#0x230", "Write Output"), 
        ("MOV      xzr,#0x240", "Update State"), 
        ("MOV      xzr,#0x250", "Realm Creation"),
	("MOV      xzr,#0x251", "Realm Creation:After Activation"),
	("MOV      xzr,#0x252", "Realm Creation:Before Activation"),
        ("MOV      xzr,#0x260", "Realm Destruction"),
    ]

    patterns22 = [
        ("MOV      xzr,#0x220", "Inference")
    ]
    split_and_process(content, patterns, sum_patterns, experiment_patterns)
    plot_results(patterns, experiment_patterns, output_file)
