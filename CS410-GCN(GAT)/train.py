# _*_ coding: UTF-8 _*_
# 93738
# Time: 2020/12/16 17:01
# Name:train
# Tools: PyCharm
import numpy as np
import torch.nn as nn
from torch.utils.data import DataLoader
from getData import *
from GCN import GCNNet
import dgl
TrainBatchSize = 32
LR = 0.0005
EPOCH = 200



def calAUC(prob,labels):
    f = list(zip(prob,labels))
    rank = [values2 for values1,values2 in sorted(f,key=lambda x:x[0])]
    #ranknew = [(values1,values2) for values1,values2 in sorted(f,key=lambda x:x[0])]
    rankList = [i+1 for i in range(len(rank)) if rank[i]==1]
    posNum = 0
    negNum = 0
    for i in range(len(labels)):
        if(labels[i]==1):
            posNum+=1
        else:
            negNum+=1
    auc = 0
    auc = (sum(rankList)- (posNum*(posNum+1))/2)/(posNum*negNum)
    return auc

def train(model, device, train_loader, optimizer, epoch):
    print('Training on {} samples...epoch: {}'.format(len(train_loader.dataset),epoch))
    model.train()
    for batch_g, label  in (train_loader):
        batch_g = batch_g.to(device)
        optimizer.zero_grad()
        output = model(batch_g)
        loss = nn.BCELoss()(output, label.view(-1, 1).float().to(device))
        loss.backward()
        optimizer.step()



def cal(model, device, loader, label):
    model.eval()
    total_pred = torch.Tensor()
    loss_mean=[]
    with torch.no_grad():
        for iter,(batch_g, l) in enumerate(loader):
            batch_g = batch_g.to(device)
            output = model(batch_g)
            loss = nn.BCELoss()(output, l.view(-1, 1).float().to(device))
            loss_mean.append(float(loss))
            total_pred = torch.cat((total_pred, output.cpu()), 0)

    #calculate AUC
    b = np.array(label)
    a=total_pred.numpy().flatten()
    return calAUC(a,b),np.array(loss_mean).mean()
    #return  np.array(loss_mean).mean()



def coll(sam):
    graphs,labels=map(list,zip(*sam))
    batched_graph = dgl.batch(graphs)
    return batched_graph, torch.tensor(labels)

# GET THE DATA
if __name__ == '__main__':
    train_smile, train_label = get_train_data()
    # train for 0, valid for 1 ,test for 2
    train_dataset = get_feature(train_smile, train_label, 0)
    train_loader = DataLoader(train_dataset, batch_size=TrainBatchSize, shuffle=False,collate_fn=coll)
    train_cal_loader = DataLoader(train_dataset, batch_size=TrainBatchSize, shuffle=False,collate_fn=coll)

    valid_smile, valid_label = get_valid_data()
    # valid for 0, valid for 1 ,test for 2
    valid_dataset = get_feature(valid_smile, valid_label, 1)
    valid_cal_loader = DataLoader(valid_dataset, batch_size=TrainBatchSize, shuffle=False,collate_fn=coll)


    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = GCNNet().to(device)
    optimizer = torch.optim.Adam(model.parameters(), lr=LR)

    best_auc = -1
    model_file_name = 'weights/tmpGCN.model'
    #result_file_name = 'detailed_loss.txt'

    auc2,los2 = [],[]
    auc1,los1=[],[]
    rate_tmp = 0
    for epoch in range(EPOCH):
        train(model, device, train_loader, optimizer, epoch + 1)
        rate1,loss1 = cal(model, device, train_cal_loader, train_label)
        print(" train_auc: " + str(rate1)+", train_loss: "+str(loss1))
        rate2,loss2 = cal(model, device, valid_cal_loader, valid_label)
        print(" valid_auc: " + str(rate2))
        print("\n")

        auc1.append(rate1)
        los1.append(loss1)
        auc2.append(rate2)
        los2.append(loss2)

        if epoch > 4:
            tmp = np.array(auc2[-3:])
            rate_tmp = tmp.mean()

        if rate_tmp > best_auc and rate_tmp >= 0.5 and epoch > 4:
            #torch.save(model.state_dict(), model_file_name)
            best_auc = rate_tmp
            print("best_auc:" + str(best_auc))

    #log the  loss changing process
    #final_arr="auc1: "+str(auc1)+'\n\n'+'auc2: '+str(auc2)+'\n\n'+'loss1: '+str(los1)+'\n\n'+'loss2: '+str(los2)
    #with open(result_file_name, 'w') as f:
        #f.write(final_arr)
    #print("finish writing")

    #final_data = np.array(auc2[-5:])
    #print(np.mean(final_data), np.var(final_data))
    print("final best_auc:" + str(best_auc))

