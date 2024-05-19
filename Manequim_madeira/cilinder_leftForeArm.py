import math

vertices = []
faces = []

num_segments = 50  
radius_1_x = 10.0  
radius_1_y = 7.5 
radius_2_x = 10.0  
radius_2_y = 7.8 
distance_between_spheres = 60.0  


def create_circle(radius_x, radius_y,z, num_segments):
    circle_vertices = []
    for i in range(num_segments):
        angle = 2 * math.pi * i / num_segments
        x = radius_x * math.cos(angle)
        y = radius_y * math.sin(angle) - 42
        circle_vertices.append((x, y, z))
    return circle_vertices


circle1 = create_circle(radius_1_x, radius_1_y, -distance_between_spheres/2 + 70, num_segments)
circle2 = create_circle(radius_2_x,radius_2_y,  distance_between_spheres/2 + 70, num_segments)


vertices.extend(circle1)
vertices.extend(circle2)

# Criar faces para conectar os vértices dos dois círculos (cilindro)
for i in range(num_segments):
    vertex_index1 = i
    vertex_index2 = (i + 1) % num_segments
    vertex_index3 = i + num_segments
    vertex_index4 = (i + 1) % num_segments + num_segments

    faces.append((vertex_index1, vertex_index2, vertex_index3))
    faces.append((vertex_index2, vertex_index4, vertex_index3))

faces_teste = int(num_segments)

for i in range(faces_teste):
    vertex_index1 = i
    vertex_index2 = (i + num_segments // 2) % num_segments
    vertex_index3 = (i + 1) % num_segments
    vertex_index4 = (i + num_segments // 2 + 1) % num_segments

    faces.append((vertex_index1, vertex_index2, vertex_index3))

for i in range(faces_teste):
    vertex_index1 = i + num_segments
    vertex_index2 = ((i + num_segments // 2) % num_segments) + num_segments
    vertex_index3 = ((i + 1) % num_segments) + num_segments
    vertex_index4 = ((i + num_segments // 2 + 1) % num_segments) + num_segments

    faces.append((vertex_index3, vertex_index2, vertex_index1))

# Escrever os dados em um arquivo PLY
with open("cilinder_leftForeArm.ply", "w") as ply_file:
    ply_file.write("ply\n")
    ply_file.write("format ascii 1.0\n")
    ply_file.write("element vertex {}\n".format(len(vertices)))
    ply_file.write("property float x\n")
    ply_file.write("property float y\n")
    ply_file.write("property float z\n")
    ply_file.write("element face {}\n".format(len(faces)))
    ply_file.write("property list uchar int vertex_indices\n")
    ply_file.write("end_header\n")

    # Escrever vértices
    for vertex in vertices:
        ply_file.write("{} {} {}\n".format(vertex[0], vertex[1], vertex[2]))

    # Escrever faces
    for face in faces:
        ply_file.write("3 {} {} {}\n".format(face[0], face[1], face[2]))

print("Arquivo PLY 'cilinder_leftForeArm.ply' foi gerado.")