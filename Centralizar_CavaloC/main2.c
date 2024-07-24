#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#define NUM_VERTICES 48484
#define NUM_FACES 96964

typedef struct {
    float x, y, z;
} Vertex;

typedef struct {
    int v1, v2, v3;
} Face;

void read_ply(const char *filename, Vertex *vertices, Face *faces, char header[10][100]) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Could not open file %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < 10; i++) {
        if (fgets(header[i], 100, file) == NULL) {
            fprintf(stderr, "Error reading header line %d\n", i);
            exit(1);
        }
    }

    for (int i = 0; i < NUM_VERTICES; i++) {
        if (fscanf(file, "%f %f %f", &vertices[i].x, &vertices[i].y, &vertices[i].z) != 3) {
            fprintf(stderr, "Error reading vertex %d\n", i);
            exit(1);
        }
    }

    for (int i = 0; i < NUM_FACES; i++) {
        int vertices_count;
        if (fscanf(file, "%d %d %d %d", &vertices_count, &faces[i].v1, &faces[i].v2, &faces[i].v3) != 4) {
            fprintf(stderr, "Error reading face %d\n", i);
            exit(1);
        }
        if (vertices_count != 3) {
            fprintf(stderr, "Non-triangular face found at %d\n", i);
            exit(1);
        }
    }

    fclose(file);
}

void straighten_head(Vertex *vertices, float xc, float yc, float zc, float xmin, float ymean) {
    // Rotaciona os pontos da cabeça para alinhá-los
    for (int i = 0; i < NUM_VERTICES; i++) {
        if (vertices[i].x >= xmin && vertices[i].x <= xmin / 2 && vertices[i].y > ymean) {
            float dx = vertices[i].x - xc;
            float dz = vertices[i].z - zc;
            float angle = atan2(dz, dx); // ângulo atual

            float x_new = xc + cos(-angle) * dx - sin(-angle) * dz;
            float z_new = zc + sin(-angle) * dx + cos(-angle) * dz;

            vertices[i].x = x_new;
            vertices[i].z = z_new;
        }
    }
}

void write_ply(const char *filename, Vertex *vertices, Face *faces, char header[10][100]) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        fprintf(stderr, "Could not open file %s\n", filename);
        exit(1);
    }

    for (int i = 0; i < 10; i++) {
        fputs(header[i], file);
    }

    for (int i = 0; i < NUM_VERTICES; i++) {
        fprintf(file, "%f %f %f\n", vertices[i].x, vertices[i].y, vertices[i].z);
    }

    for (int i = 0; i < NUM_FACES; i++) {
        fprintf(file, "3 %d %d %d\n", faces[i].v1, faces[i].v2, faces[i].v3);
    }

    fclose(file);
}

int main() {
    Vertex *vertices = malloc(NUM_VERTICES * sizeof(Vertex));
    Face *faces = malloc(NUM_FACES * sizeof(Face));
    char header[10][100];

    if (vertices == NULL || faces == NULL) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    read_ply("horse.ply", vertices, faces, header);

    float xc = 0.0, yc = 0.0, zc = 0.0;
    for (int i = 0; i < NUM_VERTICES; i++) {
        xc += vertices[i].x;
        yc += vertices[i].y;
        zc += vertices[i].z;
    }
    xc /= NUM_VERTICES;
    yc /= NUM_VERTICES;
    zc /= NUM_VERTICES;

    float xmin = vertices[0].x;
    float ysum = 0.0;
    for (int i = 0; i < NUM_VERTICES; i++) {
        if (vertices[i].x < xmin) xmin = vertices[i].x;
        ysum += vertices[i].y;
    }
    float ymean = ysum / NUM_VERTICES;

    straighten_head(vertices, xc, yc, zc, xmin, ymean);

    write_ply("horse_headStraight.ply", vertices, faces, header);

    free(vertices);
    free(faces);

    return 0;
}
