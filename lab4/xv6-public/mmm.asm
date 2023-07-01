
_mmm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        }
    }
    return mode;
}

int main(int argc, char* argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 41 04             	mov    0x4(%ecx),%eax
  17:	8b 19                	mov    (%ecx),%ebx
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (argc < 2) {
  1c:	83 fb 01             	cmp    $0x1,%ebx
  1f:	7e 32                	jle    53 <main+0x53>
        printf(1, "mmm: 1 arg required at least\n");
        exit();
    }
    
    int len = argc - 1;
  21:	83 eb 01             	sub    $0x1,%ebx
    int numbers[len];
  24:	89 e1                	mov    %esp,%ecx
  26:	8d 04 9d 00 00 00 00 	lea    0x0(,%ebx,4),%eax
  2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  30:	83 c0 0f             	add    $0xf,%eax
  33:	89 c2                	mov    %eax,%edx
  35:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  3a:	83 e2 f0             	and    $0xfffffff0,%edx
  3d:	29 c1                	sub    %eax,%ecx
  3f:	39 cc                	cmp    %ecx,%esp
  41:	74 23                	je     66 <main+0x66>
  43:	81 ec 00 10 00 00    	sub    $0x1000,%esp
  49:	83 8c 24 fc 0f 00 00 	orl    $0x0,0xffc(%esp)
  50:	00 
  51:	eb ec                	jmp    3f <main+0x3f>
        printf(1, "mmm: 1 arg required at least\n");
  53:	51                   	push   %ecx
  54:	51                   	push   %ecx
  55:	68 cb 0a 00 00       	push   $0xacb
  5a:	6a 01                	push   $0x1
  5c:	e8 ff 06 00 00       	call   760 <printf>
        exit();
  61:	e8 1d 05 00 00       	call   583 <exit>
    int numbers[len];
  66:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  6c:	29 d4                	sub    %edx,%esp
  6e:	85 d2                	test   %edx,%edx
  70:	0f 85 c1 00 00 00    	jne    137 <main+0x137>
  76:	89 e6                	mov    %esp,%esi
    
    for(int i = 0; i < len; i++){
  78:	31 ff                	xor    %edi,%edi
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        numbers[i] = atoi_neg(argv[i + 1]);
  80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  83:	83 ec 0c             	sub    $0xc,%esp
  86:	ff 74 b8 04          	push   0x4(%eax,%edi,4)
  8a:	e8 c1 00 00 00       	call   150 <atoi_neg>
    for(int i = 0; i < len; i++){
  8f:	83 c4 10             	add    $0x10,%esp
        numbers[i] = atoi_neg(argv[i + 1]);
  92:	89 04 be             	mov    %eax,(%esi,%edi,4)
    for(int i = 0; i < len; i++){
  95:	83 c7 01             	add    $0x1,%edi
  98:	39 fb                	cmp    %edi,%ebx
  9a:	75 e4                	jne    80 <main+0x80>
  9c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  9f:	89 f0                	mov    %esi,%eax
    int sum = 0;
  a1:	31 ff                	xor    %edi,%edi
  a3:	01 f1                	add    %esi,%ecx
  a5:	8d 76 00             	lea    0x0(%esi),%esi
        sum += numbers[i];
  a8:	03 38                	add    (%eax),%edi
    for(int i = 0; i < len; i++){
  aa:	83 c0 04             	add    $0x4,%eax
  ad:	39 c1                	cmp    %eax,%ecx
  af:	75 f7                	jne    a8 <main+0xa8>
    }

    int mean = calc_mean(len, numbers);
    bubble_sort(len, numbers);
  b1:	83 ec 08             	sub    $0x8,%esp
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	e8 25 01 00 00       	call   1e0 <bubble_sort>
    int median = calc_median(len, numbers);
  bb:	5a                   	pop    %edx
  bc:	59                   	pop    %ecx
  bd:	56                   	push   %esi
  be:	53                   	push   %ebx
  bf:	e8 ac 01 00 00       	call   270 <calc_median>
  c4:	5a                   	pop    %edx
  c5:	59                   	pop    %ecx
    int mode = calc_mode(len, numbers);
  c6:	56                   	push   %esi
  c7:	53                   	push   %ebx
    int median = calc_median(len, numbers);
  c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int mode = calc_mode(len, numbers);
  cb:	e8 e0 01 00 00       	call   2b0 <calc_mode>

    unlink("mmm_result.txt");
  d0:	c7 04 24 e9 0a 00 00 	movl   $0xae9,(%esp)
    int mode = calc_mode(len, numbers);
  d7:	89 c6                	mov    %eax,%esi
    unlink("mmm_result.txt");
  d9:	e8 f5 04 00 00       	call   5d3 <unlink>
    int file_handler = open("mmm_result.txt", O_CREATE | O_WRONLY);
  de:	58                   	pop    %eax
  df:	5a                   	pop    %edx
  e0:	68 01 02 00 00       	push   $0x201
  e5:	68 e9 0a 00 00       	push   $0xae9
  ea:	e8 d4 04 00 00       	call   5c3 <open>
    if(file_handler < 0) {
  ef:	83 c4 10             	add    $0x10,%esp
    int file_handler = open("mmm_result.txt", O_CREATE | O_WRONLY);
  f2:	89 c1                	mov    %eax,%ecx
    if(file_handler < 0) {
  f4:	85 c0                	test   %eax,%eax
  f6:	78 2c                	js     124 <main+0x124>
    return (int)(sum / len);
  f8:	89 f8                	mov    %edi,%eax
        printf(1, "mmm: cannot create mmm_result.txt\n");
        exit();
    }

    printf(file_handler, "%d %d %d\n", mean, median, mode);
  fa:	83 ec 0c             	sub    $0xc,%esp
    return (int)(sum / len);
  fd:	99                   	cltd   
    printf(file_handler, "%d %d %d\n", mean, median, mode);
  fe:	56                   	push   %esi
    return (int)(sum / len);
  ff:	f7 fb                	idiv   %ebx
    printf(file_handler, "%d %d %d\n", mean, median, mode);
 101:	ff 75 e4             	push   -0x1c(%ebp)
 104:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 107:	50                   	push   %eax
 108:	68 f8 0a 00 00       	push   $0xaf8
 10d:	51                   	push   %ecx
 10e:	e8 4d 06 00 00       	call   760 <printf>
    close(file_handler);
 113:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 116:	83 c4 14             	add    $0x14,%esp
 119:	51                   	push   %ecx
 11a:	e8 8c 04 00 00       	call   5ab <close>
    exit();
 11f:	e8 5f 04 00 00       	call   583 <exit>
        printf(1, "mmm: cannot create mmm_result.txt\n");
 124:	50                   	push   %eax
 125:	50                   	push   %eax
 126:	68 a8 0a 00 00       	push   $0xaa8
 12b:	6a 01                	push   $0x1
 12d:	e8 2e 06 00 00       	call   760 <printf>
        exit();
 132:	e8 4c 04 00 00       	call   583 <exit>
    int numbers[len];
 137:	83 4c 14 fc 00       	orl    $0x0,-0x4(%esp,%edx,1)
 13c:	e9 35 ff ff ff       	jmp    76 <main+0x76>
 141:	66 90                	xchg   %ax,%ax
 143:	66 90                	xchg   %ax,%ax
 145:	66 90                	xchg   %ax,%ax
 147:	66 90                	xchg   %ax,%ax
 149:	66 90                	xchg   %ax,%ax
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <atoi_neg>:
int atoi_neg(const char* str) {
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	53                   	push   %ebx
 154:	83 ec 04             	sub    $0x4,%esp
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
    if (*str == '-') {
 15a:	0f b6 11             	movzbl (%ecx),%edx
 15d:	80 fa 2d             	cmp    $0x2d,%dl
 160:	74 4e                	je     1b0 <atoi_neg+0x60>
    int sign = 1;
 162:	bb 01 00 00 00       	mov    $0x1,%ebx
    else if (*str == '+') {
 167:	80 fa 2b             	cmp    $0x2b,%dl
 16a:	74 34                	je     1a0 <atoi_neg+0x50>
    while(*str){
 16c:	84 d2                	test   %dl,%dl
 16e:	74 1b                	je     18b <atoi_neg+0x3b>
 170:	89 c8                	mov    %ecx,%eax
 172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if((*str < '0') || (*str > '9')){
 178:	83 ea 30             	sub    $0x30,%edx
 17b:	80 fa 09             	cmp    $0x9,%dl
 17e:	77 3e                	ja     1be <atoi_neg+0x6e>
    while(*str){
 180:	0f b6 50 01          	movzbl 0x1(%eax),%edx
        ++str;
 184:	83 c0 01             	add    $0x1,%eax
    while(*str){
 187:	84 d2                	test   %dl,%dl
 189:	75 ed                	jne    178 <atoi_neg+0x28>
    return sign * atoi(str);
 18b:	83 ec 0c             	sub    $0xc,%esp
 18e:	51                   	push   %ecx
 18f:	e8 7c 03 00 00       	call   510 <atoi>
 194:	0f af c3             	imul   %ebx,%eax
}
 197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19a:	c9                   	leave  
 19b:	c3                   	ret    
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(*str){
 1a0:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
        ++str;
 1a4:	83 c1 01             	add    $0x1,%ecx
 1a7:	eb c3                	jmp    16c <atoi_neg+0x1c>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while(*str){
 1b0:	0f b6 51 01          	movzbl 0x1(%ecx),%edx
        sign = -1;
 1b4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        ++str;
 1b9:	83 c1 01             	add    $0x1,%ecx
 1bc:	eb ae                	jmp    16c <atoi_neg+0x1c>
            printf(1, "Invalid Input! Fuck you idiot\n");
 1be:	83 ec 08             	sub    $0x8,%esp
 1c1:	68 88 0a 00 00       	push   $0xa88
 1c6:	6a 01                	push   $0x1
 1c8:	e8 93 05 00 00       	call   760 <printf>
            exit();
 1cd:	e8 b1 03 00 00       	call   583 <exit>
 1d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001e0 <bubble_sort>:
void bubble_sort(int len, int* numbers){
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
 1ea:	56                   	push   %esi
 1eb:	53                   	push   %ebx
    for(int i = 0; i < len; i++){
 1ec:	85 c0                	test   %eax,%eax
 1ee:	7e 37                	jle    227 <bubble_sort+0x47>
 1f0:	8d 70 ff             	lea    -0x1(%eax),%esi
 1f3:	8d 5c 87 fc          	lea    -0x4(%edi,%eax,4),%ebx
        for(int j = 0; j < len - i - 1; j++){
 1f7:	85 f6                	test   %esi,%esi
 1f9:	74 2c                	je     227 <bubble_sort+0x47>
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop
 200:	89 f8                	mov    %edi,%eax
 202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if(numbers[j] > numbers[j + 1]){
 208:	8b 08                	mov    (%eax),%ecx
 20a:	8b 50 04             	mov    0x4(%eax),%edx
 20d:	39 d1                	cmp    %edx,%ecx
 20f:	7e 05                	jle    216 <bubble_sort+0x36>
                numbers[j + 1] = numbers[j];
 211:	89 48 04             	mov    %ecx,0x4(%eax)
                numbers[j] = tmp;
 214:	89 10                	mov    %edx,(%eax)
        for(int j = 0; j < len - i - 1; j++){
 216:	83 c0 04             	add    $0x4,%eax
 219:	39 d8                	cmp    %ebx,%eax
 21b:	75 eb                	jne    208 <bubble_sort+0x28>
    for(int i = 0; i < len; i++){
 21d:	83 ee 01             	sub    $0x1,%esi
 220:	83 eb 04             	sub    $0x4,%ebx
        for(int j = 0; j < len - i - 1; j++){
 223:	85 f6                	test   %esi,%esi
 225:	75 d9                	jne    200 <bubble_sort+0x20>
}
 227:	5b                   	pop    %ebx
 228:	5e                   	pop    %esi
 229:	5f                   	pop    %edi
 22a:	5d                   	pop    %ebp
 22b:	c3                   	ret    
 22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000230 <calc_mean>:
int calc_mean(int len, int numbers[]){
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	53                   	push   %ebx
 234:	8b 5d 08             	mov    0x8(%ebp),%ebx
    for(int i = 0; i < len; i++){
 237:	85 db                	test   %ebx,%ebx
 239:	7e 25                	jle    260 <calc_mean+0x30>
 23b:	8b 55 0c             	mov    0xc(%ebp),%edx
    int sum = 0;
 23e:	31 c0                	xor    %eax,%eax
 240:	8d 0c 9a             	lea    (%edx,%ebx,4),%ecx
 243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 247:	90                   	nop
        sum += numbers[i];
 248:	03 02                	add    (%edx),%eax
    for(int i = 0; i < len; i++){
 24a:	83 c2 04             	add    $0x4,%edx
 24d:	39 ca                	cmp    %ecx,%edx
 24f:	75 f7                	jne    248 <calc_mean+0x18>
    return (int)(sum / len);
 251:	99                   	cltd   
 252:	f7 fb                	idiv   %ebx
}
 254:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 257:	c9                   	leave  
 258:	c3                   	ret    
 259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 260:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    for(int i = 0; i < len; i++){
 263:	31 c0                	xor    %eax,%eax
}
 265:	c9                   	leave  
 266:	c3                   	ret    
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax

00000270 <calc_median>:
int calc_median(int len, int numbers[]){
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 55 08             	mov    0x8(%ebp),%edx
 277:	8b 4d 0c             	mov    0xc(%ebp),%ecx
        idx = len / 2;
 27a:	89 d0                	mov    %edx,%eax
 27c:	c1 e8 1f             	shr    $0x1f,%eax
 27f:	01 d0                	add    %edx,%eax
 281:	d1 f8                	sar    %eax
    if(len % 2 == 0){
 283:	83 e2 01             	and    $0x1,%edx
        median = (int)((numbers[idx - 1] + numbers[idx]) / 2);
 286:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
 28d:	8b 04 81             	mov    (%ecx,%eax,4),%eax
    if(len % 2 == 0){
 290:	75 0d                	jne    29f <calc_median+0x2f>
        median = (int)((numbers[idx - 1] + numbers[idx]) / 2);
 292:	03 44 19 fc          	add    -0x4(%ecx,%ebx,1),%eax
 296:	89 c2                	mov    %eax,%edx
 298:	c1 ea 1f             	shr    $0x1f,%edx
 29b:	01 d0                	add    %edx,%eax
 29d:	d1 f8                	sar    %eax
}
 29f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    
 2a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2af:	90                   	nop

000002b0 <calc_mode>:
int calc_mode(int len, int numbers[]){
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
 2b6:	83 ec 10             	sub    $0x10,%esp
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	8b 55 08             	mov    0x8(%ebp),%edx
    int mode = numbers[0];
 2bf:	8b 18                	mov    (%eax),%ebx
 2c1:	89 5d ec             	mov    %ebx,-0x14(%ebp)
    for(int i = 0; i < len; i++){
 2c4:	85 d2                	test   %edx,%edx
 2c6:	7e 51                	jle    319 <calc_mode+0x69>
 2c8:	8d 78 04             	lea    0x4(%eax),%edi
    int mode = numbers[0];
 2cb:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
 2ce:	8d 34 90             	lea    (%eax,%edx,4),%esi
 2d1:	89 7d e8             	mov    %edi,-0x18(%ebp)
    int maxOccurence = 0;
 2d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop
int calc_mode(int len, int numbers[]){
 2e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2e3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
        int occurrenceCount = 0;
 2e6:	31 d2                	xor    %edx,%edx
 2e8:	eb 0b                	jmp    2f5 <calc_mode+0x45>
 2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            if(numbers[j] == numbers[i]){
 2f0:	8b 08                	mov    (%eax),%ecx
 2f2:	83 c0 04             	add    $0x4,%eax
                occurrenceCount++;
 2f5:	39 cb                	cmp    %ecx,%ebx
 2f7:	0f 94 c1             	sete   %cl
 2fa:	0f b6 c9             	movzbl %cl,%ecx
 2fd:	01 ca                	add    %ecx,%edx
        for(int j = 0; j < len; j++){
 2ff:	39 f0                	cmp    %esi,%eax
 301:	75 ed                	jne    2f0 <calc_mode+0x40>
        if(occurrenceCount > maxOccurence){
 303:	3b 55 f0             	cmp    -0x10(%ebp),%edx
 306:	7e 06                	jle    30e <calc_mode+0x5e>
 308:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
 30b:	89 55 f0             	mov    %edx,-0x10(%ebp)
    for(int i = 0; i < len; i++){
 30e:	39 f7                	cmp    %esi,%edi
 310:	74 0d                	je     31f <calc_mode+0x6f>
            if(numbers[j] == numbers[i]){
 312:	8b 1f                	mov    (%edi),%ebx
 314:	83 c7 04             	add    $0x4,%edi
 317:	eb c7                	jmp    2e0 <calc_mode+0x30>
    int mode = numbers[0];
 319:	8b 45 ec             	mov    -0x14(%ebp),%eax
 31c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
 31f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 322:	83 c4 10             	add    $0x10,%esp
 325:	5b                   	pop    %ebx
 326:	5e                   	pop    %esi
 327:	5f                   	pop    %edi
 328:	5d                   	pop    %ebp
 329:	c3                   	ret    
 32a:	66 90                	xchg   %ax,%ax
 32c:	66 90                	xchg   %ax,%ax
 32e:	66 90                	xchg   %ax,%ax

00000330 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 330:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 331:	31 c0                	xor    %eax,%eax
{
 333:	89 e5                	mov    %esp,%ebp
 335:	53                   	push   %ebx
 336:	8b 4d 08             	mov    0x8(%ebp),%ecx
 339:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 340:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 344:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 347:	83 c0 01             	add    $0x1,%eax
 34a:	84 d2                	test   %dl,%dl
 34c:	75 f2                	jne    340 <strcpy+0x10>
    ;
  return os;
}
 34e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 351:	89 c8                	mov    %ecx,%eax
 353:	c9                   	leave  
 354:	c3                   	ret    
 355:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000360 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 55 08             	mov    0x8(%ebp),%edx
 367:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 36a:	0f b6 02             	movzbl (%edx),%eax
 36d:	84 c0                	test   %al,%al
 36f:	75 17                	jne    388 <strcmp+0x28>
 371:	eb 3a                	jmp    3ad <strcmp+0x4d>
 373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 377:	90                   	nop
 378:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 37c:	83 c2 01             	add    $0x1,%edx
 37f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 382:	84 c0                	test   %al,%al
 384:	74 1a                	je     3a0 <strcmp+0x40>
    p++, q++;
 386:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 388:	0f b6 19             	movzbl (%ecx),%ebx
 38b:	38 c3                	cmp    %al,%bl
 38d:	74 e9                	je     378 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 38f:	29 d8                	sub    %ebx,%eax
}
 391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 394:	c9                   	leave  
 395:	c3                   	ret    
 396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 3a0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 3a4:	31 c0                	xor    %eax,%eax
 3a6:	29 d8                	sub    %ebx,%eax
}
 3a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3ab:	c9                   	leave  
 3ac:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 3ad:	0f b6 19             	movzbl (%ecx),%ebx
 3b0:	31 c0                	xor    %eax,%eax
 3b2:	eb db                	jmp    38f <strcmp+0x2f>
 3b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop

000003c0 <strlen>:

uint
strlen(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3c6:	80 3a 00             	cmpb   $0x0,(%edx)
 3c9:	74 15                	je     3e0 <strlen+0x20>
 3cb:	31 c0                	xor    %eax,%eax
 3cd:	8d 76 00             	lea    0x0(%esi),%esi
 3d0:	83 c0 01             	add    $0x1,%eax
 3d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3d7:	89 c1                	mov    %eax,%ecx
 3d9:	75 f5                	jne    3d0 <strlen+0x10>
    ;
  return n;
}
 3db:	89 c8                	mov    %ecx,%eax
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    
 3df:	90                   	nop
  for(n = 0; s[n]; n++)
 3e0:	31 c9                	xor    %ecx,%ecx
}
 3e2:	5d                   	pop    %ebp
 3e3:	89 c8                	mov    %ecx,%eax
 3e5:	c3                   	ret    
 3e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ed:	8d 76 00             	lea    0x0(%esi),%esi

000003f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 d7                	mov    %edx,%edi
 3ff:	fc                   	cld    
 400:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 402:	8b 7d fc             	mov    -0x4(%ebp),%edi
 405:	89 d0                	mov    %edx,%eax
 407:	c9                   	leave  
 408:	c3                   	ret    
 409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000410 <strchr>:

char*
strchr(const char *s, char c)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 41a:	0f b6 10             	movzbl (%eax),%edx
 41d:	84 d2                	test   %dl,%dl
 41f:	75 12                	jne    433 <strchr+0x23>
 421:	eb 1d                	jmp    440 <strchr+0x30>
 423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 427:	90                   	nop
 428:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 42c:	83 c0 01             	add    $0x1,%eax
 42f:	84 d2                	test   %dl,%dl
 431:	74 0d                	je     440 <strchr+0x30>
    if(*s == c)
 433:	38 d1                	cmp    %dl,%cl
 435:	75 f1                	jne    428 <strchr+0x18>
      return (char*)s;
  return 0;
}
 437:	5d                   	pop    %ebp
 438:	c3                   	ret    
 439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 440:	31 c0                	xor    %eax,%eax
}
 442:	5d                   	pop    %ebp
 443:	c3                   	ret    
 444:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 44f:	90                   	nop

00000450 <gets>:

char*
gets(char *buf, int max)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
 454:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 455:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 458:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 459:	31 db                	xor    %ebx,%ebx
{
 45b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 45e:	eb 27                	jmp    487 <gets+0x37>
    cc = read(0, &c, 1);
 460:	83 ec 04             	sub    $0x4,%esp
 463:	6a 01                	push   $0x1
 465:	57                   	push   %edi
 466:	6a 00                	push   $0x0
 468:	e8 2e 01 00 00       	call   59b <read>
    if(cc < 1)
 46d:	83 c4 10             	add    $0x10,%esp
 470:	85 c0                	test   %eax,%eax
 472:	7e 1d                	jle    491 <gets+0x41>
      break;
    buf[i++] = c;
 474:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 478:	8b 55 08             	mov    0x8(%ebp),%edx
 47b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 47f:	3c 0a                	cmp    $0xa,%al
 481:	74 1d                	je     4a0 <gets+0x50>
 483:	3c 0d                	cmp    $0xd,%al
 485:	74 19                	je     4a0 <gets+0x50>
  for(i=0; i+1 < max; ){
 487:	89 de                	mov    %ebx,%esi
 489:	83 c3 01             	add    $0x1,%ebx
 48c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 48f:	7c cf                	jl     460 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 498:	8d 65 f4             	lea    -0xc(%ebp),%esp
 49b:	5b                   	pop    %ebx
 49c:	5e                   	pop    %esi
 49d:	5f                   	pop    %edi
 49e:	5d                   	pop    %ebp
 49f:	c3                   	ret    
  buf[i] = '\0';
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	89 de                	mov    %ebx,%esi
 4a5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 4a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ac:	5b                   	pop    %ebx
 4ad:	5e                   	pop    %esi
 4ae:	5f                   	pop    %edi
 4af:	5d                   	pop    %ebp
 4b0:	c3                   	ret    
 4b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bf:	90                   	nop

000004c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4c0:	55                   	push   %ebp
 4c1:	89 e5                	mov    %esp,%ebp
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c5:	83 ec 08             	sub    $0x8,%esp
 4c8:	6a 00                	push   $0x0
 4ca:	ff 75 08             	push   0x8(%ebp)
 4cd:	e8 f1 00 00 00       	call   5c3 <open>
  if(fd < 0)
 4d2:	83 c4 10             	add    $0x10,%esp
 4d5:	85 c0                	test   %eax,%eax
 4d7:	78 27                	js     500 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4d9:	83 ec 08             	sub    $0x8,%esp
 4dc:	ff 75 0c             	push   0xc(%ebp)
 4df:	89 c3                	mov    %eax,%ebx
 4e1:	50                   	push   %eax
 4e2:	e8 f4 00 00 00       	call   5db <fstat>
  close(fd);
 4e7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ea:	89 c6                	mov    %eax,%esi
  close(fd);
 4ec:	e8 ba 00 00 00       	call   5ab <close>
  return r;
 4f1:	83 c4 10             	add    $0x10,%esp
}
 4f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4f7:	89 f0                	mov    %esi,%eax
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5d                   	pop    %ebp
 4fc:	c3                   	ret    
 4fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 500:	be ff ff ff ff       	mov    $0xffffffff,%esi
 505:	eb ed                	jmp    4f4 <stat+0x34>
 507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50e:	66 90                	xchg   %ax,%ax

00000510 <atoi>:

int
atoi(const char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	53                   	push   %ebx
 514:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 517:	0f be 02             	movsbl (%edx),%eax
 51a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 51d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 520:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 525:	77 1e                	ja     545 <atoi+0x35>
 527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 530:	83 c2 01             	add    $0x1,%edx
 533:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 536:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 53a:	0f be 02             	movsbl (%edx),%eax
 53d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 540:	80 fb 09             	cmp    $0x9,%bl
 543:	76 eb                	jbe    530 <atoi+0x20>
  return n;
}
 545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 548:	89 c8                	mov    %ecx,%eax
 54a:	c9                   	leave  
 54b:	c3                   	ret    
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000550 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	8b 45 10             	mov    0x10(%ebp),%eax
 557:	8b 55 08             	mov    0x8(%ebp),%edx
 55a:	56                   	push   %esi
 55b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 55e:	85 c0                	test   %eax,%eax
 560:	7e 13                	jle    575 <memmove+0x25>
 562:	01 d0                	add    %edx,%eax
  dst = vdst;
 564:	89 d7                	mov    %edx,%edi
 566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 570:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 571:	39 f8                	cmp    %edi,%eax
 573:	75 fb                	jne    570 <memmove+0x20>
  return vdst;
}
 575:	5e                   	pop    %esi
 576:	89 d0                	mov    %edx,%eax
 578:	5f                   	pop    %edi
 579:	5d                   	pop    %ebp
 57a:	c3                   	ret    

0000057b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 57b:	b8 01 00 00 00       	mov    $0x1,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <exit>:
SYSCALL(exit)
 583:	b8 02 00 00 00       	mov    $0x2,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <wait>:
SYSCALL(wait)
 58b:	b8 03 00 00 00       	mov    $0x3,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <pipe>:
SYSCALL(pipe)
 593:	b8 04 00 00 00       	mov    $0x4,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <read>:
SYSCALL(read)
 59b:	b8 05 00 00 00       	mov    $0x5,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <write>:
SYSCALL(write)
 5a3:	b8 10 00 00 00       	mov    $0x10,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <close>:
SYSCALL(close)
 5ab:	b8 15 00 00 00       	mov    $0x15,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <kill>:
SYSCALL(kill)
 5b3:	b8 06 00 00 00       	mov    $0x6,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <exec>:
SYSCALL(exec)
 5bb:	b8 07 00 00 00       	mov    $0x7,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <open>:
SYSCALL(open)
 5c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <mknod>:
SYSCALL(mknod)
 5cb:	b8 11 00 00 00       	mov    $0x11,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <unlink>:
SYSCALL(unlink)
 5d3:	b8 12 00 00 00       	mov    $0x12,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <fstat>:
SYSCALL(fstat)
 5db:	b8 08 00 00 00       	mov    $0x8,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <link>:
SYSCALL(link)
 5e3:	b8 13 00 00 00       	mov    $0x13,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <mkdir>:
SYSCALL(mkdir)
 5eb:	b8 14 00 00 00       	mov    $0x14,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <chdir>:
SYSCALL(chdir)
 5f3:	b8 09 00 00 00       	mov    $0x9,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <dup>:
SYSCALL(dup)
 5fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <getpid>:
SYSCALL(getpid)
 603:	b8 0b 00 00 00       	mov    $0xb,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <sbrk>:
SYSCALL(sbrk)
 60b:	b8 0c 00 00 00       	mov    $0xc,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <sleep>:
SYSCALL(sleep)
 613:	b8 0d 00 00 00       	mov    $0xd,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <uptime>:
SYSCALL(uptime)
 61b:	b8 0e 00 00 00       	mov    $0xe,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <find_fibonacci_number>:
SYSCALL(find_fibonacci_number)
 623:	b8 16 00 00 00       	mov    $0x16,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <find_most_callee>:
SYSCALL(find_most_callee)
 62b:	b8 17 00 00 00       	mov    $0x17,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <get_children_count>:
SYSCALL(get_children_count)
 633:	b8 18 00 00 00       	mov    $0x18,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <kill_first_child_process>:
SYSCALL(kill_first_child_process)
 63b:	b8 19 00 00 00       	mov    $0x19,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <set_proc_queue>:
SYSCALL(set_proc_queue)
 643:	b8 1a 00 00 00       	mov    $0x1a,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <set_lottery_params>:
SYSCALL(set_lottery_params)
 64b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <print_all_procs>:
SYSCALL(print_all_procs)
 653:	b8 1c 00 00 00       	mov    $0x1c,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <sem_init>:
SYSCALL(sem_init)
 65b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <sem_acquire>:
SYSCALL(sem_acquire)
 663:	b8 1e 00 00 00       	mov    $0x1e,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <sem_release>:
SYSCALL(sem_release)
 66b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <producer>:
SYSCALL(producer)
 673:	b8 20 00 00 00       	mov    $0x20,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <consumer>:
SYSCALL(consumer)
 67b:	b8 21 00 00 00       	mov    $0x21,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <cv_wait>:
SYSCALL(cv_wait)
 683:	b8 22 00 00 00       	mov    $0x22,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <cv_signal>:
SYSCALL(cv_signal)
 68b:	b8 23 00 00 00       	mov    $0x23,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <reader>:
SYSCALL(reader)
 693:	b8 24 00 00 00       	mov    $0x24,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <writer>:
 69b:	b8 25 00 00 00       	mov    $0x25,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    
 6a3:	66 90                	xchg   %ax,%ax
 6a5:	66 90                	xchg   %ax,%ax
 6a7:	66 90                	xchg   %ax,%ax
 6a9:	66 90                	xchg   %ax,%ax
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 3c             	sub    $0x3c,%esp
 6b9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6bc:	89 d1                	mov    %edx,%ecx
{
 6be:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 6c1:	85 d2                	test   %edx,%edx
 6c3:	0f 89 7f 00 00 00    	jns    748 <printint+0x98>
 6c9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6cd:	74 79                	je     748 <printint+0x98>
    neg = 1;
 6cf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 6d6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 6d8:	31 db                	xor    %ebx,%ebx
 6da:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6e0:	89 c8                	mov    %ecx,%eax
 6e2:	31 d2                	xor    %edx,%edx
 6e4:	89 cf                	mov    %ecx,%edi
 6e6:	f7 75 c4             	divl   -0x3c(%ebp)
 6e9:	0f b6 92 64 0b 00 00 	movzbl 0xb64(%edx),%edx
 6f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6f3:	89 d8                	mov    %ebx,%eax
 6f5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6f8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6fb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6fe:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 701:	76 dd                	jbe    6e0 <printint+0x30>
  if(neg)
 703:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 706:	85 c9                	test   %ecx,%ecx
 708:	74 0c                	je     716 <printint+0x66>
    buf[i++] = '-';
 70a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 70f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 711:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 716:	8b 7d b8             	mov    -0x48(%ebp),%edi
 719:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 71d:	eb 07                	jmp    726 <printint+0x76>
 71f:	90                   	nop
    putc(fd, buf[i]);
 720:	0f b6 13             	movzbl (%ebx),%edx
 723:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 726:	83 ec 04             	sub    $0x4,%esp
 729:	88 55 d7             	mov    %dl,-0x29(%ebp)
 72c:	6a 01                	push   $0x1
 72e:	56                   	push   %esi
 72f:	57                   	push   %edi
 730:	e8 6e fe ff ff       	call   5a3 <write>
  while(--i >= 0)
 735:	83 c4 10             	add    $0x10,%esp
 738:	39 de                	cmp    %ebx,%esi
 73a:	75 e4                	jne    720 <printint+0x70>
}
 73c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73f:	5b                   	pop    %ebx
 740:	5e                   	pop    %esi
 741:	5f                   	pop    %edi
 742:	5d                   	pop    %ebp
 743:	c3                   	ret    
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 748:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 74f:	eb 87                	jmp    6d8 <printint+0x28>
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop

00000760 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 769:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 76c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 76f:	0f b6 13             	movzbl (%ebx),%edx
 772:	84 d2                	test   %dl,%dl
 774:	74 6a                	je     7e0 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 776:	8d 45 10             	lea    0x10(%ebp),%eax
 779:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 77c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 77f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 781:	89 45 d0             	mov    %eax,-0x30(%ebp)
 784:	eb 36                	jmp    7bc <printf+0x5c>
 786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78d:	8d 76 00             	lea    0x0(%esi),%esi
 790:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 793:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 798:	83 f8 25             	cmp    $0x25,%eax
 79b:	74 15                	je     7b2 <printf+0x52>
  write(fd, &c, 1);
 79d:	83 ec 04             	sub    $0x4,%esp
 7a0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 7a3:	6a 01                	push   $0x1
 7a5:	57                   	push   %edi
 7a6:	56                   	push   %esi
 7a7:	e8 f7 fd ff ff       	call   5a3 <write>
 7ac:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 7af:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7b2:	0f b6 13             	movzbl (%ebx),%edx
 7b5:	83 c3 01             	add    $0x1,%ebx
 7b8:	84 d2                	test   %dl,%dl
 7ba:	74 24                	je     7e0 <printf+0x80>
    c = fmt[i] & 0xff;
 7bc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 7bf:	85 c9                	test   %ecx,%ecx
 7c1:	74 cd                	je     790 <printf+0x30>
      }
    } else if(state == '%'){
 7c3:	83 f9 25             	cmp    $0x25,%ecx
 7c6:	75 ea                	jne    7b2 <printf+0x52>
      if(c == 'd'){
 7c8:	83 f8 25             	cmp    $0x25,%eax
 7cb:	0f 84 07 01 00 00    	je     8d8 <printf+0x178>
 7d1:	83 e8 63             	sub    $0x63,%eax
 7d4:	83 f8 15             	cmp    $0x15,%eax
 7d7:	77 17                	ja     7f0 <printf+0x90>
 7d9:	ff 24 85 0c 0b 00 00 	jmp    *0xb0c(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7e3:	5b                   	pop    %ebx
 7e4:	5e                   	pop    %esi
 7e5:	5f                   	pop    %edi
 7e6:	5d                   	pop    %ebp
 7e7:	c3                   	ret    
 7e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ef:	90                   	nop
  write(fd, &c, 1);
 7f0:	83 ec 04             	sub    $0x4,%esp
 7f3:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 7f6:	6a 01                	push   $0x1
 7f8:	57                   	push   %edi
 7f9:	56                   	push   %esi
 7fa:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7fe:	e8 a0 fd ff ff       	call   5a3 <write>
        putc(fd, c);
 803:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 807:	83 c4 0c             	add    $0xc,%esp
 80a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 80d:	6a 01                	push   $0x1
 80f:	57                   	push   %edi
 810:	56                   	push   %esi
 811:	e8 8d fd ff ff       	call   5a3 <write>
        putc(fd, c);
 816:	83 c4 10             	add    $0x10,%esp
      state = 0;
 819:	31 c9                	xor    %ecx,%ecx
 81b:	eb 95                	jmp    7b2 <printf+0x52>
 81d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	b9 10 00 00 00       	mov    $0x10,%ecx
 828:	6a 00                	push   $0x0
 82a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 82d:	8b 10                	mov    (%eax),%edx
 82f:	89 f0                	mov    %esi,%eax
 831:	e8 7a fe ff ff       	call   6b0 <printint>
        ap++;
 836:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 83a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 83d:	31 c9                	xor    %ecx,%ecx
 83f:	e9 6e ff ff ff       	jmp    7b2 <printf+0x52>
 844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 848:	8b 45 d0             	mov    -0x30(%ebp),%eax
 84b:	8b 10                	mov    (%eax),%edx
        ap++;
 84d:	83 c0 04             	add    $0x4,%eax
 850:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 853:	85 d2                	test   %edx,%edx
 855:	0f 84 8d 00 00 00    	je     8e8 <printf+0x188>
        while(*s != 0){
 85b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 85e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 860:	84 c0                	test   %al,%al
 862:	0f 84 4a ff ff ff    	je     7b2 <printf+0x52>
 868:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 86b:	89 d3                	mov    %edx,%ebx
 86d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 870:	83 ec 04             	sub    $0x4,%esp
          s++;
 873:	83 c3 01             	add    $0x1,%ebx
 876:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 879:	6a 01                	push   $0x1
 87b:	57                   	push   %edi
 87c:	56                   	push   %esi
 87d:	e8 21 fd ff ff       	call   5a3 <write>
        while(*s != 0){
 882:	0f b6 03             	movzbl (%ebx),%eax
 885:	83 c4 10             	add    $0x10,%esp
 888:	84 c0                	test   %al,%al
 88a:	75 e4                	jne    870 <printf+0x110>
      state = 0;
 88c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 88f:	31 c9                	xor    %ecx,%ecx
 891:	e9 1c ff ff ff       	jmp    7b2 <printf+0x52>
 896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 89d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 8a0:	83 ec 0c             	sub    $0xc,%esp
 8a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8a8:	6a 01                	push   $0x1
 8aa:	e9 7b ff ff ff       	jmp    82a <printf+0xca>
 8af:	90                   	nop
        putc(fd, *ap);
 8b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 8b3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8b6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 8b8:	6a 01                	push   $0x1
 8ba:	57                   	push   %edi
 8bb:	56                   	push   %esi
        putc(fd, *ap);
 8bc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8bf:	e8 df fc ff ff       	call   5a3 <write>
        ap++;
 8c4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 8c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8cb:	31 c9                	xor    %ecx,%ecx
 8cd:	e9 e0 fe ff ff       	jmp    7b2 <printf+0x52>
 8d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 8d8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 8db:	83 ec 04             	sub    $0x4,%esp
 8de:	e9 2a ff ff ff       	jmp    80d <printf+0xad>
 8e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8e7:	90                   	nop
          s = "(null)";
 8e8:	ba 02 0b 00 00       	mov    $0xb02,%edx
        while(*s != 0){
 8ed:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 8f0:	b8 28 00 00 00       	mov    $0x28,%eax
 8f5:	89 d3                	mov    %edx,%ebx
 8f7:	e9 74 ff ff ff       	jmp    870 <printf+0x110>
 8fc:	66 90                	xchg   %ax,%ax
 8fe:	66 90                	xchg   %ax,%ax

00000900 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 900:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 901:	a1 e8 0e 00 00       	mov    0xee8,%eax
{
 906:	89 e5                	mov    %esp,%ebp
 908:	57                   	push   %edi
 909:	56                   	push   %esi
 90a:	53                   	push   %ebx
 90b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 90e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 918:	89 c2                	mov    %eax,%edx
 91a:	8b 00                	mov    (%eax),%eax
 91c:	39 ca                	cmp    %ecx,%edx
 91e:	73 30                	jae    950 <free+0x50>
 920:	39 c1                	cmp    %eax,%ecx
 922:	72 04                	jb     928 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 924:	39 c2                	cmp    %eax,%edx
 926:	72 f0                	jb     918 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 928:	8b 73 fc             	mov    -0x4(%ebx),%esi
 92b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 92e:	39 f8                	cmp    %edi,%eax
 930:	74 30                	je     962 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 935:	8b 42 04             	mov    0x4(%edx),%eax
 938:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 93b:	39 f1                	cmp    %esi,%ecx
 93d:	74 3a                	je     979 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 93f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 941:	5b                   	pop    %ebx
  freep = p;
 942:	89 15 e8 0e 00 00    	mov    %edx,0xee8
}
 948:	5e                   	pop    %esi
 949:	5f                   	pop    %edi
 94a:	5d                   	pop    %ebp
 94b:	c3                   	ret    
 94c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 950:	39 c2                	cmp    %eax,%edx
 952:	72 c4                	jb     918 <free+0x18>
 954:	39 c1                	cmp    %eax,%ecx
 956:	73 c0                	jae    918 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 958:	8b 73 fc             	mov    -0x4(%ebx),%esi
 95b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 95e:	39 f8                	cmp    %edi,%eax
 960:	75 d0                	jne    932 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 962:	03 70 04             	add    0x4(%eax),%esi
 965:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 968:	8b 02                	mov    (%edx),%eax
 96a:	8b 00                	mov    (%eax),%eax
 96c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 96f:	8b 42 04             	mov    0x4(%edx),%eax
 972:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 975:	39 f1                	cmp    %esi,%ecx
 977:	75 c6                	jne    93f <free+0x3f>
    p->s.size += bp->s.size;
 979:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 97c:	89 15 e8 0e 00 00    	mov    %edx,0xee8
    p->s.size += bp->s.size;
 982:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 985:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 988:	89 0a                	mov    %ecx,(%edx)
}
 98a:	5b                   	pop    %ebx
 98b:	5e                   	pop    %esi
 98c:	5f                   	pop    %edi
 98d:	5d                   	pop    %ebp
 98e:	c3                   	ret    
 98f:	90                   	nop

00000990 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	57                   	push   %edi
 994:	56                   	push   %esi
 995:	53                   	push   %ebx
 996:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 999:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 99c:	8b 3d e8 0e 00 00    	mov    0xee8,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a2:	8d 70 07             	lea    0x7(%eax),%esi
 9a5:	c1 ee 03             	shr    $0x3,%esi
 9a8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9ab:	85 ff                	test   %edi,%edi
 9ad:	0f 84 9d 00 00 00    	je     a50 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 9b5:	8b 4a 04             	mov    0x4(%edx),%ecx
 9b8:	39 f1                	cmp    %esi,%ecx
 9ba:	73 6a                	jae    a26 <malloc+0x96>
 9bc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9c1:	39 de                	cmp    %ebx,%esi
 9c3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9c6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 9cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 9d0:	eb 17                	jmp    9e9 <malloc+0x59>
 9d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 9da:	8b 48 04             	mov    0x4(%eax),%ecx
 9dd:	39 f1                	cmp    %esi,%ecx
 9df:	73 4f                	jae    a30 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9e1:	8b 3d e8 0e 00 00    	mov    0xee8,%edi
 9e7:	89 c2                	mov    %eax,%edx
 9e9:	39 d7                	cmp    %edx,%edi
 9eb:	75 eb                	jne    9d8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 9ed:	83 ec 0c             	sub    $0xc,%esp
 9f0:	ff 75 e4             	push   -0x1c(%ebp)
 9f3:	e8 13 fc ff ff       	call   60b <sbrk>
  if(p == (char*)-1)
 9f8:	83 c4 10             	add    $0x10,%esp
 9fb:	83 f8 ff             	cmp    $0xffffffff,%eax
 9fe:	74 1c                	je     a1c <malloc+0x8c>
  hp->s.size = nu;
 a00:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a03:	83 ec 0c             	sub    $0xc,%esp
 a06:	83 c0 08             	add    $0x8,%eax
 a09:	50                   	push   %eax
 a0a:	e8 f1 fe ff ff       	call   900 <free>
  return freep;
 a0f:	8b 15 e8 0e 00 00    	mov    0xee8,%edx
      if((p = morecore(nunits)) == 0)
 a15:	83 c4 10             	add    $0x10,%esp
 a18:	85 d2                	test   %edx,%edx
 a1a:	75 bc                	jne    9d8 <malloc+0x48>
        return 0;
  }
}
 a1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a1f:	31 c0                	xor    %eax,%eax
}
 a21:	5b                   	pop    %ebx
 a22:	5e                   	pop    %esi
 a23:	5f                   	pop    %edi
 a24:	5d                   	pop    %ebp
 a25:	c3                   	ret    
    if(p->s.size >= nunits){
 a26:	89 d0                	mov    %edx,%eax
 a28:	89 fa                	mov    %edi,%edx
 a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a30:	39 ce                	cmp    %ecx,%esi
 a32:	74 4c                	je     a80 <malloc+0xf0>
        p->s.size -= nunits;
 a34:	29 f1                	sub    %esi,%ecx
 a36:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a39:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a3c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 a3f:	89 15 e8 0e 00 00    	mov    %edx,0xee8
}
 a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a48:	83 c0 08             	add    $0x8,%eax
}
 a4b:	5b                   	pop    %ebx
 a4c:	5e                   	pop    %esi
 a4d:	5f                   	pop    %edi
 a4e:	5d                   	pop    %ebp
 a4f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 a50:	c7 05 e8 0e 00 00 ec 	movl   $0xeec,0xee8
 a57:	0e 00 00 
    base.s.size = 0;
 a5a:	bf ec 0e 00 00       	mov    $0xeec,%edi
    base.s.ptr = freep = prevp = &base;
 a5f:	c7 05 ec 0e 00 00 ec 	movl   $0xeec,0xeec
 a66:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a69:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 a6b:	c7 05 f0 0e 00 00 00 	movl   $0x0,0xef0
 a72:	00 00 00 
    if(p->s.size >= nunits){
 a75:	e9 42 ff ff ff       	jmp    9bc <malloc+0x2c>
 a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a80:	8b 08                	mov    (%eax),%ecx
 a82:	89 0a                	mov    %ecx,(%edx)
 a84:	eb b9                	jmp    a3f <malloc+0xaf>
