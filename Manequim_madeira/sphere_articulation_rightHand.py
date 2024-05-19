import numpy as np

def create_head(radius_x, radius_y, radius_z, num_segments):
    vertices = []
    faces = []

    for i in range(num_segments + 1):
        phi = i * 2 * np.pi / num_segments
        for j in range(num_segments // 2 + 1):
            theta = j * np.pi / (num_segments // 2)

            x = radius_x * np.sin(theta) * np.cos(phi)
            y = radius_y * np.sin(theta) * np.sin(phi) + 42
            z = radius_z * np.cos(theta) + 103

            vertices.append([x, y, z])

    for i in range(num_segments):
        for j in range(num_segments // 2):
            v0 = i * (num_segments // 2 + 1) + j
            v1 = v0 + 1
            v2 = v0 + num_segments // 2 + 1
            v3 = v1 + num_segments // 2 + 1

            faces.append([v0, v1, v2])
            faces.append([v1, v3, v2])

    return vertices, faces



def save_to_ply(vertices, faces, filename):
    with open(filename, 'w') as ply_file:
        ply_file.write('ply\n')
        ply_file.write('format ascii 1.0\n')
        ply_file.write(f'element vertex {len(vertices)}\n')
        ply_file.write('property float x\n')
        ply_file.write('property float y\n')
        ply_file.write('property float z\n')
        ply_file.write(f'element face {len(faces)}\n')
        ply_file.write('property list uchar int vertex_indices\n')
        ply_file.write('end_header\n')

        for vertex in vertices:
            ply_file.write(f'{vertex[0]} {vertex[1]} {vertex[2]}\n')

        for face in faces:
            ply_file.write(f'3 {face[0]} {face[1]} {face[2]}\n')

radius_x = 7.5
radius_y = 7.5
radius_z = 7.5
num_segments = 50
vertices, faces = create_head(radius_x, radius_y, radius_z, num_segments)
save_to_ply(vertices, faces, 'articulation_rightHand.ply')