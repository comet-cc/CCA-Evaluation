import torch

def check_pytorch_installation():
    print("PyTorch version:", torch.__version__)
    print("CUDA available:", torch.cuda.is_available())

if __name__ == "__main__":
    check_pytorch_installation()
