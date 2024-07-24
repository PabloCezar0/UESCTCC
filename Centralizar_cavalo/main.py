import numpy as np

def read_ply(file):
    with open(file, 'r') as f:
        lines = f.readlines()
    vertices = []
    faces = []
    num_vertices = 48484
    for i, line in enumerate(lines[10:]):
        if i < num_vertices:
            vertices.append(list(map(float, line.split())))
        elif line.startswith('3'):
            faces.append(list(map(int, line.split()[1:])))
    return np.array(vertices), np.array(faces), lines[:10]

def rotate_head(vertices, xmin, ymean):
    theta = 90  # Ângulo de rotação de 90 graus
    rotation_matrix = np.array([
        [np.cos(theta), 0, np.sin(theta)],
        [0, 1, 0],
        [-np.sin(theta), 0, np.cos(theta)]
    ])
    head = (vertices[:, 0] >= xmin) & (vertices[:, 0] <= xmin/2) & (vertices[:, 1] > ymean)  # Seleciona os vértices da cabeça do cavalo
    vertices[head] = np.dot(vertices[head], rotation_matrix.T)  # Aplica a rotação com produto cartesiano
    return vertices

def write_ply(vertices, faces, header, file):
    with open(file, 'w') as f:
        f.writelines(header)
        for vertex in vertices:
            f.write(' '.join(map(str, vertex)) + '\n')
        for face in faces:
            f.write('3 ' + ' '.join(map(str, face)) + '\n')

def main():
    vertices, faces, header = read_ply('horse.ply')
    xmin = np.min(vertices[:, 0])  # Calcula o valor mínimo de x
    ymean = np.mean(vertices[:, 1])  # Calcula a média de y
    vertices = rotate_head(vertices, xmin, ymean)  # Aplica a rotação
    write_ply(vertices, faces, header, 'horse_headRot90.ply')

main()
