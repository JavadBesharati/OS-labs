
_test_sem:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "types.h"
#include "stat.h"

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 08             	sub    $0x8,%esp
    sem_init(0, 1, 0); // mutex
  11:	6a 00                	push   $0x0
  13:	6a 01                	push   $0x1
  15:	6a 00                	push   $0x0
  17:	e8 7f 03 00 00       	call   39b <sem_init>
    sem_init(1, 5, 0); // empty
  1c:	83 c4 0c             	add    $0xc,%esp
  1f:	6a 00                	push   $0x0
  21:	6a 05                	push   $0x5
  23:	6a 01                	push   $0x1
  25:	e8 71 03 00 00       	call   39b <sem_init>
    sem_init(2, 5, 5); // full
  2a:	83 c4 0c             	add    $0xc,%esp
  2d:	6a 05                	push   $0x5
  2f:	6a 05                	push   $0x5
  31:	6a 02                	push   $0x2
  33:	e8 63 03 00 00       	call   39b <sem_init>
    int pid = fork();
  38:	e8 7e 02 00 00       	call   2bb <fork>
    if (pid == 0)
  3d:	83 c4 10             	add    $0x10,%esp
  40:	85 c0                	test   %eax,%eax
  42:	75 17                	jne    5b <main+0x5b>
    {
        producer(0);
  44:	83 ec 0c             	sub    $0xc,%esp
  47:	6a 00                	push   $0x0
  49:	e8 65 03 00 00       	call   3b3 <producer>
  4e:	83 c4 10             	add    $0x10,%esp
    else
    {
        consumer(0);
        wait();
    }
    wait();
  51:	e8 75 02 00 00       	call   2cb <wait>
    exit();
  56:	e8 68 02 00 00       	call   2c3 <exit>
        consumer(0);
  5b:	83 ec 0c             	sub    $0xc,%esp
  5e:	6a 00                	push   $0x0
  60:	e8 56 03 00 00       	call   3bb <consumer>
        wait();
  65:	e8 61 02 00 00       	call   2cb <wait>
  6a:	83 c4 10             	add    $0x10,%esp
  6d:	eb e2                	jmp    51 <main+0x51>
  6f:	90                   	nop

00000070 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  70:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	31 c0                	xor    %eax,%eax
{
  73:	89 e5                	mov    %esp,%ebp
  75:	53                   	push   %ebx
  76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
  80:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
  84:	88 14 01             	mov    %dl,(%ecx,%eax,1)
  87:	83 c0 01             	add    $0x1,%eax
  8a:	84 d2                	test   %dl,%dl
  8c:	75 f2                	jne    80 <strcpy+0x10>
    ;
  return os;
}
  8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  91:	89 c8                	mov    %ecx,%eax
  93:	c9                   	leave  
  94:	c3                   	ret    
  95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000a0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	53                   	push   %ebx
  a4:	8b 55 08             	mov    0x8(%ebp),%edx
  a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  aa:	0f b6 02             	movzbl (%edx),%eax
  ad:	84 c0                	test   %al,%al
  af:	75 17                	jne    c8 <strcmp+0x28>
  b1:	eb 3a                	jmp    ed <strcmp+0x4d>
  b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  b7:	90                   	nop
  b8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
  bc:	83 c2 01             	add    $0x1,%edx
  bf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  c2:	84 c0                	test   %al,%al
  c4:	74 1a                	je     e0 <strcmp+0x40>
    p++, q++;
  c6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  c8:	0f b6 19             	movzbl (%ecx),%ebx
  cb:	38 c3                	cmp    %al,%bl
  cd:	74 e9                	je     b8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
  cf:	29 d8                	sub    %ebx,%eax
}
  d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d4:	c9                   	leave  
  d5:	c3                   	ret    
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
  e0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
  e4:	31 c0                	xor    %eax,%eax
  e6:	29 d8                	sub    %ebx,%eax
}
  e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  eb:	c9                   	leave  
  ec:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
  ed:	0f b6 19             	movzbl (%ecx),%ebx
  f0:	31 c0                	xor    %eax,%eax
  f2:	eb db                	jmp    cf <strcmp+0x2f>
  f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ff:	90                   	nop

00000100 <strlen>:

uint
strlen(const char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 106:	80 3a 00             	cmpb   $0x0,(%edx)
 109:	74 15                	je     120 <strlen+0x20>
 10b:	31 c0                	xor    %eax,%eax
 10d:	8d 76 00             	lea    0x0(%esi),%esi
 110:	83 c0 01             	add    $0x1,%eax
 113:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 117:	89 c1                	mov    %eax,%ecx
 119:	75 f5                	jne    110 <strlen+0x10>
    ;
  return n;
}
 11b:	89 c8                	mov    %ecx,%eax
 11d:	5d                   	pop    %ebp
 11e:	c3                   	ret    
 11f:	90                   	nop
  for(n = 0; s[n]; n++)
 120:	31 c9                	xor    %ecx,%ecx
}
 122:	5d                   	pop    %ebp
 123:	89 c8                	mov    %ecx,%eax
 125:	c3                   	ret    
 126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12d:	8d 76 00             	lea    0x0(%esi),%esi

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 137:	8b 4d 10             	mov    0x10(%ebp),%ecx
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 d7                	mov    %edx,%edi
 13f:	fc                   	cld    
 140:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 142:	8b 7d fc             	mov    -0x4(%ebp),%edi
 145:	89 d0                	mov    %edx,%eax
 147:	c9                   	leave  
 148:	c3                   	ret    
 149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 15a:	0f b6 10             	movzbl (%eax),%edx
 15d:	84 d2                	test   %dl,%dl
 15f:	75 12                	jne    173 <strchr+0x23>
 161:	eb 1d                	jmp    180 <strchr+0x30>
 163:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 167:	90                   	nop
 168:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 16c:	83 c0 01             	add    $0x1,%eax
 16f:	84 d2                	test   %dl,%dl
 171:	74 0d                	je     180 <strchr+0x30>
    if(*s == c)
 173:	38 d1                	cmp    %dl,%cl
 175:	75 f1                	jne    168 <strchr+0x18>
      return (char*)s;
  return 0;
}
 177:	5d                   	pop    %ebp
 178:	c3                   	ret    
 179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 180:	31 c0                	xor    %eax,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 18b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 18f:	90                   	nop

00000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	57                   	push   %edi
 194:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 195:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
 198:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 199:	31 db                	xor    %ebx,%ebx
{
 19b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 19e:	eb 27                	jmp    1c7 <gets+0x37>
    cc = read(0, &c, 1);
 1a0:	83 ec 04             	sub    $0x4,%esp
 1a3:	6a 01                	push   $0x1
 1a5:	57                   	push   %edi
 1a6:	6a 00                	push   $0x0
 1a8:	e8 2e 01 00 00       	call   2db <read>
    if(cc < 1)
 1ad:	83 c4 10             	add    $0x10,%esp
 1b0:	85 c0                	test   %eax,%eax
 1b2:	7e 1d                	jle    1d1 <gets+0x41>
      break;
    buf[i++] = c;
 1b4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1b8:	8b 55 08             	mov    0x8(%ebp),%edx
 1bb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1bf:	3c 0a                	cmp    $0xa,%al
 1c1:	74 1d                	je     1e0 <gets+0x50>
 1c3:	3c 0d                	cmp    $0xd,%al
 1c5:	74 19                	je     1e0 <gets+0x50>
  for(i=0; i+1 < max; ){
 1c7:	89 de                	mov    %ebx,%esi
 1c9:	83 c3 01             	add    $0x1,%ebx
 1cc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1cf:	7c cf                	jl     1a0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1db:	5b                   	pop    %ebx
 1dc:	5e                   	pop    %esi
 1dd:	5f                   	pop    %edi
 1de:	5d                   	pop    %ebp
 1df:	c3                   	ret    
  buf[i] = '\0';
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	89 de                	mov    %ebx,%esi
 1e5:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
 1e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ec:	5b                   	pop    %ebx
 1ed:	5e                   	pop    %esi
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    
 1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <stat>:

int
stat(const char *n, struct stat *st)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	56                   	push   %esi
 204:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 205:	83 ec 08             	sub    $0x8,%esp
 208:	6a 00                	push   $0x0
 20a:	ff 75 08             	push   0x8(%ebp)
 20d:	e8 f1 00 00 00       	call   303 <open>
  if(fd < 0)
 212:	83 c4 10             	add    $0x10,%esp
 215:	85 c0                	test   %eax,%eax
 217:	78 27                	js     240 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 219:	83 ec 08             	sub    $0x8,%esp
 21c:	ff 75 0c             	push   0xc(%ebp)
 21f:	89 c3                	mov    %eax,%ebx
 221:	50                   	push   %eax
 222:	e8 f4 00 00 00       	call   31b <fstat>
  close(fd);
 227:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 22a:	89 c6                	mov    %eax,%esi
  close(fd);
 22c:	e8 ba 00 00 00       	call   2eb <close>
  return r;
 231:	83 c4 10             	add    $0x10,%esp
}
 234:	8d 65 f8             	lea    -0x8(%ebp),%esp
 237:	89 f0                	mov    %esi,%eax
 239:	5b                   	pop    %ebx
 23a:	5e                   	pop    %esi
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 240:	be ff ff ff ff       	mov    $0xffffffff,%esi
 245:	eb ed                	jmp    234 <stat+0x34>
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	53                   	push   %ebx
 254:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 257:	0f be 02             	movsbl (%edx),%eax
 25a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 25d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 260:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 265:	77 1e                	ja     285 <atoi+0x35>
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 270:	83 c2 01             	add    $0x1,%edx
 273:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 276:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 27a:	0f be 02             	movsbl (%edx),%eax
 27d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 280:	80 fb 09             	cmp    $0x9,%bl
 283:	76 eb                	jbe    270 <atoi+0x20>
  return n;
}
 285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 288:	89 c8                	mov    %ecx,%eax
 28a:	c9                   	leave  
 28b:	c3                   	ret    
 28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	57                   	push   %edi
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	8b 55 08             	mov    0x8(%ebp),%edx
 29a:	56                   	push   %esi
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29e:	85 c0                	test   %eax,%eax
 2a0:	7e 13                	jle    2b5 <memmove+0x25>
 2a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 2a4:	89 d7                	mov    %edx,%edi
 2a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 2b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 2b1:	39 f8                	cmp    %edi,%eax
 2b3:	75 fb                	jne    2b0 <memmove+0x20>
  return vdst;
}
 2b5:	5e                   	pop    %esi
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    

000002bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bb:	b8 01 00 00 00       	mov    $0x1,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <exit>:
SYSCALL(exit)
 2c3:	b8 02 00 00 00       	mov    $0x2,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <wait>:
SYSCALL(wait)
 2cb:	b8 03 00 00 00       	mov    $0x3,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <pipe>:
SYSCALL(pipe)
 2d3:	b8 04 00 00 00       	mov    $0x4,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <read>:
SYSCALL(read)
 2db:	b8 05 00 00 00       	mov    $0x5,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <write>:
SYSCALL(write)
 2e3:	b8 10 00 00 00       	mov    $0x10,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <close>:
SYSCALL(close)
 2eb:	b8 15 00 00 00       	mov    $0x15,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <kill>:
SYSCALL(kill)
 2f3:	b8 06 00 00 00       	mov    $0x6,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <exec>:
SYSCALL(exec)
 2fb:	b8 07 00 00 00       	mov    $0x7,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <open>:
SYSCALL(open)
 303:	b8 0f 00 00 00       	mov    $0xf,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <mknod>:
SYSCALL(mknod)
 30b:	b8 11 00 00 00       	mov    $0x11,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <unlink>:
SYSCALL(unlink)
 313:	b8 12 00 00 00       	mov    $0x12,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <fstat>:
SYSCALL(fstat)
 31b:	b8 08 00 00 00       	mov    $0x8,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <link>:
SYSCALL(link)
 323:	b8 13 00 00 00       	mov    $0x13,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <mkdir>:
SYSCALL(mkdir)
 32b:	b8 14 00 00 00       	mov    $0x14,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <chdir>:
SYSCALL(chdir)
 333:	b8 09 00 00 00       	mov    $0x9,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <dup>:
SYSCALL(dup)
 33b:	b8 0a 00 00 00       	mov    $0xa,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <getpid>:
SYSCALL(getpid)
 343:	b8 0b 00 00 00       	mov    $0xb,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <sbrk>:
SYSCALL(sbrk)
 34b:	b8 0c 00 00 00       	mov    $0xc,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sleep>:
SYSCALL(sleep)
 353:	b8 0d 00 00 00       	mov    $0xd,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <uptime>:
SYSCALL(uptime)
 35b:	b8 0e 00 00 00       	mov    $0xe,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <find_fibonacci_number>:
SYSCALL(find_fibonacci_number)
 363:	b8 16 00 00 00       	mov    $0x16,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <find_most_callee>:
SYSCALL(find_most_callee)
 36b:	b8 17 00 00 00       	mov    $0x17,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <get_children_count>:
SYSCALL(get_children_count)
 373:	b8 18 00 00 00       	mov    $0x18,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <kill_first_child_process>:
SYSCALL(kill_first_child_process)
 37b:	b8 19 00 00 00       	mov    $0x19,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <set_proc_queue>:
SYSCALL(set_proc_queue)
 383:	b8 1a 00 00 00       	mov    $0x1a,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <set_lottery_params>:
SYSCALL(set_lottery_params)
 38b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <print_all_procs>:
SYSCALL(print_all_procs)
 393:	b8 1c 00 00 00       	mov    $0x1c,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <sem_init>:
SYSCALL(sem_init)
 39b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <sem_acquire>:
SYSCALL(sem_acquire)
 3a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <sem_release>:
SYSCALL(sem_release)
 3ab:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <producer>:
SYSCALL(producer)
 3b3:	b8 20 00 00 00       	mov    $0x20,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <consumer>:
SYSCALL(consumer)
 3bb:	b8 21 00 00 00       	mov    $0x21,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <cv_wait>:
SYSCALL(cv_wait)
 3c3:	b8 22 00 00 00       	mov    $0x22,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <cv_signal>:
SYSCALL(cv_signal)
 3cb:	b8 23 00 00 00       	mov    $0x23,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <reader>:
SYSCALL(reader)
 3d3:	b8 24 00 00 00       	mov    $0x24,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <writer>:
 3db:	b8 25 00 00 00       	mov    $0x25,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    
 3e3:	66 90                	xchg   %ax,%ax
 3e5:	66 90                	xchg   %ax,%ax
 3e7:	66 90                	xchg   %ax,%ax
 3e9:	66 90                	xchg   %ax,%ax
 3eb:	66 90                	xchg   %ax,%ax
 3ed:	66 90                	xchg   %ax,%ax
 3ef:	90                   	nop

000003f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	53                   	push   %ebx
 3f6:	83 ec 3c             	sub    $0x3c,%esp
 3f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 3fc:	89 d1                	mov    %edx,%ecx
{
 3fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 401:	85 d2                	test   %edx,%edx
 403:	0f 89 7f 00 00 00    	jns    488 <printint+0x98>
 409:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 40d:	74 79                	je     488 <printint+0x98>
    neg = 1;
 40f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 416:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 418:	31 db                	xor    %ebx,%ebx
 41a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 420:	89 c8                	mov    %ecx,%eax
 422:	31 d2                	xor    %edx,%edx
 424:	89 cf                	mov    %ecx,%edi
 426:	f7 75 c4             	divl   -0x3c(%ebp)
 429:	0f b6 92 28 08 00 00 	movzbl 0x828(%edx),%edx
 430:	89 45 c0             	mov    %eax,-0x40(%ebp)
 433:	89 d8                	mov    %ebx,%eax
 435:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 438:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 43b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 43e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 441:	76 dd                	jbe    420 <printint+0x30>
  if(neg)
 443:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 446:	85 c9                	test   %ecx,%ecx
 448:	74 0c                	je     456 <printint+0x66>
    buf[i++] = '-';
 44a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 44f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 451:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 456:	8b 7d b8             	mov    -0x48(%ebp),%edi
 459:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 45d:	eb 07                	jmp    466 <printint+0x76>
 45f:	90                   	nop
    putc(fd, buf[i]);
 460:	0f b6 13             	movzbl (%ebx),%edx
 463:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 466:	83 ec 04             	sub    $0x4,%esp
 469:	88 55 d7             	mov    %dl,-0x29(%ebp)
 46c:	6a 01                	push   $0x1
 46e:	56                   	push   %esi
 46f:	57                   	push   %edi
 470:	e8 6e fe ff ff       	call   2e3 <write>
  while(--i >= 0)
 475:	83 c4 10             	add    $0x10,%esp
 478:	39 de                	cmp    %ebx,%esi
 47a:	75 e4                	jne    460 <printint+0x70>
}
 47c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 47f:	5b                   	pop    %ebx
 480:	5e                   	pop    %esi
 481:	5f                   	pop    %edi
 482:	5d                   	pop    %ebp
 483:	c3                   	ret    
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 488:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 48f:	eb 87                	jmp    418 <printint+0x28>
 491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 49f:	90                   	nop

000004a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
 4a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
 4ac:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
 4af:	0f b6 13             	movzbl (%ebx),%edx
 4b2:	84 d2                	test   %dl,%dl
 4b4:	74 6a                	je     520 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
 4b6:	8d 45 10             	lea    0x10(%ebp),%eax
 4b9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
 4bc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 4bf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
 4c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4c4:	eb 36                	jmp    4fc <printf+0x5c>
 4c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
 4d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 4d3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
 4d8:	83 f8 25             	cmp    $0x25,%eax
 4db:	74 15                	je     4f2 <printf+0x52>
  write(fd, &c, 1);
 4dd:	83 ec 04             	sub    $0x4,%esp
 4e0:	88 55 e7             	mov    %dl,-0x19(%ebp)
 4e3:	6a 01                	push   $0x1
 4e5:	57                   	push   %edi
 4e6:	56                   	push   %esi
 4e7:	e8 f7 fd ff ff       	call   2e3 <write>
 4ec:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
 4ef:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 4f2:	0f b6 13             	movzbl (%ebx),%edx
 4f5:	83 c3 01             	add    $0x1,%ebx
 4f8:	84 d2                	test   %dl,%dl
 4fa:	74 24                	je     520 <printf+0x80>
    c = fmt[i] & 0xff;
 4fc:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
 4ff:	85 c9                	test   %ecx,%ecx
 501:	74 cd                	je     4d0 <printf+0x30>
      }
    } else if(state == '%'){
 503:	83 f9 25             	cmp    $0x25,%ecx
 506:	75 ea                	jne    4f2 <printf+0x52>
      if(c == 'd'){
 508:	83 f8 25             	cmp    $0x25,%eax
 50b:	0f 84 07 01 00 00    	je     618 <printf+0x178>
 511:	83 e8 63             	sub    $0x63,%eax
 514:	83 f8 15             	cmp    $0x15,%eax
 517:	77 17                	ja     530 <printf+0x90>
 519:	ff 24 85 d0 07 00 00 	jmp    *0x7d0(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 520:	8d 65 f4             	lea    -0xc(%ebp),%esp
 523:	5b                   	pop    %ebx
 524:	5e                   	pop    %esi
 525:	5f                   	pop    %edi
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    
 528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 52f:	90                   	nop
  write(fd, &c, 1);
 530:	83 ec 04             	sub    $0x4,%esp
 533:	88 55 d4             	mov    %dl,-0x2c(%ebp)
 536:	6a 01                	push   $0x1
 538:	57                   	push   %edi
 539:	56                   	push   %esi
 53a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 53e:	e8 a0 fd ff ff       	call   2e3 <write>
        putc(fd, c);
 543:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
 547:	83 c4 0c             	add    $0xc,%esp
 54a:	88 55 e7             	mov    %dl,-0x19(%ebp)
 54d:	6a 01                	push   $0x1
 54f:	57                   	push   %edi
 550:	56                   	push   %esi
 551:	e8 8d fd ff ff       	call   2e3 <write>
        putc(fd, c);
 556:	83 c4 10             	add    $0x10,%esp
      state = 0;
 559:	31 c9                	xor    %ecx,%ecx
 55b:	eb 95                	jmp    4f2 <printf+0x52>
 55d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 560:	83 ec 0c             	sub    $0xc,%esp
 563:	b9 10 00 00 00       	mov    $0x10,%ecx
 568:	6a 00                	push   $0x0
 56a:	8b 45 d0             	mov    -0x30(%ebp),%eax
 56d:	8b 10                	mov    (%eax),%edx
 56f:	89 f0                	mov    %esi,%eax
 571:	e8 7a fe ff ff       	call   3f0 <printint>
        ap++;
 576:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 57a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 57d:	31 c9                	xor    %ecx,%ecx
 57f:	e9 6e ff ff ff       	jmp    4f2 <printf+0x52>
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 588:	8b 45 d0             	mov    -0x30(%ebp),%eax
 58b:	8b 10                	mov    (%eax),%edx
        ap++;
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 593:	85 d2                	test   %edx,%edx
 595:	0f 84 8d 00 00 00    	je     628 <printf+0x188>
        while(*s != 0){
 59b:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
 59e:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
 5a0:	84 c0                	test   %al,%al
 5a2:	0f 84 4a ff ff ff    	je     4f2 <printf+0x52>
 5a8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 5ab:	89 d3                	mov    %edx,%ebx
 5ad:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 5b3:	83 c3 01             	add    $0x1,%ebx
 5b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5b9:	6a 01                	push   $0x1
 5bb:	57                   	push   %edi
 5bc:	56                   	push   %esi
 5bd:	e8 21 fd ff ff       	call   2e3 <write>
        while(*s != 0){
 5c2:	0f b6 03             	movzbl (%ebx),%eax
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	84 c0                	test   %al,%al
 5ca:	75 e4                	jne    5b0 <printf+0x110>
      state = 0;
 5cc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
 5cf:	31 c9                	xor    %ecx,%ecx
 5d1:	e9 1c ff ff ff       	jmp    4f2 <printf+0x52>
 5d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5dd:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5e0:	83 ec 0c             	sub    $0xc,%esp
 5e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5e8:	6a 01                	push   $0x1
 5ea:	e9 7b ff ff ff       	jmp    56a <printf+0xca>
 5ef:	90                   	nop
        putc(fd, *ap);
 5f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
 5f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 5f6:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 5f8:	6a 01                	push   $0x1
 5fa:	57                   	push   %edi
 5fb:	56                   	push   %esi
        putc(fd, *ap);
 5fc:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 5ff:	e8 df fc ff ff       	call   2e3 <write>
        ap++;
 604:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
 608:	83 c4 10             	add    $0x10,%esp
      state = 0;
 60b:	31 c9                	xor    %ecx,%ecx
 60d:	e9 e0 fe ff ff       	jmp    4f2 <printf+0x52>
 612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
 618:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 61b:	83 ec 04             	sub    $0x4,%esp
 61e:	e9 2a ff ff ff       	jmp    54d <printf+0xad>
 623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 627:	90                   	nop
          s = "(null)";
 628:	ba c8 07 00 00       	mov    $0x7c8,%edx
        while(*s != 0){
 62d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 630:	b8 28 00 00 00       	mov    $0x28,%eax
 635:	89 d3                	mov    %edx,%ebx
 637:	e9 74 ff ff ff       	jmp    5b0 <printf+0x110>
 63c:	66 90                	xchg   %ax,%ax
 63e:	66 90                	xchg   %ax,%ax

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 d0 0a 00 00       	mov    0xad0,%eax
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 64e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 658:	89 c2                	mov    %eax,%edx
 65a:	8b 00                	mov    (%eax),%eax
 65c:	39 ca                	cmp    %ecx,%edx
 65e:	73 30                	jae    690 <free+0x50>
 660:	39 c1                	cmp    %eax,%ecx
 662:	72 04                	jb     668 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	39 c2                	cmp    %eax,%edx
 666:	72 f0                	jb     658 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 668:	8b 73 fc             	mov    -0x4(%ebx),%esi
 66b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 66e:	39 f8                	cmp    %edi,%eax
 670:	74 30                	je     6a2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 672:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 675:	8b 42 04             	mov    0x4(%edx),%eax
 678:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 67b:	39 f1                	cmp    %esi,%ecx
 67d:	74 3a                	je     6b9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 67f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 681:	5b                   	pop    %ebx
  freep = p;
 682:	89 15 d0 0a 00 00    	mov    %edx,0xad0
}
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 690:	39 c2                	cmp    %eax,%edx
 692:	72 c4                	jb     658 <free+0x18>
 694:	39 c1                	cmp    %eax,%ecx
 696:	73 c0                	jae    658 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
 698:	8b 73 fc             	mov    -0x4(%ebx),%esi
 69b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 69e:	39 f8                	cmp    %edi,%eax
 6a0:	75 d0                	jne    672 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
 6a2:	03 70 04             	add    0x4(%eax),%esi
 6a5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a8:	8b 02                	mov    (%edx),%eax
 6aa:	8b 00                	mov    (%eax),%eax
 6ac:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 6af:	8b 42 04             	mov    0x4(%edx),%eax
 6b2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 6b5:	39 f1                	cmp    %esi,%ecx
 6b7:	75 c6                	jne    67f <free+0x3f>
    p->s.size += bp->s.size;
 6b9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 6bc:	89 15 d0 0a 00 00    	mov    %edx,0xad0
    p->s.size += bp->s.size;
 6c2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 6c5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 6c8:	89 0a                	mov    %ecx,(%edx)
}
 6ca:	5b                   	pop    %ebx
 6cb:	5e                   	pop    %esi
 6cc:	5f                   	pop    %edi
 6cd:	5d                   	pop    %ebp
 6ce:	c3                   	ret    
 6cf:	90                   	nop

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 3d d0 0a 00 00    	mov    0xad0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	8d 70 07             	lea    0x7(%eax),%esi
 6e5:	c1 ee 03             	shr    $0x3,%esi
 6e8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 6eb:	85 ff                	test   %edi,%edi
 6ed:	0f 84 9d 00 00 00    	je     790 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f3:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
 6f5:	8b 4a 04             	mov    0x4(%edx),%ecx
 6f8:	39 f1                	cmp    %esi,%ecx
 6fa:	73 6a                	jae    766 <malloc+0x96>
 6fc:	bb 00 10 00 00       	mov    $0x1000,%ebx
 701:	39 de                	cmp    %ebx,%esi
 703:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 706:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 70d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 710:	eb 17                	jmp    729 <malloc+0x59>
 712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 718:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 71a:	8b 48 04             	mov    0x4(%eax),%ecx
 71d:	39 f1                	cmp    %esi,%ecx
 71f:	73 4f                	jae    770 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 721:	8b 3d d0 0a 00 00    	mov    0xad0,%edi
 727:	89 c2                	mov    %eax,%edx
 729:	39 d7                	cmp    %edx,%edi
 72b:	75 eb                	jne    718 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 72d:	83 ec 0c             	sub    $0xc,%esp
 730:	ff 75 e4             	push   -0x1c(%ebp)
 733:	e8 13 fc ff ff       	call   34b <sbrk>
  if(p == (char*)-1)
 738:	83 c4 10             	add    $0x10,%esp
 73b:	83 f8 ff             	cmp    $0xffffffff,%eax
 73e:	74 1c                	je     75c <malloc+0x8c>
  hp->s.size = nu;
 740:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 743:	83 ec 0c             	sub    $0xc,%esp
 746:	83 c0 08             	add    $0x8,%eax
 749:	50                   	push   %eax
 74a:	e8 f1 fe ff ff       	call   640 <free>
  return freep;
 74f:	8b 15 d0 0a 00 00    	mov    0xad0,%edx
      if((p = morecore(nunits)) == 0)
 755:	83 c4 10             	add    $0x10,%esp
 758:	85 d2                	test   %edx,%edx
 75a:	75 bc                	jne    718 <malloc+0x48>
        return 0;
  }
}
 75c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 75f:	31 c0                	xor    %eax,%eax
}
 761:	5b                   	pop    %ebx
 762:	5e                   	pop    %esi
 763:	5f                   	pop    %edi
 764:	5d                   	pop    %ebp
 765:	c3                   	ret    
    if(p->s.size >= nunits){
 766:	89 d0                	mov    %edx,%eax
 768:	89 fa                	mov    %edi,%edx
 76a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 770:	39 ce                	cmp    %ecx,%esi
 772:	74 4c                	je     7c0 <malloc+0xf0>
        p->s.size -= nunits;
 774:	29 f1                	sub    %esi,%ecx
 776:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 779:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 77c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 77f:	89 15 d0 0a 00 00    	mov    %edx,0xad0
}
 785:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 788:	83 c0 08             	add    $0x8,%eax
}
 78b:	5b                   	pop    %ebx
 78c:	5e                   	pop    %esi
 78d:	5f                   	pop    %edi
 78e:	5d                   	pop    %ebp
 78f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 790:	c7 05 d0 0a 00 00 d4 	movl   $0xad4,0xad0
 797:	0a 00 00 
    base.s.size = 0;
 79a:	bf d4 0a 00 00       	mov    $0xad4,%edi
    base.s.ptr = freep = prevp = &base;
 79f:	c7 05 d4 0a 00 00 d4 	movl   $0xad4,0xad4
 7a6:	0a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
 7ab:	c7 05 d8 0a 00 00 00 	movl   $0x0,0xad8
 7b2:	00 00 00 
    if(p->s.size >= nunits){
 7b5:	e9 42 ff ff ff       	jmp    6fc <malloc+0x2c>
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 08                	mov    (%eax),%ecx
 7c2:	89 0a                	mov    %ecx,(%edx)
 7c4:	eb b9                	jmp    77f <malloc+0xaf>
