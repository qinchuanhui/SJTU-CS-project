# _*_ coding: UTF-8 _*_
# 93738
# Time: 2020/12/17 21:16
# Name:GCN
# Tools: PyCharm
import torch
import torch.nn as nn
from dgl.nn.pytorch import *
import dgl


class GCNNet(nn.Module):
    def __init__(self, num_features_xd=73, dropout=0.5):
        super(GCNNet, self).__init__()
        # self.conv1 = TAGConv(num_features_xd, num_features_xd)
        # self.conv2 = TAGConv(num_features_xd, num_features_xd * 2)
        # self.conv3 = TAGConv(num_features_xd * 2, num_features_xd * 2)
        # self.conv2 = GATConv(num_features_xd, num_features_xd * 2, 1)
        # self.conv3 = GATConv(num_features_xd * 2, num_features_xd * 2, 1)
        self.conv1 = GATConv(num_features_xd, num_features_xd,1)
        self.conv2 = TAGConv(num_features_xd, num_features_xd * 2)
        self.conv3 = TAGConv(num_features_xd * 2, num_features_xd * 2)


        self.fc1 = torch.nn.Linear(num_features_xd * 2, 256)
        self.fc2 = nn.Linear(256, 1)

        self.relu = nn.ReLU()
        self.sig = nn.Sigmoid()
        self.dropout = nn.Dropout(dropout)

    def forward(self, g):
        inputs = g.ndata['feat'].view(-1, 73).float()


        h = self.conv1(g, inputs)
        h = self.relu(h)
        h = self.dropout(h)

        h = self.conv2(g, h)
        h = self.relu(h)
        h = self.dropout(h)


        h = self.conv3(g, h)
        h = self.relu(h)


        g.ndata['h'] = h
        h = dgl.max_nodes(g, 'h')

        # full connect
        h = h.reshape((-1, 73*2))
        h = self.fc1(h)
        h = self.sig(h)
        h = self.dropout(h)

        h = self.fc2(h)
        out = self.sig(h)

        return out
