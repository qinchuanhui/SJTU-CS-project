# _*_ coding: UTF-8 _*_
# 93738
# Time: 2020/12/19 10:57
# Name:test.py
# Tools: PyCharm
import torch.nn as nn
#import torch.utils.data as Data
from torch.utils.data import DataLoader
from getData import *
from train import coll,TrainBatchSize
from GCN import GCNNet

def test(model, device, loader):
    model.eval()
    total_pred = torch.Tensor()
    with torch.no_grad():
        for iter, (batch_g, l) in enumerate(loader):
            batch_g = batch_g.to(device)
            output = model(batch_g)
            total_pred = torch.cat((total_pred, output.cpu()), 0)

    a = total_pred.numpy().flatten()
    mean_out = a.mean()
    res = a.tolist()
    for i in invalid_test:
        res.insert(i, mean_out / 10)
    return res




test_smile, test_name = get_test_data()
test_label = np.zeros(608).tolist()
test_dataset = get_feature(test_smile, test_label, 2)
test_cal_loader = DataLoader(test_dataset, batch_size=TrainBatchSize, shuffle=False, collate_fn=coll)

device = torch.device(cudaname if torch.cuda.is_available() else "cpu")
model = GCNNet().to(device)
model.load_state_dict(torch.load("weights/Final_Model.model",map_location='cpu'))


res = test(model, device, test_cal_loader)
final_res = "Chemical,Label\n"
for name, r in zip(test_name, res):
    final_res = final_res + name + "," + str(r) + '\n'
with open("output_518030910059.txt", 'w') as f:
    f.write(final_res)