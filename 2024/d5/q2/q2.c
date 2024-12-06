
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#define MAX_KEYS 100

typedef struct {
    int *values;
    int size;
    int capacity;
} DynamicArray;

void initDynamicArray(DynamicArray *a, int initialCapacity) {
    a->values = (int *)malloc(initialCapacity * sizeof(int));
    a->size = 0;
    a->capacity = initialCapacity;
}

void insertDynamicArray(DynamicArray *a, int value) {
    if (a->size == a->capacity) {
        a->capacity *= 2;
        a->values = (int *)realloc(a->values, a->capacity * sizeof(int));
    }
    a->values[a->size++] = value;
}

void freeDynamicArray(DynamicArray *a) {
    free(a->values);
    a->values = NULL;
    a->size = a->capacity = 0;
}


bool dynamicArrayContains(DynamicArray *a, int value) {
    for (int i = 0; i < a->size; i++) {
        if (a->values[i] == value) {
            return true;
        }
    }
    return false;
}

int *nthElement(DynamicArray *a, int n) {
    return &a->values[n];
}

void printDynamicArray(DynamicArray *a) {
    for (int i = 0; i < a->size; i++) {
        printf("%d ", a->values[i]);
    }
}

void insertAt(DynamicArray *a, int index, int value) {
    DynamicArray newArray;
    initDynamicArray(&newArray, a->capacity);
    for (int i = 0; i < index; i++) {
        insertDynamicArray(&newArray, a->values[i]);
    }
    insertDynamicArray(&newArray, value);
    for (int i = index; i < a->size; i++) {
        insertDynamicArray(&newArray, a->values[i]);
    }
    freeDynamicArray(a);
    *a = newArray;
}

int findIndex(DynamicArray *a, int value) {
    for (int i = 0; i < a->size; i++) {
        if (a->values[i] == value) {
            return i;
        }
    }
    return -1;
}

int main() {
    FILE *f = fopen("in.q2.txt", "r");

    DynamicArray map[MAX_KEYS];
    for (int i = 0; i < MAX_KEYS; i++) {
        initDynamicArray(&map[i], 10);
    }

    // keep reading lines of the form "XX:YY" until a line is empty
    char line[100];
    while (fgets(line, sizeof(line), f) != NULL) {
        if (strcmp(line, "\n") == 0) {
            break;
        }

        char *xx = strtok(line, "|");
        char *yy = strtok(NULL, "|");

        if (xx && yy) {
            int key = atoi(xx);
            int value = atoi(yy);
            insertDynamicArray(&map[key], value);
        }
    }

    int middlePageSum = 0;

    while (fgets(line, sizeof(line), f) != NULL) {
        char *token = strtok(line, ",");
        DynamicArray seen;
        initDynamicArray(&seen, 10);

        bool valid = true;
        while (token != NULL) {
            int value = atoi(token);
            int lowestIndex = -1;
            DynamicArray beforeMapping = map[value];
            for (int i = 0; i < beforeMapping.size; i++) {
                if (dynamicArrayContains(&seen, beforeMapping.values[i])) {
                    int index = findIndex(&seen, beforeMapping.values[i]);
                    if (lowestIndex == -1 || index < lowestIndex) {
                        lowestIndex = index;
                    }
                }
            }
            if (lowestIndex > -1) {
                insertAt(&seen, lowestIndex, value);
                valid = false;
            } else {
                insertDynamicArray(&seen, value);
            }
            token = strtok(NULL, ",");
        }

        if (!valid) {
            middlePageSum += *nthElement(&seen, seen.size / 2);
        }
    }

    printf("%d\n", middlePageSum);
    fclose(f);
    return 0;
}
