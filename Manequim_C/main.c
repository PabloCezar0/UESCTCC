#include <stdio.h>
#include <math.h>

typedef struct {
    float x, y, z;
} Vertex;

typedef struct {
    int v1, v2, v3;
} Face;

//CORPO
void create_circle(Vertex circle[], float radius_x, float radius_y, float z, float x_offset, float y_offset, int num_segments) {
    for (int i = 0; i < num_segments; i++) {
        float angle = 2 * M_PI * i / num_segments;
        circle[i].x = radius_x * cos(angle) + x_offset;
        circle[i].y = radius_y * sin(angle) + y_offset;
        circle[i].z = z;
    }
}

void create_cylinder(const char* filename, int num_segments, float radius_1_x, float radius_1_y, float radius_2_x, float radius_2_y, float distance_between_spheres, float x_offset, float y_offset, float z_offset) {
    Vertex vertices[num_segments * 2];
    Face faces[num_segments * 4];

    Vertex circle1[num_segments];
    Vertex circle2[num_segments];

    create_circle(circle1, radius_1_x, radius_1_y, -distance_between_spheres / 2 + z_offset, x_offset, y_offset, num_segments);
    create_circle(circle2, radius_2_x, radius_2_y, distance_between_spheres / 2 + z_offset, x_offset, y_offset, num_segments);

    for (int i = 0; i < num_segments; i++) {
        vertices[i] = circle1[i];
        vertices[i + num_segments] = circle2[i];
    }

    int face_index = 0;

    for (int i = 0; i < num_segments; i++) {
        int vertex_index1 = i;
        int vertex_index2 = (i + 1) % num_segments;
        int vertex_index3 = i + num_segments;
        int vertex_index4 = (i + 1) % num_segments + num_segments;

        faces[face_index++] = (Face){vertex_index1, vertex_index2, vertex_index3};
        faces[face_index++] = (Face){vertex_index2, vertex_index4, vertex_index3};
    }

    for (int i = 0; i < num_segments; i++) {
        int vertex_index1 = i;
        int vertex_index2 = (i + num_segments / 2) % num_segments;
        int vertex_index3 = (i + 1) % num_segments;
        int vertex_index4 = (i + num_segments / 2 + 1) % num_segments;

        faces[face_index++] = (Face){vertex_index1, vertex_index2, vertex_index3};
    }

    for (int i = 0; i < num_segments; i++) {
        int vertex_index1 = i + num_segments;
        int vertex_index2 = ((i + num_segments / 2) % num_segments) + num_segments;
        int vertex_index3 = ((i + 1) % num_segments) + num_segments;
        int vertex_index4 = ((i + num_segments / 2 + 1) % num_segments) + num_segments;

        faces[face_index++] = (Face){vertex_index3, vertex_index2, vertex_index1};
    }

    FILE *ply_file = fopen(filename, "w");
    if (!ply_file) {
        printf("Erro ao abrir o arquivo!\n");
        return;
    }

    fprintf(ply_file, "ply\n");
    fprintf(ply_file, "format ascii 1.0\n");
    fprintf(ply_file, "element vertex %d\n", num_segments * 2);
    fprintf(ply_file, "property float x\n");
    fprintf(ply_file, "property float y\n");
    fprintf(ply_file, "property float z\n");
    fprintf(ply_file, "element face %d\n", face_index);
    fprintf(ply_file, "property list uchar int vertex_indices\n");
    fprintf(ply_file, "end_header\n");

    for (int i = 0; i < num_segments * 2; i++) {
        fprintf(ply_file, "%f %f %f\n", vertices[i].x, vertices[i].y, vertices[i].z);
    }

    for (int i = 0; i < face_index; i++) {
        fprintf(ply_file, "3 %d %d %d\n", faces[i].v1, faces[i].v2, faces[i].v3);
    }

    fclose(ply_file);

    printf("Arquivo PLY '%s' foi gerado.\n", filename);
}


//ARTICULACAO
void create_sphere(const char* filename, int num_segments, float radius_x, float radius_y, float radius_z, float x_offset, float y_offset, float z_offset) {
    int num_vertices = (num_segments + 1) * (num_segments / 2 + 1);
    int num_faces = num_segments * num_segments / 2 * 2;

    Vertex vertices[num_vertices];
    Face faces[num_faces];

    int vertex_index = 0;
    for (int i = 0; i <= num_segments; i++) {
        float phi = i * 2 * M_PI / num_segments;
        for (int j = 0; j <= num_segments / 2; j++) {
            float theta = j * M_PI / (num_segments / 2);

            float x = radius_x * sin(theta) * cos(phi) + x_offset;
            float y = radius_y * sin(theta) * sin(phi) + y_offset;
            float z = radius_z * cos(theta) + z_offset;

            vertices[vertex_index++] = (Vertex){x, y, z};
        }
    }

    int face_index = 0;
    for (int i = 0; i < num_segments; i++) {
        for (int j = 0; j < num_segments / 2; j++) {
            int v0 = i * (num_segments / 2 + 1) + j;
            int v1 = v0 + 1;
            int v2 = v0 + (num_segments / 2 + 1);
            int v3 = v1 + (num_segments / 2 + 1);

            faces[face_index++] = (Face){v0, v1, v2};
            faces[face_index++] = (Face){v1, v3, v2};
        }
    }

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

int main() {
	//nome, quantidade, raio1x, raio1y, raio2x, raio2y, distancia, xoff, yoff, zoff
	//CORPO
	create_cylinder("cilinder_body.ply", 50, 18.0, 33.0, 18.0, 25.0, 70.0, 0.0, 0.0, 0.0);
	
	create_cylinder("cilinder_waist.ply", 50, 18.0, 25.0, 18.0, 28.0, 30.0, 0.0, 0.0, 60.0);
	
    create_cylinder("cilinder_leftArm.ply", 50, 10.0, 8.5, 10.0, 7.5, 52.0, 0.0, -42.0, 4.0);
	create_cylinder("cilinder_leftForeArm.ply", 50, 10.0, 7.5, 10.0, 7.8, 60.0, 0.0, -42.0, 66.0);
	
	create_cylinder("cilinder_leftKnee.ply", 50, 10.0, 9.5, 10.0, 7.8, 70.0, 0.0, -16.0, 188.0);
	create_cylinder("cilinder_leftLeg.ply", 50, 10.0, 13.5, 10.0, 9.8, 60.0, 0.0, -16.0, 115.0);
	
	create_cylinder("cilinder_rightArm.ply", 50, 10.0, 8.5, 10.0, 7.5, 52.0, 0.0, 42.0, 4.0);
	create_cylinder("cilinder_rightForeArm.ply", 50, 10.0, 7.5, 10.0, 7.8, 60.0, 0.0, 42.0, 66.0);
	
	create_cylinder("cilinder_rightKnee.ply", 50, 10.0, 9.5, 10.0, 7.8, 70.0, 0.0, 16.0, 188.0);
	create_cylinder("cilinder_rightLeg.ply", 50, 10.0, 13.5, 10.0, 9.8, 60.0, 0.0, 16.0, 115.0);
	
	

	//nome, quantidade, raiox, raioy, raioz, xoff, yoff, zoff
	//ARTICULACAO
	create_sphere("head.ply", 50, 20.0, 20.0, 30.0, 0.0, 0.0, -72.0);
	create_sphere("articulation_head.ply", 50, 10.0, 10.0, 10.0, 0.0, 0.0, -42.0);
	
	create_sphere("articulation_leftArm.ply", 50, 10.0, 12.0, 10.0, 0.0, -42.0, -28.0);
	create_sphere("articulation_leftForeArm.ply", 50, 10.0, 7.5, 7.5, 0.0, -42.0, 33.0);
	create_sphere("articulation_leftHand.ply", 50, 7.5, 7.5, 7.5, 0.0, -42.0, 99.0);
	
	create_sphere("articulation_leftFoot.ply", 50, 10.0, 7.5, 7.5, 0.0, -16.0, 225.0);
	create_sphere("articulation_leftKnee.ply", 50, 10.0, 8.5, 8.5, 0.0, -16.0, 150.0);
	create_sphere("articulation_leftLeg.ply", 50, 9.0, 13.0, 13.0, 0.0, -16.0, 83.0);
	
	create_sphere("articulation_rightArm.ply", 50, 10.0, 12.0, 10.0, 0.0, 42.0, -28.0);
	create_sphere("articulation_rightForeArm.ply", 50, 10.0, 7.5, 7.5, 0.0, 42.0, 33.0);
	create_sphere("articulation_rightHand.ply", 50, 7.5, 7.5, 7.5, 0.0, 42.0, 99.0);
	
	create_sphere("articulation_rightFoot.ply", 50, 10.0, 7.5, 7.5, 0.0, 16.0, 225.0);
	create_sphere("articulation_rightKnee.ply", 50, 10.0, 8.5, 8.5, 0.0, 16.0, 150.0);
	create_sphere("articulation_rightLeg.ply", 50, 9.0, 13.0, 13.0, 0.0, 16.0, 83.0);
	
	create_sphere("articulation_waist.ply", 50, 18.0, 24.0, 15.0, 0.0, 0.0, 40.0);
	
	   
	   
    return 0;
}
