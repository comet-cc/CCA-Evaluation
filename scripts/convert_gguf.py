import os
import subprocess
import argparse
from huggingface_hub import login
from transformers import AutoTokenizer, AutoModelForCausalLM

def convert_model_to_gguf(repo_name, hf_token):
    # Determine the directory where the script is located
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Authenticate to Hugging Face
    login(token=hf_token, add_to_git_credential=True)

    # Derive names for directories and files based on the repository name
    repo_dir = repo_name.split("/")[-1]
    save_directory = os.path.join(script_dir, "..", "tmp", f"{repo_dir}_model")
    output_path = os.path.join(script_dir, "..", "tmp", f"{repo_dir}.gguf")

    # Step 1: Download the model and tokenizer
    tokenizer = AutoTokenizer.from_pretrained(repo_name, token=hf_token)
    model = AutoModelForCausalLM.from_pretrained(repo_name, token=hf_token)

    # Step 2: Save the model and tokenizer locally
    if not os.path.exists(save_directory):
        os.makedirs(save_directory)
    tokenizer.save_pretrained(save_directory)
    model.save_pretrained(save_directory)

    print(f"Model and tokenizer saved locally in {save_directory}.")

    # Step 3: Convert to GGUF format using llama.cpp conversion tool
    def convert_to_gguf(model_path, output_path):
        conversion_script = os.path.join(script_dir, "..", "llamacpp", "convert_hf_to_gguf.py")

        result = subprocess.run(
            ["python3", conversion_script, "--outtype", "q8_0", "--outfile", output_path, "--use-temp-file", model_path],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            print("Conversion failed:", result.stderr)
        else:
            print("Conversion succeeded:", result.stdout)

    # Run conversion
    convert_to_gguf(save_directory, output_path)
    print(f"Model successfully converted to GGUF format and saved at {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert a Hugging Face model to GGUF format.")
    parser.add_argument("repo_name", type=str, help="The Hugging Face repository name (e.g., 'openai-community/gpt2').")
    parser.add_argument("hf_token", type=str, help="Your Hugging Face token.")

    args = parser.parse_args()
    convert_model_to_gguf(args.repo_name, args.hf_token)
