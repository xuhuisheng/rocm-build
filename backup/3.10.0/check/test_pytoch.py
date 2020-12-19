#!/bin/python3

import torch

print(torch.cuda.is_available())
ng = torch.cuda.device_count()
print("Devices:%d" %ng)
infos = [torch.cuda.get_device_properties(i) for i in range(ng)]
print(infos)

with torch.cuda.device(0):
    x = torch.tensor([[1., -1.], [1., 1.]], requires_grad=True).cuda()
    out = x.pow(2).sum()
    out.backward()
    print(out)

