import numpy as np
import math


##Mistura da criacao da esfera com a criacao do cilindro, vai ser utilizado para melhorar a cabeca depois
def create_head(radius_x, radius_y, radius_z, num_segments):
    vertices = []
    faces = []

    for i in range(num_segments // 3 + 1):
        phi = i * 2 * np.pi / num_segments
        for j in range(num_segments // 6 + 1):
            theta = j * np.pi / (num_segments // 6)

            x = radius_x * np.sin(theta) * np.cos(phi)
            y = radius_y * np.sin(theta) * np.sin(phi)
            z = radius_z * np.cos(theta) - 72

            vertices.append([x, y, z])

    for i in range(num_segments // 3):
        for j in range(num_segments // 6):
            v0 = i * (num_segments // 6 + 1) + j
            v1 = v0 + 1
            v2 = v0 + num_segments // 6 + 1
            v3 = v1 + num_segments // 6 + 1

            faces.append([v0, v1, v2])
            faces.append([v1, v3, v2])

    return vertices, faces

def create_cylinder(radius_1_x, radius_1_y, radius_2_x, radius_2_y, distance_between_spheres, num_segments):
    def create_circle(radius_x, radius_y,z, num_segments):
        circle_vertices = []
        for i in range(num_segments):
            angle = 2 * math.pi * i / num_segments
            x = radius_x * math.cos(angle)
            y = radius_y * math.sin(angle)
            circle_vertices.append((x, y, z))
        return circle_vertices

    circle1 = create_circle(radius_1_x, radius_1_y, -distance_between_spheres/2 , num_segments)
    circle2 = create_circle(radius_2_x,radius_2_y,  distance_between_spheres/2 , num_segments)

    vertices = []
    vertices.extend(circle1)
    vertices.extend(circle2)

    faces = []
    for i in range(num_segments):
        vertex_index1 = i
        vertex_index2 = (i + 1) % num_segments
        vertex_index3 = i + num_segments
        vertex_index4 = (i + 1) % num_segments + num_segments

        faces.append((vertex_index1, vertex_index2, vertex_index3))
        faces.append((vertex_index2, vertex_index4, vertex_index3))

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

radius_x = 20
radius_y = 20
radius_z = 30
num_segments = 50
vertices_head, faces_head = create_head(radius_x, radius_y, radius_z, num_segments)

radius_1_x = 18.0  
radius_1_y = 33.0 
radius_2_x = 18.0  
radius_2_y = 25.0 
distance_between_spheres = 70.0  
vertices_cylinder, faces_cylinder = create_cylinder(radius_1_x, radius_1_y, radius_2_x, radius_2_y, distance_between_spheres, num_segments)

vertices = vertices_head + vertices_cylinder
faces = faces_head + [[i[0]+len(vertices_head), i[1]+len(vertices_head), i[2]+len(vertices_head)] for i in faces_cylinder]

save_to_ply(vertices, faces, 'head_test.ply')


