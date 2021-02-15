# _*_ coding: UTF-8 _*_
# 93738
# Time: 2020/12/17 20:57
# Name:GetData
# Tools: PyCharm
import networkx as nx
from rdkit import Chem
import numpy as np
import torch
import dgl

symbol_to_num = ['unknown','C','O', 'N', 'Br', 'Cl', 'Na', 'S', 'P', 'Ca', 'F', 'B', 'As', 'Al', 'I', 'Si', 'K', 'Cr', 'Zn', 'Se',
 'Zr', 'Fe', 'Sn', 'Nd', 'Cu','Au', 'Pb', 'Tl', 'Sb', 'Cd', 'Pd', 'Ti', 'H', 'Pt', 'In', 'Ba', 'Ag', 'Dy', 'Hg', 'Li', 'Yb',
 'Mn', 'Mg', 'Co', 'Ni', 'Be', 'Ge', 'Bi', 'V', 'Sr', 'Mo']
invalid_test = []

def get_train_data():
    train_smile = []
    with open("../train/names_smiles.txt") as train_smile_f:
        train_smile_f.readline()
        for line in train_smile_f:
            tmp = line.split(',')
            tmp = tmp[1].split('\n')[0]
            train_smile.append(tmp)

    train_label = []
    with open("../train/names_labels.txt") as train_label_f:
        train_label_f.readline()
        for line in train_label_f:
            tmp = line.split(',')
            tmp = tmp[1].split('\n')[0]
            train_label.append(int(tmp))

    return train_smile, train_label


def get_valid_data():
    valid_smile = []
    with open("../validation/names_smiles.txt") as valid_smile_f:
        valid_smile_f.readline()
        for line in valid_smile_f:
            tmp = line.split(',')
            tmp = tmp[1].split('\n')[0]
            valid_smile.append(tmp)

    valid_label = []
    with open("../validation/names_labels.txt") as valid_label_f:
        valid_label_f.readline()
        for line in valid_label_f:
            tmp = line.split(',')
            tmp = tmp[1].split('\n')[0]
            valid_label.append(int(tmp))
    return valid_smile, valid_label


def get_test_data():
    test_smile = []
    test_name = []
    with open("../test/names_smiles.txt") as test_smile_f:
        test_smile_f.readline()
        for line in test_smile_f:
            tmp = line.split(',')
            name = tmp[0]
            tmp = tmp[1].split('\n')[0]
            test_name.append(name)
            test_smile.append(tmp)

    return test_smile, test_name


def get_feature(list_smile, list_label, is_train_test):
    symbol_fea = []
    other_fea = []
    invalid = []
    edges = []
    total_feature = []
    train_g = []

    '''
     get the feature_data and smile from smile_string without deeply processing
    '''
    for smile in list_smile:
        tmp_symbol_fea = []
        tmp_other_fea = []
        mol = Chem.MolFromSmiles(smile)

        if not mol:
            ind = list_smile.index(smile)
            invalid.append(ind)
        else:
            atom_num = mol.GetNumAtoms()
            for atom in mol.GetAtoms():
                # map atom-symbol into num
                s = atom.GetSymbol()
                if is_train_test == 0:
                    if s in symbol_to_num:
                        tmp_symbol_fea.append(symbol_to_num.index(s))
                    else:
                        symbol_to_num.append(s)
                        tmp_symbol_fea.append(symbol_to_num.index(s))
                elif s in symbol_to_num:
                    tmp_symbol_fea.append(symbol_to_num.index(s))
                else:
                    tmp_symbol_fea.append(0)
                # get other atom fea
                tmp_other_fea.append(
                    [atom.GetDegree(), atom.GetTotalNumHs(), atom.GetImplicitValence(), int(atom.GetIsAromatic())])

            symbol_fea.append(tmp_symbol_fea)
            other_fea.append(tmp_other_fea)

            mol_edges = []
            for bond in mol.GetBonds():
                mol_edges.append([bond.GetBeginAtomIdx(), bond.GetEndAtomIdx()])
            g = nx.Graph(mol_edges).to_directed()

            mol_edge_src = []
            mol_edge_dst = []
            for e1, e2 in g.edges:
                # edges[0].append(e1)
                # edges[1].append(e2)
                mol_edge_src.append(e1)
                mol_edge_dst.append(e2)

            if len(mol_edge_src) == 0:
                # g=[[atom_num-1],[atom_num-1]]
                g = dgl.DGLGraph(([atom_num - 1], [atom_num - 1]))
                g = dgl.add_self_loop(g)
            else:
                g = dgl.DGLGraph((np.array(mol_edge_src), np.array(mol_edge_dst)))
                g = dgl.add_self_loop(g)
                #g = [mol_edge_src, mol_edge_dst]
            edges.append(g)

    '''delete the invalid smile in label'''
    if is_train_test != 2:
        for i in range(len(invalid)):
            del list_label[invalid[i] - i]
    else:
        for i in invalid:
            invalid_test.append(i)
            #print("invalid: " + str(i))

    '''aggregate the whole data'''
    symbol_num = len(symbol_to_num)

    for mol_s, mol_other, g, label in zip(symbol_fea, other_fea, edges, list_label):
        mol_feature = []
        for atom_s, atom_o in zip(mol_s, mol_other):
            tmp_table1 = np.zeros(symbol_num, int)
            tmp_table1[atom_s] = 1
            tmp_table2 = np.zeros(7, int)
            tmp_table2[atom_o[0]] = 1
            tmp_table3 = np.zeros(7, int)
            tmp_table3[atom_o[1]] = 1
            tmp_table4 = np.zeros(7, int)
            tmp_table4[atom_o[2]] = 1
            tmp_table5 = np.array([atom_o[3]])

            atom_fea = np.concatenate((tmp_table1, tmp_table2, tmp_table3))
            atom_fea = np.concatenate((atom_fea, tmp_table4, tmp_table5))
            atom_fea = atom_fea / sum(atom_fea)
            atom_fea=atom_fea.astype(np.double)

            mol_feature.append(atom_fea)

        fea = torch.tensor(mol_feature)
        # print(fea)

        try:
            g.ndata['feat'] = fea
        except BaseException:
            a=symbol_fea.index(mol_s)
            print(g)
            print(fea.size())
            print("error {}".format(a))
        else:
            train_g.append((g,label))
        # total_feature.append(fea)

    return train_g
