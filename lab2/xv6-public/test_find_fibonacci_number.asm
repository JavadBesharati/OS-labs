
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
  1a:	68 a8 07 00 00       	push   $0x7a8
  1f:	6a 01                	push   $0x1
  21:	e8 fd 02 00 00       	call   323 <write>
    
    if(argc != 2){
  26:	83 c4 10             	add    $0x10,%esp
  29:	83 fb 02             	cmp    $0x2,%ebx
  2c:	74 14                	je     42 <main+0x42>
        write(1, "Invalid input. Please enter just a single integer.\n", 51);
  2e:	53                   	push   %ebx
  2f:	6a 33                	push   $0x33
  31:	68 dc 07 00 00       	push   $0x7dc
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
  57:	68 10 08 00 00       	push   $0x810
  5c:	6a 01                	push   $0x1
  5e:	e8 1d 04 00 00       	call   480 <printf>

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
  74:	68 6c 08 00 00       	push   $0x86c
  79:	6a 01                	push   $0x1
  7b:	e8 00 04 00 00       	call   480 <printf>
    exit();
  80:	e8 7e 02 00 00       	call   303 <exit>
        printf(1, "find_fibonacci_number failed\n");
  85:	50                   	push   %eax
  86:	50                   	push   %eax
  87:	68 8c 08 00 00       	push   $0x88c
  8c:	6a 01                	push   $0x1
  8e:	e8 ed 03 00 00       	call   480 <printf>
        printf(1, "Please check if you entered an integer smaller than 1\n");
  93:	5a                   	pop    %edx
  94:	59                   	pop    %ecx
  95:	68 34 08 00 00       	push   $0x834
  9a:	6a 01                	push   $0x1
  9c:	e8 df 03 00 00       	call   480 <printf>
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
 3c3:	66 90                	xchg   %ax,%ax
 3c5:	66 90                	xchg   %ax,%ax
 3c7:	66 90                	xchg   %ax,%ax
 3c9:	66 90                	xchg   %ax,%ax
 3cb:	66 90                	xchg   %ax,%ax
 3cd:	66 90                	xchg   %ax,%ax
 3cf:	90                   	nop

000003d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	56                   	push   %esi
 3d5:	53                   	push   %ebx
 3d6:	83 ec 3c             	sub    $0x3c,%esp
 3d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3dc:	89 d1                	mov    %edx,%ecx
{
 3de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 3e1:	85 d2                	test   %edx,%edx
 3e3:	0f 89 7f 00 00 00    	jns    468 <printint+0x98>
 3e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 3ed:	74 79                	je     468 <printint+0x98>
    neg = 1;
 3ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 3f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 3f8:	31 db                	xor    %ebx,%ebx
 3fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 400:	89 c8                	mov    %ecx,%eax
 402:	31 d2                	xor    %edx,%edx
 404:	89 cf                	mov    %ecx,%edi
 406:	f7 75 c4             	divl   -0x3c(%ebp)
 409:	0f b6 92 0c 09 00 00 	movzbl 0x90c(%edx),%edx
 410:	89 45 c0             	mov    %eax,-0x40(%ebp)
 413:	89 d8                	mov    %ebx,%eax
 415:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 418:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 41b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 41e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 421:	76 dd                	jbe    400 <printint+0x30>
  if(neg)
 423:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 426:	85 c9                	test   %ecx,%ecx
 428:	74 0c                	je     436 <printint+0x66>
    buf[i++] = '-';
 42a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 42f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 431:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 436:	8b 7d b8             	mov    -0x48(%ebp),%edi
 439:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 43d:	eb 07                	jmp    446 <printint+0x76>
 43f:	90                   	nop
    putc(fd, buf[i]);
 440:	0f b6 13             	movzbl (%ebx),%edx
 443:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 446:	83 ec 04             	sub    $0x4,%esp
 449:	88 55 d7             	mov    %dl,-0x29(%ebp)
 44c:	6a 01                	push   $0x1
 44e:	56                   	push   %esi
 44f:	57                   	push   %edi
 450:	e8 ce fe ff ff       	call   323 <write>
  while(--i >= 0)
 455:	83 c4 10             	add    $0x10,%esp
 458:	39 de                	cmp    %ebx,%esi
 45a:	75 e4                	jne    440 <printint+0x70>
}
 45c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45f:	5b                   	pop    %ebx
 460:	5e                   	pop    %esi
 461:	5f                   	pop    %edi
 462:	5d                   	pop    %ebp
 463:	c3                   	ret    
 464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 468:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 46f:	eb 87                	jmp    3f8 <printint+0x28>
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47f:	90                   	nop

00000480 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	57                   	push   %edi
 484:	56                   	push   %esi
 485:	53                   	push   %ebx
 486:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 48c:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 48f:	0f b6 13             	movzbl (%ebx),%edx
 492:	84 d2                	test   %dl,%dl
 494:	74 6a                	je     500 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 496:	8d 45 10             	lea    0x10(%ebp),%eax
 499:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 49c:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 49f:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4a4:	eb 36                	jmp    4dc <printf+0x5c>
 4a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ad:	8d 76 00             	lea    0x0(%esi),%esi
 4b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4b3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4b8:	83 f8 25             	cmp    $0x25,%eax
 4bb:	74 15                	je     4d2 <printf+0x52>
  write(fd, &c, 1);
 4bd:	83 ec 04             	sub    $0x4,%esp
 4c0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4c3:	6a 01                	push   $0x1
 4c5:	57                   	push   %edi
 4c6:	56                   	push   %esi
 4c7:	e8 57 fe ff ff       	call   323 <write>
 4cc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4cf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4d2:	0f b6 13             	movzbl (%ebx),%edx
 4d5:	83 c3 01             	add    $0x1,%ebx
 4d8:	84 d2                	test   %dl,%dl
 4da:	74 24                	je     500 <printf+0x80>
    c = fmt[i] & 0xff;
 4dc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4df:	85 c9                	test   %ecx,%ecx
 4e1:	74 cd                	je     4b0 <printf+0x30>
      }
    } else if(state == '%'){
 4e3:	83 f9 25             	cmp    $0x25,%ecx
 4e6:	75 ea                	jne    4d2 <printf+0x52>
      if(c == 'd'){
 4e8:	83 f8 25             	cmp    $0x25,%eax
 4eb:	0f 84 07 01 00 00    	je     5f8 <printf+0x178>
 4f1:	83 e8 63             	sub    $0x63,%eax
 4f4:	83 f8 15             	cmp    $0x15,%eax
 4f7:	77 17                	ja     510 <printf+0x90>
 4f9:	ff 24 85 b4 08 00 00 	jmp    *0x8b4(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 500:	8d 65 f4             	lea    -0xc(%ebp),%esp
 503:	5b                   	pop    %ebx
 504:	5e                   	pop    %esi
 505:	5f                   	pop    %edi
 506:	5d                   	pop    %ebp
 507:	c3                   	ret    
 508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop
  write(fd, &c, 1);
 510:	83 ec 04             	sub    $0x4,%esp
 513:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 516:	6a 01                	push   $0x1
 518:	57                   	push   %edi
 519:	56                   	push   %esi
 51a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 51e:	e8 00 fe ff ff       	call   323 <write>
        putc(fd, c);
 523:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 527:	83 c4 0c             	add    $0xc,%esp
 52a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 52d:	6a 01                	push   $0x1
 52f:	57                   	push   %edi
 530:	56                   	push   %esi
 531:	e8 ed fd ff ff       	call   323 <write>
        putc(fd, c);
 536:	83 c4 10             	add    $0x10,%esp
      state = 0;
 539:	31 c9                	xor    %ecx,%ecx
 53b:	eb 95                	jmp    4d2 <printf+0x52>
 53d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 540:	83 ec 0c             	sub    $0xc,%esp
 543:	b9 10 00 00 00       	mov    $0x10,%ecx
 548:	6a 00                	push   $0x0
 54a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 54d:	8b 10                	mov    (%eax),%edx
 54f:	89 f0                	mov    %esi,%eax
 551:	e8 7a fe ff ff       	call   3d0 <printint>
        ap++;
 556:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 55a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55d:	31 c9                	xor    %ecx,%ecx
 55f:	e9 6e ff ff ff       	jmp    4d2 <printf+0x52>
 564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 568:	8b 45 d0             	mov    -0x30(%ebp),%eax
 56b:	8b 10                	mov    (%eax),%edx
        ap++;
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 573:	85 d2                	test   %edx,%edx
 575:	0f 84 8d 00 00 00    	je     608 <printf+0x188>
        while(*s != 0){
 57b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 57e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 580:	84 c0                	test   %al,%al
 582:	0f 84 4a ff ff ff    	je     4d2 <printf+0x52>
 588:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 58b:	89 d3                	mov    %edx,%ebx
 58d:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
          s++;
 593:	83 c3 01             	add    $0x1,%ebx
 596:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 599:	6a 01                	push   $0x1
 59b:	57                   	push   %edi
 59c:	56                   	push   %esi
 59d:	e8 81 fd ff ff       	call   323 <write>
        while(*s != 0){
 5a2:	0f b6 03             	movzbl (%ebx),%eax
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	84 c0                	test   %al,%al
 5aa:	75 e4                	jne    590 <printf+0x110>
      state = 0;
 5ac:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5af:	31 c9                	xor    %ecx,%ecx
 5b1:	e9 1c ff ff ff       	jmp    4d2 <printf+0x52>
 5b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5bd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5c0:	83 ec 0c             	sub    $0xc,%esp
 5c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5c8:	6a 01                	push   $0x1
 5ca:	e9 7b ff ff ff       	jmp    54a <printf+0xca>
 5cf:	90                   	nop
        putc(fd, *ap);
 5d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 5d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5d6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 5d8:	6a 01                	push   $0x1
 5da:	57                   	push   %edi
 5db:	56                   	push   %esi
        putc(fd, *ap);
 5dc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5df:	e8 3f fd ff ff       	call   323 <write>
        ap++;
 5e4:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5eb:	31 c9                	xor    %ecx,%ecx
 5ed:	e9 e0 fe ff ff       	jmp    4d2 <printf+0x52>
 5f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 5f8:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5fb:	83 ec 04             	sub    $0x4,%esp
 5fe:	e9 2a ff ff ff       	jmp    52d <printf+0xad>
 603:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 607:	90                   	nop
          s = "(null)";
 608:	ba aa 08 00 00       	mov    $0x8aa,%edx
        while(*s != 0){
 60d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 610:	b8 28 00 00 00       	mov    $0x28,%eax
 615:	89 d3                	mov    %edx,%ebx
 617:	e9 74 ff ff ff       	jmp    590 <printf+0x110>
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 bc 0b 00 00       	mov    0xbbc,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 62e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 638:	89 c2                	mov    %eax,%edx
 63a:	8b 00                	mov    (%eax),%eax
 63c:	39 ca                	cmp    %ecx,%edx
 63e:	73 30                	jae    670 <free+0x50>
 640:	39 c1                	cmp    %eax,%ecx
 642:	72 04                	jb     648 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	39 c2                	cmp    %eax,%edx
 646:	72 f0                	jb     638 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 648:	8b 73 fc             	mov    -0x4(%ebx),%esi
 64b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 64e:	39 f8                	cmp    %edi,%eax
 650:	74 30                	je     682 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 652:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 655:	8b 42 04             	mov    0x4(%edx),%eax
 658:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 65b:	39 f1                	cmp    %esi,%ecx
 65d:	74 3a                	je     699 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 65f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 661:	5b                   	pop    %ebx
  freep = p;
 662:	89 15 bc 0b 00 00    	mov    %edx,0xbbc
}
 668:	5e                   	pop    %esi
 669:	5f                   	pop    %edi
 66a:	5d                   	pop    %ebp
 66b:	c3                   	ret    
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	39 c2                	cmp    %eax,%edx
 672:	72 c4                	jb     638 <free+0x18>
 674:	39 c1                	cmp    %eax,%ecx
 676:	73 c0                	jae    638 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 678:	8b 73 fc             	mov    -0x4(%ebx),%esi
 67b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67e:	39 f8                	cmp    %edi,%eax
 680:	75 d0                	jne    652 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 682:	03 70 04             	add    0x4(%eax),%esi
 685:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 688:	8b 02                	mov    (%edx),%eax
 68a:	8b 00                	mov    (%eax),%eax
 68c:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 68f:	8b 42 04             	mov    0x4(%edx),%eax
 692:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 695:	39 f1                	cmp    %esi,%ecx
 697:	75 c6                	jne    65f <free+0x3f>
    p->s.size += bp->s.size;
 699:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 69c:	89 15 bc 0b 00 00    	mov    %edx,0xbbc
    p->s.size += bp->s.size;
 6a2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6a5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6a8:	89 0a                	mov    %ecx,(%edx)
}
 6aa:	5b                   	pop    %ebx
 6ab:	5e                   	pop    %esi
 6ac:	5f                   	pop    %edi
 6ad:	5d                   	pop    %ebp
 6ae:	c3                   	ret    
 6af:	90                   	nop

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 3d bc 0b 00 00    	mov    0xbbc,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8d 70 07             	lea    0x7(%eax),%esi
 6c5:	c1 ee 03             	shr    $0x3,%esi
 6c8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6cb:	85 ff                	test   %edi,%edi
 6cd:	0f 84 9d 00 00 00    	je     770 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6d5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6d8:	39 f1                	cmp    %esi,%ecx
 6da:	73 6a                	jae    746 <malloc+0x96>
 6dc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 6e1:	39 de                	cmp    %ebx,%esi
 6e3:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 6e6:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6f0:	eb 17                	jmp    709 <malloc+0x59>
 6f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6fa:	8b 48 04             	mov    0x4(%eax),%ecx
 6fd:	39 f1                	cmp    %esi,%ecx
 6ff:	73 4f                	jae    750 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 701:	8b 3d bc 0b 00 00    	mov    0xbbc,%edi
 707:	89 c2                	mov    %eax,%edx
 709:	39 d7                	cmp    %edx,%edi
 70b:	75 eb                	jne    6f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 70d:	83 ec 0c             	sub    $0xc,%esp
 710:	ff 75 e4             	push   -0x1c(%ebp)
 713:	e8 73 fc ff ff       	call   38b <sbrk>
  if(p == (char*)-1)
 718:	83 c4 10             	add    $0x10,%esp
 71b:	83 f8 ff             	cmp    $0xffffffff,%eax
 71e:	74 1c                	je     73c <malloc+0x8c>
  hp->s.size = nu;
 720:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 723:	83 ec 0c             	sub    $0xc,%esp
 726:	83 c0 08             	add    $0x8,%eax
 729:	50                   	push   %eax
 72a:	e8 f1 fe ff ff       	call   620 <free>
  return freep;
 72f:	8b 15 bc 0b 00 00    	mov    0xbbc,%edx
      if((p = morecore(nunits)) == 0)
 735:	83 c4 10             	add    $0x10,%esp
 738:	85 d2                	test   %edx,%edx
 73a:	75 bc                	jne    6f8 <malloc+0x48>
        return 0;
  }
}
 73c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 73f:	31 c0                	xor    %eax,%eax
}
 741:	5b                   	pop    %ebx
 742:	5e                   	pop    %esi
 743:	5f                   	pop    %edi
 744:	5d                   	pop    %ebp
 745:	c3                   	ret    
    if(p->s.size >= nunits){
 746:	89 d0                	mov    %edx,%eax
 748:	89 fa                	mov    %edi,%edx
 74a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 750:	39 ce                	cmp    %ecx,%esi
 752:	74 4c                	je     7a0 <malloc+0xf0>
        p->s.size -= nunits;
 754:	29 f1                	sub    %esi,%ecx
 756:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 759:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 75c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 75f:	89 15 bc 0b 00 00    	mov    %edx,0xbbc
}
 765:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 768:	83 c0 08             	add    $0x8,%eax
}
 76b:	5b                   	pop    %ebx
 76c:	5e                   	pop    %esi
 76d:	5f                   	pop    %edi
 76e:	5d                   	pop    %ebp
 76f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 770:	c7 05 bc 0b 00 00 c0 	movl   $0xbc0,0xbbc
 777:	0b 00 00 
    base.s.size = 0;
 77a:	bf c0 0b 00 00       	mov    $0xbc0,%edi
    base.s.ptr = freep = prevp = &base;
 77f:	c7 05 c0 0b 00 00 c0 	movl   $0xbc0,0xbc0
 786:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 789:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 78b:	c7 05 c4 0b 00 00 00 	movl   $0x0,0xbc4
 792:	00 00 00 
    if(p->s.size >= nunits){
 795:	e9 42 ff ff ff       	jmp    6dc <malloc+0x2c>
 79a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7a0:	8b 08                	mov    (%eax),%ecx
 7a2:	89 0a                	mov    %ecx,(%edx)
 7a4:	eb b9                	jmp    75f <malloc+0xaf>
