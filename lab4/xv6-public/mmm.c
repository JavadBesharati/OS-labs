#include "types.h"
#include "user.h"
#include "fcntl.h"

static void
int_validation(const char *str)
{
    while(*str){
        if((*str < '0') || (*str > '9')){
            printf(1, "Invalid Input! Fuck you idiot\n");
            exit();
        }
        ++str;
    }
    
    return;
}

int atoi_neg(const char* str) {
    int sign = 1;

    if (*str == '-') {
        sign = -1;
        ++str;
    }
    else if (*str == '+') {
        ++str;
    }

    int_validation(str);

    return sign * atoi(str);
}

void bubble_sort(int len, int* numbers){
    for(int i = 0; i < len; i++){
        for(int j = 0; j < len - i - 1; j++){
            if(numbers[j] > numbers[j + 1]){
                int tmp = numbers[j + 1];
                numbers[j + 1] = numbers[j];
                numbers[j] = tmp;
            }
        }
    }
}

int calc_mean(int len, int numbers[]){
    int sum = 0;
    for(int i = 0; i < len; i++){
        sum += numbers[i];
    }
    return (int)(sum / len);
}

int calc_median(int len, int numbers[]){
    int median, idx = 0;
    if(len % 2 == 0){
        idx = len / 2;
        median = (int)((numbers[idx - 1] + numbers[idx]) / 2);
    }
    else{
        idx = (int)(len / 2);
        median = numbers[idx];
    }
    return median;
}

int calc_mode(int len, int numbers[]){
    int maxOccurence = 0;
    int mode = numbers[0];

    for(int i = 0; i < len; i++){
        int occurrenceCount = 0;
        for(int j = 0; j < len; j++){
            if(numbers[j] == numbers[i]){
                occurrenceCount++;
            }
        }
        if(occurrenceCount > maxOccurence){
            maxOccurence = occurrenceCount;
            mode = numbers[i];
        }
    }
    return mode;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf(1, "mmm: 1 arg required at least\n");
        exit();
    }
    
    int len = argc - 1;
    int numbers[len];
    
    for(int i = 0; i < len; i++){
        numbers[i] = atoi_neg(argv[i + 1]);
    }

    int mean = calc_mean(len, numbers);
    bubble_sort(len, numbers);
    int median = calc_median(len, numbers);
    int mode = calc_mode(len, numbers);

    unlink("mmm_result.txt");
    int file_handler = open("mmm_result.txt", O_CREATE | O_WRONLY);
    if(file_handler < 0) {
        printf(1, "mmm: cannot create mmm_result.txt\n");
        exit();
    }

    printf(file_handler, "%d %d %d\n", mean, median, mode);
    close(file_handler);
    exit();
}