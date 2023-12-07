import matplotlib.pyplot as plt
import numpy as np
import networkx as nx

G = nx.MultiGraph()
# draw rectangular graph
G.add_nodes_from(['a','b','c','d','e','f'])
G.add_edges_from([('a','b'),('b','c'),('c','d'),('d','e'),('e','f'),('f','a'),('c','e'),('b','e')])

# compute centralities
betweenness = nx.betweenness_centrality(G).values()
degree = nx.degree_centrality(G).values()
closeness = nx.closeness_centrality(G).values()
# eigen = nx.eigenvector_centrality(G).values()

real_val = [7,4.5,3,6,5.5,5.5]

# e is unknown

print('nodes: ', G.nodes())
print('betweenness: ', betweenness)
print('degree: ', degree)
print('closeness: ', closeness)
# print('eigen: ', eigen)

nx.draw(G, with_labels=True)
plt.show()

# remove e from degree, betweenness, and closeness and real_val
betweenness = list(betweenness)
degree = list(degree)
closeness = list(closeness)
# eigen = list(eigen)
real_val = real_val

pred_b = betweenness.pop(4)
pred_d = degree.pop(4)
pred_c = closeness.pop(4)
# pred_e = eigen.pop(4)
real_new = real_val.pop(4)


# train perceptron to predict real_val
x = np.array([betweenness, degree])
y = np.array(real_val)

# initialize weights
w = np.array([0,0])
b = 0

# learning rate
eta = 0.1

# number of iterations
n = 1000

# train perceptron
for i in range(n):
    for j in range(len(x)):
        if (y[j] - (np.dot(w, x[:,j]) + b)) >= 0:
            w = w + eta * x[:,j]
            b = b + eta
        elif (y[j] - (np.dot(w, x[:,j]) + b)) < 0:
            w = w - eta * x[:,j]
            b = b - eta

# plot real_val vs. predicted values
plt.figure()
plt.plot(real_val, label='Real Values')
plt.plot(np.dot(w, x) + b, label='Predicted Values')
plt.legend()
plt.xlabel('Node')
plt.ylabel('Real Value')
plt.title('Real Values vs. Predicted Values')
plt.show()

# predict real_val for new data
new_x = np.array([pred_b,pred_d])
new_y = np.dot(w, new_x) + b
print('Predicted real_val for new data: ', new_y)
print('error: ', abs(new_y - real_new))


