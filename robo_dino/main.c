#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct {
    float x, y, z;
} Vertex;

typedef struct {
    int v1, v2, v3;
} Face;

void write_ply(const char* filename, Vertex vertices[], int num_vertices, Face faces[], int num_faces) {
    FILE *ply_file = fopen(filename, "w");
    if (!ply_file) {
        printf("Erro ao abrir o arquivo!\n");
        return;
    }

    fprintf(ply_file, "ply\n");
    fprintf(ply_file, "format ascii 1.0\n");
    fprintf(ply_file, "element vertex %d\n", num_vertices);
    fprintf(ply_file, "property float x\n");
    fprintf(ply_file, "property float y\n");
    fprintf(ply_file, "property float z\n");
    fprintf(ply_file, "element face %d\n", num_faces);
    fprintf(ply_file, "property list uchar int vertex_indices\n");
    fprintf(ply_file, "end_header\n");

    for (int i = 0; i < num_vertices; i++) {
        fprintf(ply_file, "%f %f %f\n", vertices[i].x, vertices[i].y, vertices[i].z);
    }

    for (int i = 0; i < num_faces; i++) {
        fprintf(ply_file, "3 %d %d %d\n", faces[i].v1, faces[i].v2, faces[i].v3);
    }

    fclose(ply_file);
    printf("Arquivo PLY '%s' foi gerado.\n", filename);
}

void create_rectangle(const char* filename, float width, float height, float x_offset, float y_offset, float z_offset) {
    Vertex vertices[4];
    Face faces[2];

    vertices[0] = (Vertex){x_offset - width / 2, y_offset - height / 2, z_offset};
    vertices[1] = (Vertex){x_offset + width / 2, y_offset - height / 2, z_offset};
    vertices[2] = (Vertex){x_offset + width / 2, y_offset + height / 2, z_offset};
    vertices[3] = (Vertex){x_offset - width / 2, y_offset + height / 2, z_offset};

    faces[0] = (Face){0, 1, 2};
    faces[1] = (Face){0, 2, 3};

    write_ply(filename, vertices, 4, faces, 2);
}

void create_cube(const char* filename, float side_length, float x_offset, float y_offset, float z_offset) {
    Vertex vertices[8];
    Face faces[12];

    float half_side = side_length / 2;

    vertices[0] = (Vertex){x_offset - half_side, y_offset - half_side, z_offset - half_side};
    vertices[1] = (Vertex){x_offset + half_side, y_offset - half_side, z_offset - half_side};
    vertices[2] = (Vertex){x_offset + half_side, y_offset + half_side, z_offset - half_side};
    vertices[3] = (Vertex){x_offset - half_side, y_offset + half_side, z_offset - half_side};
    vertices[4] = (Vertex){x_offset - half_side, y_offset - half_side, z_offset + half_side};
    vertices[5] = (Vertex){x_offset + half_side, y_offset - half_side, z_offset + half_side};
    vertices[6] = (Vertex){x_offset + half_side, y_offset + half_side, z_offset + half_side};
    vertices[7] = (Vertex){x_offset - half_side, y_offset + half_side, z_offset + half_side};

    faces[0] = (Face){0, 1, 2}; faces[1] = (Face){0, 2, 3};
    faces[2] = (Face){4, 5, 6}; faces[3] = (Face){4, 6, 7};
    faces[4] = (Face){0, 1, 5}; faces[5] = (Face){0, 5, 4};
    faces[6] = (Face){1, 2, 6}; faces[7] = (Face){1, 6, 5};
    faces[8] = (Face){2, 3, 7}; faces[9] = (Face){2, 7, 6};
    faces[10] = (Face){3, 0, 4}; faces[11] = (Face){3, 4, 7};

    write_ply(filename, vertices, 8, faces, 12);
}


void create_cone(const char* filename, int num_segments, float radius, float height, float x_offset, float y_offset, float z_offset) {
    Vertex* vertices = (Vertex*)malloc((num_segments + 2) * sizeof(Vertex));
    Face* faces = (Face*)malloc(num_segments * 2 * sizeof(Face));

    vertices[0] = (Vertex){x_offset, y_offset, z_offset}; // Centro da base
    vertices[num_segments + 1] = (Vertex){x_offset, y_offset, height + z_offset}; // Ponta do cone

    for (int i = 0; i < num_segments; i++) {
        float angle = 2 * M_PI * i / num_segments;
        vertices[i + 1] = (Vertex){radius * cos(angle) + x_offset, radius * sin(angle) + y_offset, z_offset};
    }

    int face_index = 0;
    for (int i = 0; i < num_segments; i++) {
        int next = (i + 1) % num_segments;
        faces[face_index++] = (Face){0, i + 1, next + 1}; // Faces da base
        faces[face_index++] = (Face){num_segments + 1, next + 1, i + 1}; // Faces laterais
    }

    write_ply(filename, vertices, num_segments + 2, faces, face_index);

    free(vertices);
    free(faces);
}

void create_hexagon(const char* filename, float radius, float height, float x_offset, float y_offset, float z_offset) {
    const int num_sides = 6;
    Vertex vertices[num_sides * 2];
    Face faces[num_sides * 4];

    for (int i = 0; i < num_sides; i++) {
        float angle = 2 * M_PI * i / num_sides;
        vertices[i] = (Vertex){radius * cos(angle) + x_offset, radius * sin(angle) + y_offset, z_offset - height / 2};
        vertices[i + num_sides] = (Vertex){radius * cos(angle) + x_offset, radius * sin(angle) + y_offset, z_offset + height / 2};
    }

    int face_index = 0;
    for (int i = 0; i < num_sides; i++) {
        int next = (i + 1) % num_sides;
        faces[face_index++] = (Face){i, next, i + num_sides};
        faces[face_index++] = (Face){next, next + num_sides, i + num_sides};
    }

    for (int i = 0; i < num_sides; i++) {
        int next = (i + 1) % num_sides;
        faces[face_index++] = (Face){i, next, 0};
        faces[face_index++] = (Face){i + num_sides, next + num_sides, num_sides};
    }

    write_ply(filename, vertices, num_sides * 2, faces, face_index);
}



int main() {
    create_rectangle("rectangle.ply", 20.0, 10.0, 0.0, 0.0, 0.0);
    create_cube("cube.ply", 20.0, 0.0, 0.0, 0.0);
    create_cone("cone.ply", 50, 10.0, 20.0, 0.0, 0.0, 0.0);
    create_hexagon("hexagon.ply", 10.0, 5.0, 0.0, 0.0, 0.0);


    return 0;
}
