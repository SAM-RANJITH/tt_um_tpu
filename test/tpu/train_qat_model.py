import torch
import torch.nn as nn
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms
import torch.quantization as tq

BATCH_SIZE = 32

def get_quantized_model():
    # Dataset
    transform = transforms.Compose([transforms.ToTensor()])
    train_ds = torchvision.datasets.MNIST(
        root='./data', train=True, download=True, transform=transform
    )
    train_loader = torch.utils.data.DataLoader(
        train_ds, batch_size=BATCH_SIZE, shuffle=True
    )

    # Model
    model = FCNet()
    model.train()

    # 🔥 REQUIRED for quantization (VERY IMPORTANT)
    model.fuse_model = lambda: None  # placeholder (no conv to fuse)

    # QAT config
    model.qconfig = tq.get_default_qat_qconfig("fbgemm")
    tq.prepare_qat(model, inplace=True)

    # Training
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(model.parameters(), lr=0.01)

    for epoch in range(3):
        for images, labels in train_loader:
            optimizer.zero_grad()
            outputs = model(images)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()

        print(f"Epoch {epoch+1} done")

    # Convert to INT8
    model.eval()
    tq.convert(model, inplace=True)

    return model
