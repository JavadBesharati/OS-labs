
_test_find_fibonacci_number:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "fcntl.h"
#include "user.h"

int main(int argc, char* argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 10             	sub    $0x10,%esp
  13:	8b 19                	mov    (%ecx),%ebx
  15:	8b 71 04             	mov    0x4(%ecx),%esi
    write(1, "testing find_fibonacci_number system call started\n", 50);
  18:	6a 32                	push   $0x32
  1a:	68 b8 07 00 00       	push   $0x7b8
  1f:	6a 01                	push   $0x1
  21:	e8 fd 02 00 00       	call   323 <write>
    
    if(argc != 2){
  26:	83 c4 10             	add    $0x10,%esp
  29:	83 fb 02             	cmp    $0x2,%ebx
  2c:	74 14                	je     42 <main+0x42>
        write(1, "Invalid input. Please enter just a single integer.\n", 51);
  2e:	53                   	push   %ebx
  2f:	6a 33                	push   $0x33
  31:	68 ec 07 00 00       	push   $0x7ec
  36:	6a 01                	push   $0x1
  38:	e8 e6 02 00 00       	call   323 <write>
        exit();
  3d:	e8 c1 02 00 00       	call   303 <exit>
    }
    
    int n = atoi(argv[1]), prev_ebx;
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	ff 76 04             	push   0x4(%esi)
  48:	e8 43 02 00 00       	call   290 <atoi>
  4d:	89 c3                	mov    %eax,%ebx
    
    asm volatile(
  4f:	89 de                	mov    %ebx,%esi
  51:	89 c3                	mov    %eax,%ebx
        "movl %1, %%ebx;"
        : "=r" (prev_ebx)
        : "r"(n)
        );

    printf(1, "calling find_fibonacci_number(%d)\n", n);
  53:	83 c4 0c             	add    $0xc,%esp
  56:	50                   	push   %eax
  57:	68 20 08 00 00       	push   $0x820
  5c:	6a 01                	push   $0x1
  5e:	e8 2d 04 00 00       	call   490 <printf>

    int answer = find_fibonacci_number();
  63:	e8 3b 03 00 00       	call   3a3 <find_fibonacci_number>

    asm volatile(
  68:	89 f3                	mov    %esi,%ebx
        "movl %0, %%ebx;"
        : : "r"(prev_ebx)
    );

    if(answer == -1){
  6a:	83 c4 10             	add    $0x10,%esp
  6d:	83 f8 ff             	cmp    $0xffffffff,%eax
  70:	74 13                	je     85 <main+0x85>
        printf(1, "find_fibonacci_number failed\n");
        printf(1, "Please check if you entered an integer smaller than 1\n");
        exit();
    }

    printf(1, "find_fibonacci_number(%d) = %d\n", n, answer);
  72:	50                   	push   %eax
  73:	53                   	push   %ebx
  74:	68 7c 08 00 00       	push   $0x87c
  79:	6a 01                	push   $0x1
  7b:	e8 10 04 00 00       	call   490 <printf>
    exit();
  80:	e8 7e 02 00 00       	call   303 <exit>
        printf(1, "find_fibonacci_number failed\n");
  85:	50                   	push   %eax
  86:	50                   	push   %eax
  87:	68 9c 08 00 00       	push   $0x89c
  8c:	6a 01                	push   $0x1
  8e:	e8 fd 03 00 00       	call   490 <printf>
        printf(1, "Please check if you entered an integer smaller than 1\n");
  93:	5a                   	pop    %edx
  94:	59                   	pop    %ecx
  95:	68 44 08 00 00       	push   $0x844
  9a:	6a 01                	push   $0x1
  9c:	e8 ef 03 00 00       	call   490 <printf>
        exit();
  a1:	e8 5d 02 00 00       	call   303 <exit>
  a6:	66 90                	xchg   %ax,%ax
  a8:	66 90                	xchg   %ax,%ax
  aa:	66 90                	xchg   %ax,%ax
  ac:	66 90                	xchg   %ax,%ax
  ae:	66 90                	xchg   %ax,%ax

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  b1:	31 c0                	xor    %eax,%eax
{
  b3:	89 e5                	mov    %esp,%ebp
  b5:	53                   	push   %ebx
  b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  c7:	83 c0 01             	add    $0x1,%eax
  ca:	84 d2                	test   %dl,%dl
  cc:	75 f2                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d1:	89 c8                	mov    %ecx,%eax
  d3:	c9                   	leave  
  d4:	c3                   	ret    
  d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	53                   	push   %ebx
  e4:	8b 55 08             	mov    0x8(%ebp),%edx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	84 c0                	test   %al,%al
  ef:	75 17                	jne    108 <strcmp+0x28>
  f1:	eb 3a                	jmp    12d <strcmp+0x4d>
  f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  f7:	90                   	nop
  f8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  fc:	83 c2 01             	add    $0x1,%edx
  ff:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 102:	84 c0                	test   %al,%al
 104:	74 1a                	je     120 <strcmp+0x40>
    p++, q++;
 106:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 108:	0f b6 19             	movzbl (%ecx),%ebx
 10b:	38 c3                	cmp    %al,%bl
 10d:	74 e9                	je     f8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 10f:	29 d8                	sub    %ebx,%eax
}
 111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 114:	c9                   	leave  
 115:	c3                   	ret    
 116:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 11d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 120:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 124:	31 c0                	xor    %eax,%eax
 126:	29 d8                	sub    %ebx,%eax
}
 128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 12b:	c9                   	leave  
 12c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
 12d:	0f b6 19             	movzbl (%ecx),%ebx
 130:	31 c0                	xor    %eax,%eax
 132:	eb db                	jmp    10f <strcmp+0x2f>
 134:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop

00000140 <strlen>:

uint
strlen(const char *s)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 146:	80 3a 00             	cmpb   $0x0,(%edx)
 149:	74 15                	je     160 <strlen+0x20>
 14b:	31 c0                	xor    %eax,%eax
 14d:	8d 76 00             	lea    0x0(%esi),%esi
 150:	83 c0 01             	add    $0x1,%eax
 153:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 157:	89 c1                	mov    %eax,%ecx
 159:	75 f5                	jne    150 <strlen+0x10>
    ;
  return n;
}
 15b:	89 c8                	mov    %ecx,%eax
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    
 15f:	90                   	nop
  for(n = 0; s[n]; n++)
 160:	31 c9                	xor    %ecx,%ecx
}
 162:	5d                   	pop    %ebp
 163:	89 c8                	mov    %ecx,%eax
 165:	c3                   	ret    
 166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16d:	8d 76 00             	lea    0x0(%esi),%esi

00000170 <memset>:

void*
memset(void *dst, int c, uint n)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	57                   	push   %edi
 174:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 177:	8b 4d 10             	mov    0x10(%ebp),%ecx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	89 d7                	mov    %edx,%edi
 17f:	fc                   	cld    
 180:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 182:	8b 7d fc             	mov    -0x4(%ebp),%edi
 185:	89 d0                	mov    %edx,%eax
 187:	c9                   	leave  
 188:	c3                   	ret    
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <strchr>:

char*
strchr(const char *s, char c)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 19a:	0f b6 10             	movzbl (%eax),%edx
 19d:	84 d2                	test   %dl,%dl
 19f:	75 12                	jne    1b3 <strchr+0x23>
 1a1:	eb 1d                	jmp    1c0 <strchr+0x30>
 1a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1a7:	90                   	nop
 1a8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 1ac:	83 c0 01             	add    $0x1,%eax
 1af:	84 d2                	test   %dl,%dl
 1b1:	74 0d                	je     1c0 <strchr+0x30>
    if(*s == c)
 1b3:	38 d1                	cmp    %dl,%cl
 1b5:	75 f1                	jne    1a8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 1c0:	31 c0                	xor    %eax,%eax
}
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1cf:	90                   	nop

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	57                   	push   %edi
 1d4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1d5:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 1d8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 1d9:	31 db                	xor    %ebx,%ebx
{
 1db:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 1de:	eb 27                	jmp    207 <gets+0x37>
    cc = read(0, &c, 1);
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	6a 01                	push   $0x1
 1e5:	57                   	push   %edi
 1e6:	6a 00                	push   $0x0
 1e8:	e8 2e 01 00 00       	call   31b <read>
    if(cc < 1)
 1ed:	83 c4 10             	add    $0x10,%esp
 1f0:	85 c0                	test   %eax,%eax
 1f2:	7e 1d                	jle    211 <gets+0x41>
      break;
    buf[i++] = c;
 1f4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1f8:	8b 55 08             	mov    0x8(%ebp),%edx
 1fb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1ff:	3c 0a                	cmp    $0xa,%al
 201:	74 1d                	je     220 <gets+0x50>
 203:	3c 0d                	cmp    $0xd,%al
 205:	74 19                	je     220 <gets+0x50>
  for(i=0; i+1 < max; ){
 207:	89 de                	mov    %ebx,%esi
 209:	83 c3 01             	add    $0x1,%ebx
 20c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 20f:	7c cf                	jl     1e0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 218:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21b:	5b                   	pop    %ebx
 21c:	5e                   	pop    %esi
 21d:	5f                   	pop    %edi
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
  buf[i] = '\0';
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	89 de                	mov    %ebx,%esi
 225:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 229:	8d 65 f4             	lea    -0xc(%ebp),%esp
 22c:	5b                   	pop    %ebx
 22d:	5e                   	pop    %esi
 22e:	5f                   	pop    %edi
 22f:	5d                   	pop    %ebp
 230:	c3                   	ret    
 231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 23f:	90                   	nop

00000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 245:	83 ec 08             	sub    $0x8,%esp
 248:	6a 00                	push   $0x0
 24a:	ff 75 08             	push   0x8(%ebp)
 24d:	e8 f1 00 00 00       	call   343 <open>
  if(fd < 0)
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	78 27                	js     280 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 259:	83 ec 08             	sub    $0x8,%esp
 25c:	ff 75 0c             	push   0xc(%ebp)
 25f:	89 c3                	mov    %eax,%ebx
 261:	50                   	push   %eax
 262:	e8 f4 00 00 00       	call   35b <fstat>
  close(fd);
 267:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 26a:	89 c6                	mov    %eax,%esi
  close(fd);
 26c:	e8 ba 00 00 00       	call   32b <close>
  return r;
 271:	83 c4 10             	add    $0x10,%esp
}
 274:	8d 65 f8             	lea    -0x8(%ebp),%esp
 277:	89 f0                	mov    %esi,%eax
 279:	5b                   	pop    %ebx
 27a:	5e                   	pop    %esi
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    
 27d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 280:	be ff ff ff ff       	mov    $0xffffffff,%esi
 285:	eb ed                	jmp    274 <stat+0x34>
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax

00000290 <atoi>:

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 02             	movsbl (%edx),%eax
 29a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 29d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 2a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 2a5:	77 1e                	ja     2c5 <atoi+0x35>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2b0:	83 c2 01             	add    $0x1,%edx
 2b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 2b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 2ba:	0f be 02             	movsbl (%edx),%eax
 2bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2c0:	80 fb 09             	cmp    $0x9,%bl
 2c3:	76 eb                	jbe    2b0 <atoi+0x20>
  return n;
}
 2c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2c8:	89 c8                	mov    %ecx,%eax
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	57                   	push   %edi
 2d4:	8b 45 10             	mov    0x10(%ebp),%eax
 2d7:	8b 55 08             	mov    0x8(%ebp),%edx
 2da:	56                   	push   %esi
 2db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2de:	85 c0                	test   %eax,%eax
 2e0:	7e 13                	jle    2f5 <memmove+0x25>
 2e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2e4:	89 d7                	mov    %edx,%edi
 2e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2f1:	39 f8                	cmp    %edi,%eax
 2f3:	75 fb                	jne    2f0 <memmove+0x20>
  return vdst;
}
 2f5:	5e                   	pop    %esi
 2f6:	89 d0                	mov    %edx,%eax
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    

000002fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2fb:	b8 01 00 00 00       	mov    $0x1,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exit>:
SYSCALL(exit)
 303:	b8 02 00 00 00       	mov    $0x2,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <wait>:
SYSCALL(wait)
 30b:	b8 03 00 00 00       	mov    $0x3,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <pipe>:
SYSCALL(pipe)
 313:	b8 04 00 00 00       	mov    $0x4,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <read>:
SYSCALL(read)
 31b:	b8 05 00 00 00       	mov    $0x5,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <write>:
SYSCALL(write)
 323:	b8 10 00 00 00       	mov    $0x10,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <close>:
SYSCALL(close)
 32b:	b8 15 00 00 00       	mov    $0x15,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <kill>:
SYSCALL(kill)
 333:	b8 06 00 00 00       	mov    $0x6,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <exec>:
SYSCALL(exec)
 33b:	b8 07 00 00 00       	mov    $0x7,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <open>:
SYSCALL(open)
 343:	b8 0f 00 00 00       	mov    $0xf,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <mknod>:
SYSCALL(mknod)
 34b:	b8 11 00 00 00       	mov    $0x11,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <unlink>:
SYSCALL(unlink)
 353:	b8 12 00 00 00       	mov    $0x12,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <fstat>:
SYSCALL(fstat)
 35b:	b8 08 00 00 00       	mov    $0x8,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <link>:
SYSCALL(link)
 363:	b8 13 00 00 00       	mov    $0x13,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <mkdir>:
SYSCALL(mkdir)
 36b:	b8 14 00 00 00       	mov    $0x14,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <chdir>:
SYSCALL(chdir)
 373:	b8 09 00 00 00       	mov    $0x9,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <dup>:
SYSCALL(dup)
 37b:	b8 0a 00 00 00       	mov    $0xa,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <getpid>:
SYSCALL(getpid)
 383:	b8 0b 00 00 00       	mov    $0xb,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <sbrk>:
SYSCALL(sbrk)
 38b:	b8 0c 00 00 00       	mov    $0xc,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <sleep>:
SYSCALL(sleep)
 393:	b8 0d 00 00 00       	mov    $0xd,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <uptime>:
SYSCALL(uptime)
 39b:	b8 0e 00 00 00       	mov    $0xe,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <find_fibonacci_number>:
SYSCALL(find_fibonacci_number)
 3a3:	b8 16 00 00 00       	mov    $0x16,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <find_most_callee>:
SYSCALL(find_most_callee)
 3ab:	b8 17 00 00 00       	mov    $0x17,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <get_children_count>:
SYSCALL(get_children_count)
 3b3:	b8 18 00 00 00       	mov    $0x18,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <kill_first_child_process>:
SYSCALL(kill_first_child_process)
 3bb:	b8 19 00 00 00       	mov    $0x19,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <set_proc_queue>:
SYSCALL(set_proc_queue)
 3c3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <set_lottery_params>:
SYSCALL(set_lottery_params)
 3cb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <print_all_procs>:
 3d3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    
 3db:	66 90                	xchg   %ax,%ax
 3dd:	66 90                	xchg   %ax,%ax
 3df:	90                   	nop

000003e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	56                   	push   %esi
 3e5:	53                   	push   %ebx
 3e6:	83 ec 3c             	sub    $0x3c,%esp
 3e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3ec:	89 d1                	mov    %edx,%ecx
{
 3ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3f1:	85 d2                	test   %edx,%edx
 3f3:	0f 89 7f 00 00 00    	jns    478 <printint+0x98>
 3f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3fd:	74 79                	je     478 <printint+0x98>
    neg = 1;
 3ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 406:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 408:	31 db                	xor    %ebx,%ebx
 40a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 40d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 410:	89 c8                	mov    %ecx,%eax
 412:	31 d2                	xor    %edx,%edx
 414:	89 cf                	mov    %ecx,%edi
 416:	f7 75 c4             	divl   -0x3c(%ebp)
 419:	0f b6 92 1c 09 00 00 	movzbl 0x91c(%edx),%edx
 420:	89 45 c0             	mov    %eax,-0x40(%ebp)
 423:	89 d8                	mov    %ebx,%eax
 425:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 428:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 42b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 42e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 431:	76 dd                	jbe    410 <printint+0x30>
  if(neg)
 433:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 436:	85 c9                	test   %ecx,%ecx
 438:	74 0c                	je     446 <printint+0x66>
    buf[i++] = '-';
 43a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 43f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 441:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 446:	8b 7d b8             	mov    -0x48(%ebp),%edi
 449:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 44d:	eb 07                	jmp    456 <printint+0x76>
 44f:	90                   	nop
    putc(fd, buf[i]);
 450:	0f b6 13             	movzbl (%ebx),%edx
 453:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 456:	83 ec 04             	sub    $0x4,%esp
 459:	88 55 d7             	mov    %dl,-0x29(%ebp)
 45c:	6a 01                	push   $0x1
 45e:	56                   	push   %esi
 45f:	57                   	push   %edi
 460:	e8 be fe ff ff       	call   323 <write>
  while(--i >= 0)
 465:	83 c4 10             	add    $0x10,%esp
 468:	39 de                	cmp    %ebx,%esi
 46a:	75 e4                	jne    450 <printint+0x70>
}
 46c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46f:	5b                   	pop    %ebx
 470:	5e                   	pop    %esi
 471:	5f                   	pop    %edi
 472:	5d                   	pop    %ebp
 473:	c3                   	ret    
 474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 478:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 47f:	eb 87                	jmp    408 <printint+0x28>
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 488:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48f:	90                   	nop

00000490 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 499:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 49c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 49f:	0f b6 13             	movzbl (%ebx),%edx
 4a2:	84 d2                	test   %dl,%dl
 4a4:	74 6a                	je     510 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4a6:	8d 45 10             	lea    0x10(%ebp),%eax
 4a9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4ac:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4af:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4b4:	eb 36                	jmp    4ec <printf+0x5c>
 4b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4bd:	8d 76 00             	lea    0x0(%esi),%esi
 4c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4c3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4c8:	83 f8 25             	cmp    $0x25,%eax
 4cb:	74 15                	je     4e2 <printf+0x52>
  write(fd, &c, 1);
 4cd:	83 ec 04             	sub    $0x4,%esp
 4d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4d3:	6a 01                	push   $0x1
 4d5:	57                   	push   %edi
 4d6:	56                   	push   %esi
 4d7:	e8 47 fe ff ff       	call   323 <write>
 4dc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4e2:	0f b6 13             	movzbl (%ebx),%edx
 4e5:	83 c3 01             	add    $0x1,%ebx
 4e8:	84 d2                	test   %dl,%dl
 4ea:	74 24                	je     510 <printf+0x80>
    c = fmt[i] & 0xff;
 4ec:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4ef:	85 c9                	test   %ecx,%ecx
 4f1:	74 cd                	je     4c0 <printf+0x30>
      }
    } else if(state == '%'){
 4f3:	83 f9 25             	cmp    $0x25,%ecx
 4f6:	75 ea                	jne    4e2 <printf+0x52>
      if(c == 'd'){
 4f8:	83 f8 25             	cmp    $0x25,%eax
 4fb:	0f 84 07 01 00 00    	je     608 <printf+0x178>
 501:	83 e8 63             	sub    $0x63,%eax
 504:	83 f8 15             	cmp    $0x15,%eax
 507:	77 17                	ja     520 <printf+0x90>
 509:	ff 24 85 c4 08 00 00 	jmp    *0x8c4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 510:	8d 65 f4             	lea    -0xc(%ebp),%esp
 513:	5b                   	pop    %ebx
 514:	5e                   	pop    %esi
 515:	5f                   	pop    %edi
 516:	5d                   	pop    %ebp
 517:	c3                   	ret    
 518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51f:	90                   	nop
  write(fd, &c, 1);
 520:	83 ec 04             	sub    $0x4,%esp
 523:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 526:	6a 01                	push   $0x1
 528:	57                   	push   %edi
 529:	56                   	push   %esi
 52a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 52e:	e8 f0 fd ff ff       	call   323 <write>
        putc(fd, c);
 533:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 537:	83 c4 0c             	add    $0xc,%esp
 53a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 53d:	6a 01                	push   $0x1
 53f:	57                   	push   %edi
 540:	56                   	push   %esi
 541:	e8 dd fd ff ff       	call   323 <write>
        putc(fd, c);
 546:	83 c4 10             	add    $0x10,%esp
      state = 0;
 549:	31 c9                	xor    %ecx,%ecx
 54b:	eb 95                	jmp    4e2 <printf+0x52>
 54d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 550:	83 ec 0c             	sub    $0xc,%esp
 553:	b9 10 00 00 00       	mov    $0x10,%ecx
 558:	6a 00                	push   $0x0
 55a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 55d:	8b 10                	mov    (%eax),%edx
 55f:	89 f0                	mov    %esi,%eax
 561:	e8 7a fe ff ff       	call   3e0 <printint>
        ap++;
 566:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 56a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 56d:	31 c9                	xor    %ecx,%ecx
 56f:	e9 6e ff ff ff       	jmp    4e2 <printf+0x52>
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 578:	8b 45 d0             	mov    -0x30(%ebp),%eax
 57b:	8b 10                	mov    (%eax),%edx
        ap++;
 57d:	83 c0 04             	add    $0x4,%eax
 580:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 583:	85 d2                	test   %edx,%edx
 585:	0f 84 8d 00 00 00    	je     618 <printf+0x188>
        while(*s != 0){
 58b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 58e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 590:	84 c0                	test   %al,%al
 592:	0f 84 4a ff ff ff    	je     4e2 <printf+0x52>
 598:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 59b:	89 d3                	mov    %edx,%ebx
 59d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5a0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5a3:	83 c3 01             	add    $0x1,%ebx
 5a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5a9:	6a 01                	push   $0x1
 5ab:	57                   	push   %edi
 5ac:	56                   	push   %esi
 5ad:	e8 71 fd ff ff       	call   323 <write>
        while(*s != 0){
 5b2:	0f b6 03             	movzbl (%ebx),%eax
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	84 c0                	test   %al,%al
 5ba:	75 e4                	jne    5a0 <printf+0x110>
      state = 0;
 5bc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5bf:	31 c9                	xor    %ecx,%ecx
 5c1:	e9 1c ff ff ff       	jmp    4e2 <printf+0x52>
 5c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5d0:	83 ec 0c             	sub    $0xc,%esp
 5d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5d8:	6a 01                	push   $0x1
 5da:	e9 7b ff ff ff       	jmp    55a <printf+0xca>
 5df:	90                   	nop
        putc(fd, *ap);
 5e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 5e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5e6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 5e8:	6a 01                	push   $0x1
 5ea:	57                   	push   %edi
 5eb:	56                   	push   %esi
        putc(fd, *ap);
 5ec:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5ef:	e8 2f fd ff ff       	call   323 <write>
        ap++;
 5f4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5fb:	31 c9                	xor    %ecx,%ecx
 5fd:	e9 e0 fe ff ff       	jmp    4e2 <printf+0x52>
 602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 608:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 60b:	83 ec 04             	sub    $0x4,%esp
 60e:	e9 2a ff ff ff       	jmp    53d <printf+0xad>
 613:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 617:	90                   	nop
          s = "(null)";
 618:	ba ba 08 00 00       	mov    $0x8ba,%edx
        while(*s != 0){
 61d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 620:	b8 28 00 00 00       	mov    $0x28,%eax
 625:	89 d3                	mov    %edx,%ebx
 627:	e9 74 ff ff ff       	jmp    5a0 <printf+0x110>
 62c:	66 90                	xchg   %ax,%ax
 62e:	66 90                	xchg   %ax,%ax

00000630 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 630:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	a1 cc 0b 00 00       	mov    0xbcc,%eax
{
 636:	89 e5                	mov    %esp,%ebp
 638:	57                   	push   %edi
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 63e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 648:	89 c2                	mov    %eax,%edx
 64a:	8b 00                	mov    (%eax),%eax
 64c:	39 ca                	cmp    %ecx,%edx
 64e:	73 30                	jae    680 <free+0x50>
 650:	39 c1                	cmp    %eax,%ecx
 652:	72 04                	jb     658 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 654:	39 c2                	cmp    %eax,%edx
 656:	72 f0                	jb     648 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 658:	8b 73 fc             	mov    -0x4(%ebx),%esi
 65b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 65e:	39 f8                	cmp    %edi,%eax
 660:	74 30                	je     692 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 662:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 665:	8b 42 04             	mov    0x4(%edx),%eax
 668:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 66b:	39 f1                	cmp    %esi,%ecx
 66d:	74 3a                	je     6a9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 66f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 671:	5b                   	pop    %ebx
  freep = p;
 672:	89 15 cc 0b 00 00    	mov    %edx,0xbcc
}
 678:	5e                   	pop    %esi
 679:	5f                   	pop    %edi
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret    
 67c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 680:	39 c2                	cmp    %eax,%edx
 682:	72 c4                	jb     648 <free+0x18>
 684:	39 c1                	cmp    %eax,%ecx
 686:	73 c0                	jae    648 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 688:	8b 73 fc             	mov    -0x4(%ebx),%esi
 68b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 68e:	39 f8                	cmp    %edi,%eax
 690:	75 d0                	jne    662 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 692:	03 70 04             	add    0x4(%eax),%esi
 695:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 698:	8b 02                	mov    (%edx),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 69f:	8b 42 04             	mov    0x4(%edx),%eax
 6a2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6a5:	39 f1                	cmp    %esi,%ecx
 6a7:	75 c6                	jne    66f <free+0x3f>
    p->s.size += bp->s.size;
 6a9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6ac:	89 15 cc 0b 00 00    	mov    %edx,0xbcc
    p->s.size += bp->s.size;
 6b2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6b5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6b8:	89 0a                	mov    %ecx,(%edx)
}
 6ba:	5b                   	pop    %ebx
 6bb:	5e                   	pop    %esi
 6bc:	5f                   	pop    %edi
 6bd:	5d                   	pop    %ebp
 6be:	c3                   	ret    
 6bf:	90                   	nop

000006c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6cc:	8b 3d cc 0b 00 00    	mov    0xbcc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d2:	8d 70 07             	lea    0x7(%eax),%esi
 6d5:	c1 ee 03             	shr    $0x3,%esi
 6d8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6db:	85 ff                	test   %edi,%edi
 6dd:	0f 84 9d 00 00 00    	je     780 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6e5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6e8:	39 f1                	cmp    %esi,%ecx
 6ea:	73 6a                	jae    756 <malloc+0x96>
 6ec:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6f1:	39 de                	cmp    %ebx,%esi
 6f3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6f6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 700:	eb 17                	jmp    719 <malloc+0x59>
 702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 708:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 70a:	8b 48 04             	mov    0x4(%eax),%ecx
 70d:	39 f1                	cmp    %esi,%ecx
 70f:	73 4f                	jae    760 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 711:	8b 3d cc 0b 00 00    	mov    0xbcc,%edi
 717:	89 c2                	mov    %eax,%edx
 719:	39 d7                	cmp    %edx,%edi
 71b:	75 eb                	jne    708 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 71d:	83 ec 0c             	sub    $0xc,%esp
 720:	ff 75 e4             	push   -0x1c(%ebp)
 723:	e8 63 fc ff ff       	call   38b <sbrk>
  if(p == (char*)-1)
 728:	83 c4 10             	add    $0x10,%esp
 72b:	83 f8 ff             	cmp    $0xffffffff,%eax
 72e:	74 1c                	je     74c <malloc+0x8c>
  hp->s.size = nu;
 730:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 733:	83 ec 0c             	sub    $0xc,%esp
 736:	83 c0 08             	add    $0x8,%eax
 739:	50                   	push   %eax
 73a:	e8 f1 fe ff ff       	call   630 <free>
  return freep;
 73f:	8b 15 cc 0b 00 00    	mov    0xbcc,%edx
      if((p = morecore(nunits)) == 0)
 745:	83 c4 10             	add    $0x10,%esp
 748:	85 d2                	test   %edx,%edx
 74a:	75 bc                	jne    708 <malloc+0x48>
        return 0;
  }
}
 74c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 74f:	31 c0                	xor    %eax,%eax
}
 751:	5b                   	pop    %ebx
 752:	5e                   	pop    %esi
 753:	5f                   	pop    %edi
 754:	5d                   	pop    %ebp
 755:	c3                   	ret    
    if(p->s.size >= nunits){
 756:	89 d0                	mov    %edx,%eax
 758:	89 fa                	mov    %edi,%edx
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 760:	39 ce                	cmp    %ecx,%esi
 762:	74 4c                	je     7b0 <malloc+0xf0>
        p->s.size -= nunits;
 764:	29 f1                	sub    %esi,%ecx
 766:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 769:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 76c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 76f:	89 15 cc 0b 00 00    	mov    %edx,0xbcc
}
 775:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 778:	83 c0 08             	add    $0x8,%eax
}
 77b:	5b                   	pop    %ebx
 77c:	5e                   	pop    %esi
 77d:	5f                   	pop    %edi
 77e:	5d                   	pop    %ebp
 77f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 780:	c7 05 cc 0b 00 00 d0 	movl   $0xbd0,0xbcc
 787:	0b 00 00 
    base.s.size = 0;
 78a:	bf d0 0b 00 00       	mov    $0xbd0,%edi
    base.s.ptr = freep = prevp = &base;
 78f:	c7 05 d0 0b 00 00 d0 	movl   $0xbd0,0xbd0
 796:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 799:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 79b:	c7 05 d4 0b 00 00 00 	movl   $0x0,0xbd4
 7a2:	00 00 00 
    if(p->s.size >= nunits){
 7a5:	e9 42 ff ff ff       	jmp    6ec <malloc+0x2c>
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7b0:	8b 08                	mov    (%eax),%ecx
 7b2:	89 0a                	mov    %ecx,(%edx)
 7b4:	eb b9                	jmp    76f <malloc+0xaf>
