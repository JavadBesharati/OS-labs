
_test_condvar:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
{
    struct spinlock lock;
};

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 44             	sub    $0x44,%esp
    struct condvar c;
    int pid = fork();
  11:	e8 e5 02 00 00       	call   2fb <fork>
    if (pid < 0)
  16:	85 c0                	test   %eax,%eax
  18:	78 44                	js     5e <main+0x5e>
    {
        printf(2, "Error forking first child!\n");
    }
    else if (pid == 0)
  1a:	75 2b                	jne    47 <main+0x47>
    {
        sleep(100);
  1c:	83 ec 0c             	sub    $0xc,%esp
  1f:	6a 64                	push   $0x64
  21:	e8 6d 03 00 00       	call   393 <sleep>
        printf(1, "Child 1 Executing.\n");
  26:	58                   	pop    %eax
  27:	5a                   	pop    %edx
  28:	68 24 08 00 00       	push   $0x824
  2d:	6a 01                	push   $0x1
  2f:	e8 ac 04 00 00       	call   4e0 <printf>
        cv_signal(&c);
  34:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  37:	89 04 24             	mov    %eax,(%esp)
  3a:	e8 cc 03 00 00       	call   40b <cv_signal>
  3f:	83 c4 10             	add    $0x10,%esp
            {
                wait();
            }
        }
    }
    exit();
  42:	e8 bc 02 00 00       	call   303 <exit>
        pid = fork();
  47:	e8 af 02 00 00       	call   2fb <fork>
        if (pid < 0)
  4c:	85 c0                	test   %eax,%eax
  4e:	78 40                	js     90 <main+0x90>
        else if (pid == 0)
  50:	74 1f                	je     71 <main+0x71>
                wait();
  52:	e8 b4 02 00 00       	call   30b <wait>
  57:	e8 af 02 00 00       	call   30b <wait>
            for (i = 0; i < 2; i++)
  5c:	eb e4                	jmp    42 <main+0x42>
        printf(2, "Error forking first child!\n");
  5e:	51                   	push   %ecx
  5f:	51                   	push   %ecx
  60:	68 08 08 00 00       	push   $0x808
  65:	6a 02                	push   $0x2
  67:	e8 74 04 00 00       	call   4e0 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  6f:	eb d1                	jmp    42 <main+0x42>
            cv_wait(&c);
  71:	83 ec 0c             	sub    $0xc,%esp
  74:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  77:	50                   	push   %eax
  78:	e8 86 03 00 00       	call   403 <cv_wait>
            printf(1, "Child 2 Executing.\n");
  7d:	58                   	pop    %eax
  7e:	5a                   	pop    %edx
  7f:	68 55 08 00 00       	push   $0x855
  84:	6a 01                	push   $0x1
  86:	e8 55 04 00 00       	call   4e0 <printf>
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	eb b2                	jmp    42 <main+0x42>
            printf(2, "Error forking second child!\n");
  90:	51                   	push   %ecx
  91:	51                   	push   %ecx
  92:	68 38 08 00 00       	push   $0x838
  97:	6a 02                	push   $0x2
  99:	e8 42 04 00 00       	call   4e0 <printf>
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	eb 9f                	jmp    42 <main+0x42>
  a3:	66 90                	xchg   %ax,%ax
  a5:	66 90                	xchg   %ax,%ax
  a7:	66 90                	xchg   %ax,%ax
  a9:	66 90                	xchg   %ax,%ax
  ab:	66 90                	xchg   %ax,%ax
  ad:	66 90                	xchg   %ax,%ax
  af:	90                   	nop

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
SYSCALL(print_all_procs)
 3d3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <sem_init>:
SYSCALL(sem_init)
 3db:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <sem_acquire>:
SYSCALL(sem_acquire)
 3e3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sem_release>:
SYSCALL(sem_release)
 3eb:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <producer>:
SYSCALL(producer)
 3f3:	b8 20 00 00 00       	mov    $0x20,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <consumer>:
SYSCALL(consumer)
 3fb:	b8 21 00 00 00       	mov    $0x21,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <cv_wait>:
SYSCALL(cv_wait)
 403:	b8 22 00 00 00       	mov    $0x22,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <cv_signal>:
SYSCALL(cv_signal)
 40b:	b8 23 00 00 00       	mov    $0x23,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <reader>:
SYSCALL(reader)
 413:	b8 24 00 00 00       	mov    $0x24,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <writer>:
 41b:	b8 25 00 00 00       	mov    $0x25,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    
 423:	66 90                	xchg   %ax,%ax
 425:	66 90                	xchg   %ax,%ax
 427:	66 90                	xchg   %ax,%ax
 429:	66 90                	xchg   %ax,%ax
 42b:	66 90                	xchg   %ax,%ax
 42d:	66 90                	xchg   %ax,%ax
 42f:	90                   	nop

00000430 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
 434:	56                   	push   %esi
 435:	53                   	push   %ebx
 436:	83 ec 3c             	sub    $0x3c,%esp
 439:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 43c:	89 d1                	mov    %edx,%ecx
{
 43e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 441:	85 d2                	test   %edx,%edx
 443:	0f 89 7f 00 00 00    	jns    4c8 <printint+0x98>
 449:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 44d:	74 79                	je     4c8 <printint+0x98>
    neg = 1;
 44f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 456:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 458:	31 db                	xor    %ebx,%ebx
 45a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 45d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 460:	89 c8                	mov    %ecx,%eax
 462:	31 d2                	xor    %edx,%edx
 464:	89 cf                	mov    %ecx,%edi
 466:	f7 75 c4             	divl   -0x3c(%ebp)
 469:	0f b6 92 c8 08 00 00 	movzbl 0x8c8(%edx),%edx
 470:	89 45 c0             	mov    %eax,-0x40(%ebp)
 473:	89 d8                	mov    %ebx,%eax
 475:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 478:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 47b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 47e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 481:	76 dd                	jbe    460 <printint+0x30>
  if(neg)
 483:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 486:	85 c9                	test   %ecx,%ecx
 488:	74 0c                	je     496 <printint+0x66>
    buf[i++] = '-';
 48a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 48f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 491:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 496:	8b 7d b8             	mov    -0x48(%ebp),%edi
 499:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 49d:	eb 07                	jmp    4a6 <printint+0x76>
 49f:	90                   	nop
    putc(fd, buf[i]);
 4a0:	0f b6 13             	movzbl (%ebx),%edx
 4a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 4a6:	83 ec 04             	sub    $0x4,%esp
 4a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 4ac:	6a 01                	push   $0x1
 4ae:	56                   	push   %esi
 4af:	57                   	push   %edi
 4b0:	e8 6e fe ff ff       	call   323 <write>
  while(--i >= 0)
 4b5:	83 c4 10             	add    $0x10,%esp
 4b8:	39 de                	cmp    %ebx,%esi
 4ba:	75 e4                	jne    4a0 <printint+0x70>
}
 4bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4bf:	5b                   	pop    %ebx
 4c0:	5e                   	pop    %esi
 4c1:	5f                   	pop    %edi
 4c2:	5d                   	pop    %ebp
 4c3:	c3                   	ret    
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 4c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 4cf:	eb 87                	jmp    458 <printint+0x28>
 4d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4df:	90                   	nop

000004e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4ec:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4ef:	0f b6 13             	movzbl (%ebx),%edx
 4f2:	84 d2                	test   %dl,%dl
 4f4:	74 6a                	je     560 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4f6:	8d 45 10             	lea    0x10(%ebp),%eax
 4f9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4fc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4ff:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 501:	89 45 d0             	mov    %eax,-0x30(%ebp)
 504:	eb 36                	jmp    53c <printf+0x5c>
 506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 513:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 518:	83 f8 25             	cmp    $0x25,%eax
 51b:	74 15                	je     532 <printf+0x52>
  write(fd, &c, 1);
 51d:	83 ec 04             	sub    $0x4,%esp
 520:	88 55 e7             	mov    %dl,-0x19(%ebp)
 523:	6a 01                	push   $0x1
 525:	57                   	push   %edi
 526:	56                   	push   %esi
 527:	e8 f7 fd ff ff       	call   323 <write>
 52c:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 52f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 532:	0f b6 13             	movzbl (%ebx),%edx
 535:	83 c3 01             	add    $0x1,%ebx
 538:	84 d2                	test   %dl,%dl
 53a:	74 24                	je     560 <printf+0x80>
    c = fmt[i] & 0xff;
 53c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 53f:	85 c9                	test   %ecx,%ecx
 541:	74 cd                	je     510 <printf+0x30>
      }
    } else if(state == '%'){
 543:	83 f9 25             	cmp    $0x25,%ecx
 546:	75 ea                	jne    532 <printf+0x52>
      if(c == 'd'){
 548:	83 f8 25             	cmp    $0x25,%eax
 54b:	0f 84 07 01 00 00    	je     658 <printf+0x178>
 551:	83 e8 63             	sub    $0x63,%eax
 554:	83 f8 15             	cmp    $0x15,%eax
 557:	77 17                	ja     570 <printf+0x90>
 559:	ff 24 85 70 08 00 00 	jmp    *0x870(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 560:	8d 65 f4             	lea    -0xc(%ebp),%esp
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    
 568:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56f:	90                   	nop
  write(fd, &c, 1);
 570:	83 ec 04             	sub    $0x4,%esp
 573:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 576:	6a 01                	push   $0x1
 578:	57                   	push   %edi
 579:	56                   	push   %esi
 57a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 57e:	e8 a0 fd ff ff       	call   323 <write>
        putc(fd, c);
 583:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 587:	83 c4 0c             	add    $0xc,%esp
 58a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 58d:	6a 01                	push   $0x1
 58f:	57                   	push   %edi
 590:	56                   	push   %esi
 591:	e8 8d fd ff ff       	call   323 <write>
        putc(fd, c);
 596:	83 c4 10             	add    $0x10,%esp
      state = 0;
 599:	31 c9                	xor    %ecx,%ecx
 59b:	eb 95                	jmp    532 <printf+0x52>
 59d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 5a0:	83 ec 0c             	sub    $0xc,%esp
 5a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 5a8:	6a 00                	push   $0x0
 5aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5ad:	8b 10                	mov    (%eax),%edx
 5af:	89 f0                	mov    %esi,%eax
 5b1:	e8 7a fe ff ff       	call   430 <printint>
        ap++;
 5b6:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 5ba:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bd:	31 c9                	xor    %ecx,%ecx
 5bf:	e9 6e ff ff ff       	jmp    532 <printf+0x52>
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 5c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5cb:	8b 10                	mov    (%eax),%edx
        ap++;
 5cd:	83 c0 04             	add    $0x4,%eax
 5d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 5d3:	85 d2                	test   %edx,%edx
 5d5:	0f 84 8d 00 00 00    	je     668 <printf+0x188>
        while(*s != 0){
 5db:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 5de:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5e0:	84 c0                	test   %al,%al
 5e2:	0f 84 4a ff ff ff    	je     532 <printf+0x52>
 5e8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5eb:	89 d3                	mov    %edx,%ebx
 5ed:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5f0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5f3:	83 c3 01             	add    $0x1,%ebx
 5f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5f9:	6a 01                	push   $0x1
 5fb:	57                   	push   %edi
 5fc:	56                   	push   %esi
 5fd:	e8 21 fd ff ff       	call   323 <write>
        while(*s != 0){
 602:	0f b6 03             	movzbl (%ebx),%eax
 605:	83 c4 10             	add    $0x10,%esp
 608:	84 c0                	test   %al,%al
 60a:	75 e4                	jne    5f0 <printf+0x110>
      state = 0;
 60c:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 60f:	31 c9                	xor    %ecx,%ecx
 611:	e9 1c ff ff ff       	jmp    532 <printf+0x52>
 616:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 620:	83 ec 0c             	sub    $0xc,%esp
 623:	b9 0a 00 00 00       	mov    $0xa,%ecx
 628:	6a 01                	push   $0x1
 62a:	e9 7b ff ff ff       	jmp    5aa <printf+0xca>
 62f:	90                   	nop
        putc(fd, *ap);
 630:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 633:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 636:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 638:	6a 01                	push   $0x1
 63a:	57                   	push   %edi
 63b:	56                   	push   %esi
        putc(fd, *ap);
 63c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 63f:	e8 df fc ff ff       	call   323 <write>
        ap++;
 644:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 648:	83 c4 10             	add    $0x10,%esp
      state = 0;
 64b:	31 c9                	xor    %ecx,%ecx
 64d:	e9 e0 fe ff ff       	jmp    532 <printf+0x52>
 652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 658:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 65b:	83 ec 04             	sub    $0x4,%esp
 65e:	e9 2a ff ff ff       	jmp    58d <printf+0xad>
 663:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 667:	90                   	nop
          s = "(null)";
 668:	ba 69 08 00 00       	mov    $0x869,%edx
        while(*s != 0){
 66d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 670:	b8 28 00 00 00       	mov    $0x28,%eax
 675:	89 d3                	mov    %edx,%ebx
 677:	e9 74 ff ff ff       	jmp    5f0 <printf+0x110>
 67c:	66 90                	xchg   %ax,%ax
 67e:	66 90                	xchg   %ax,%ax

00000680 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 680:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	a1 70 0b 00 00       	mov    0xb70,%eax
{
 686:	89 e5                	mov    %esp,%ebp
 688:	57                   	push   %edi
 689:	56                   	push   %esi
 68a:	53                   	push   %ebx
 68b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 68e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 698:	89 c2                	mov    %eax,%edx
 69a:	8b 00                	mov    (%eax),%eax
 69c:	39 ca                	cmp    %ecx,%edx
 69e:	73 30                	jae    6d0 <free+0x50>
 6a0:	39 c1                	cmp    %eax,%ecx
 6a2:	72 04                	jb     6a8 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a4:	39 c2                	cmp    %eax,%edx
 6a6:	72 f0                	jb     698 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ae:	39 f8                	cmp    %edi,%eax
 6b0:	74 30                	je     6e2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 6b2:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b5:	8b 42 04             	mov    0x4(%edx),%eax
 6b8:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6bb:	39 f1                	cmp    %esi,%ecx
 6bd:	74 3a                	je     6f9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 6bf:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6c1:	5b                   	pop    %ebx
  freep = p;
 6c2:	89 15 70 0b 00 00    	mov    %edx,0xb70
}
 6c8:	5e                   	pop    %esi
 6c9:	5f                   	pop    %edi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	39 c2                	cmp    %eax,%edx
 6d2:	72 c4                	jb     698 <free+0x18>
 6d4:	39 c1                	cmp    %eax,%ecx
 6d6:	73 c0                	jae    698 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 6d8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6db:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6de:	39 f8                	cmp    %edi,%eax
 6e0:	75 d0                	jne    6b2 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6e2:	03 70 04             	add    0x4(%eax),%esi
 6e5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	8b 02                	mov    (%edx),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6ef:	8b 42 04             	mov    0x4(%edx),%eax
 6f2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6f5:	39 f1                	cmp    %esi,%ecx
 6f7:	75 c6                	jne    6bf <free+0x3f>
    p->s.size += bp->s.size;
 6f9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6fc:	89 15 70 0b 00 00    	mov    %edx,0xb70
    p->s.size += bp->s.size;
 702:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 705:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 708:	89 0a                	mov    %ecx,(%edx)
}
 70a:	5b                   	pop    %ebx
 70b:	5e                   	pop    %esi
 70c:	5f                   	pop    %edi
 70d:	5d                   	pop    %ebp
 70e:	c3                   	ret    
 70f:	90                   	nop

00000710 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 719:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 71c:	8b 3d 70 0b 00 00    	mov    0xb70,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 722:	8d 70 07             	lea    0x7(%eax),%esi
 725:	c1 ee 03             	shr    $0x3,%esi
 728:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 72b:	85 ff                	test   %edi,%edi
 72d:	0f 84 9d 00 00 00    	je     7d0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 733:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 735:	8b 4a 04             	mov    0x4(%edx),%ecx
 738:	39 f1                	cmp    %esi,%ecx
 73a:	73 6a                	jae    7a6 <malloc+0x96>
 73c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 741:	39 de                	cmp    %ebx,%esi
 743:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 746:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 74d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 750:	eb 17                	jmp    769 <malloc+0x59>
 752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 758:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 75a:	8b 48 04             	mov    0x4(%eax),%ecx
 75d:	39 f1                	cmp    %esi,%ecx
 75f:	73 4f                	jae    7b0 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 761:	8b 3d 70 0b 00 00    	mov    0xb70,%edi
 767:	89 c2                	mov    %eax,%edx
 769:	39 d7                	cmp    %edx,%edi
 76b:	75 eb                	jne    758 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 76d:	83 ec 0c             	sub    $0xc,%esp
 770:	ff 75 e4             	push   -0x1c(%ebp)
 773:	e8 13 fc ff ff       	call   38b <sbrk>
  if(p == (char*)-1)
 778:	83 c4 10             	add    $0x10,%esp
 77b:	83 f8 ff             	cmp    $0xffffffff,%eax
 77e:	74 1c                	je     79c <malloc+0x8c>
  hp->s.size = nu;
 780:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 783:	83 ec 0c             	sub    $0xc,%esp
 786:	83 c0 08             	add    $0x8,%eax
 789:	50                   	push   %eax
 78a:	e8 f1 fe ff ff       	call   680 <free>
  return freep;
 78f:	8b 15 70 0b 00 00    	mov    0xb70,%edx
      if((p = morecore(nunits)) == 0)
 795:	83 c4 10             	add    $0x10,%esp
 798:	85 d2                	test   %edx,%edx
 79a:	75 bc                	jne    758 <malloc+0x48>
        return 0;
  }
}
 79c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 79f:	31 c0                	xor    %eax,%eax
}
 7a1:	5b                   	pop    %ebx
 7a2:	5e                   	pop    %esi
 7a3:	5f                   	pop    %edi
 7a4:	5d                   	pop    %ebp
 7a5:	c3                   	ret    
    if(p->s.size >= nunits){
 7a6:	89 d0                	mov    %edx,%eax
 7a8:	89 fa                	mov    %edi,%edx
 7aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 7b0:	39 ce                	cmp    %ecx,%esi
 7b2:	74 4c                	je     800 <malloc+0xf0>
        p->s.size -= nunits;
 7b4:	29 f1                	sub    %esi,%ecx
 7b6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7b9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7bc:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 7bf:	89 15 70 0b 00 00    	mov    %edx,0xb70
}
 7c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 7c8:	83 c0 08             	add    $0x8,%eax
}
 7cb:	5b                   	pop    %ebx
 7cc:	5e                   	pop    %esi
 7cd:	5f                   	pop    %edi
 7ce:	5d                   	pop    %ebp
 7cf:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 7d0:	c7 05 70 0b 00 00 74 	movl   $0xb74,0xb70
 7d7:	0b 00 00 
    base.s.size = 0;
 7da:	bf 74 0b 00 00       	mov    $0xb74,%edi
    base.s.ptr = freep = prevp = &base;
 7df:	c7 05 74 0b 00 00 74 	movl   $0xb74,0xb74
 7e6:	0b 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7eb:	c7 05 78 0b 00 00 00 	movl   $0x0,0xb78
 7f2:	00 00 00 
    if(p->s.size >= nunits){
 7f5:	e9 42 ff ff ff       	jmp    73c <malloc+0x2c>
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 800:	8b 08                	mov    (%eax),%ecx
 802:	89 0a                	mov    %ecx,(%edx)
 804:	eb b9                	jmp    7bf <malloc+0xaf>
