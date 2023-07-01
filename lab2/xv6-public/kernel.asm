
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 65 11 80       	mov    $0x80116550,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 35 10 80       	mov    $0x80103500,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 7a 10 80       	push   $0x80107aa0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 b5 4b 00 00       	call   80104c10 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 7a 10 80       	push   $0x80107aa7
80100097:	50                   	push   %eax
80100098:	e8 43 4a 00 00       	call   80104ae0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 f7 4c 00 00       	call   80104de0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 19 4c 00 00       	call   80104d80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 49 00 00       	call   80104b20 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 25 00 00       	call   80102780 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ae 7a 10 80       	push   $0x80107aae
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 fd 49 00 00       	call   80104bc0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 a7 25 00 00       	jmp    80102780 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 bf 7a 10 80       	push   $0x80107abf
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 49 00 00       	call   80104bc0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 6c 49 00 00       	call   80104b80 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 c0 4b 00 00       	call   80104de0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 0f 4b 00 00       	jmp    80104d80 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 c6 7a 10 80       	push   $0x80107ac6
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 67 1a 00 00       	call   80101d00 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 3b 4b 00 00       	call   80104de0 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 0e 42 00 00       	call   801044e0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 29 3b 00 00       	call   80103e10 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 85 4a 00 00       	call   80104d80 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 1c 19 00 00       	call   80101c20 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 2f 4a 00 00       	call   80104d80 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 c6 18 00 00       	call   80101c20 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 29 00 00       	call   80102d90 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 cd 7a 10 80       	push   $0x80107acd
801003a7:	e8 44 03 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 3b 03 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 6f 85 10 80 	movl   $0x8010856f,(%esp)
801003bc:	e8 2f 03 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 63 48 00 00       	call   80104c30 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 e1 7a 10 80       	push   $0x80107ae1
801003dd:	e8 0e 03 00 00       	call   801006f0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100409:	56                   	push   %esi
8010040a:	89 fa                	mov    %edi,%edx
8010040c:	89 c6                	mov    %eax,%esi
8010040e:	b8 0e 00 00 00       	mov    $0xe,%eax
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	bb d5 03 00 00       	mov    $0x3d5,%ebx
8010041d:	89 da                	mov    %ebx,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042a:	c1 e1 08             	shl    $0x8,%ecx
8010042d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042e:	89 da                	mov    %ebx,%edx
80100430:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100431:	0f b6 c0             	movzbl %al,%eax
80100434:	09 c8                	or     %ecx,%eax
  if(c == '\n')
80100436:	83 fe 0a             	cmp    $0xa,%esi
80100439:	0f 84 09 01 00 00    	je     80100548 <cgaputc+0x148>
    for(int i = pos - 1; i < pos + back_counter; i++){
8010043f:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
  else if(c == BACKSPACE){
80100445:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010044b:	0f 84 a7 00 00 00    	je     801004f8 <cgaputc+0xf8>
    for(int i = pos - 1; i < pos + back_counter; i++){
80100451:	01 c1                	add    %eax,%ecx
      for(int i = pos + back_counter; i > pos; i--){ 
80100453:	39 c8                	cmp    %ecx,%eax
80100455:	7d 1f                	jge    80100476 <cgaputc+0x76>
80100457:	8d 8c 09 fe 7f 0b 80 	lea    -0x7ff48002(%ecx,%ecx,1),%ecx
8010045e:	8d 9c 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%ebx
80100465:	8d 76 00             	lea    0x0(%esi),%esi
        crt[i] = crt[i - 1];
80100468:	0f b7 11             	movzwl (%ecx),%edx
      for(int i = pos + back_counter; i > pos; i--){ 
8010046b:	83 e9 02             	sub    $0x2,%ecx
        crt[i] = crt[i - 1];
8010046e:	66 89 51 04          	mov    %dx,0x4(%ecx)
      for(int i = pos + back_counter; i > pos; i--){ 
80100472:	39 cb                	cmp    %ecx,%ebx
80100474:	75 f2                	jne    80100468 <cgaputc+0x68>
      crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100476:	89 f1                	mov    %esi,%ecx
80100478:	8d 58 01             	lea    0x1(%eax),%ebx
8010047b:	0f b6 f1             	movzbl %cl,%esi
8010047e:	66 81 ce 00 07       	or     $0x700,%si
80100483:	66 89 b4 00 00 80 0b 	mov    %si,-0x7ff48000(%eax,%eax,1)
8010048a:	80 
  if(pos < 0 || pos > 25*80)
8010048b:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100491:	0f 8f 14 01 00 00    	jg     801005ab <cgaputc+0x1ab>
  if((pos/80) >= 24){  // Scroll up.
80100497:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010049d:	0f 8f bd 00 00 00    	jg     80100560 <cgaputc+0x160>
  outb(CRTPORT+1, pos>>8);
801004a3:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
801004a6:	88 5d e3             	mov    %bl,-0x1d(%ebp)
801004a9:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
  outb(CRTPORT+1, pos>>8);
801004af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004b2:	bf d4 03 00 00       	mov    $0x3d4,%edi
801004b7:	b8 0e 00 00 00       	mov    $0xe,%eax
801004bc:	89 fa                	mov    %edi,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	be d5 03 00 00       	mov    $0x3d5,%esi
801004c4:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004c8:	89 f2                	mov    %esi,%edx
801004ca:	ee                   	out    %al,(%dx)
801004cb:	b8 0f 00 00 00       	mov    $0xf,%eax
801004d0:	89 fa                	mov    %edi,%edx
801004d2:	ee                   	out    %al,(%dx)
801004d3:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
801004d7:	89 f2                	mov    %esi,%edx
801004d9:	ee                   	out    %al,(%dx)
  crt[pos + back_counter] = ' ' | 0x0700;
801004da:	b8 20 07 00 00       	mov    $0x720,%eax
801004df:	01 cb                	add    %ecx,%ebx
801004e1:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004e8:	80 
}
801004e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004ec:	5b                   	pop    %ebx
801004ed:	5e                   	pop    %esi
801004ee:	5f                   	pop    %edi
801004ef:	5d                   	pop    %ebp
801004f0:	c3                   	ret    
801004f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int i = pos - 1; i < pos + back_counter; i++){
801004f8:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004fb:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
80100502:	89 de                	mov    %ebx,%esi
80100504:	85 c9                	test   %ecx,%ecx
80100506:	78 22                	js     8010052a <cgaputc+0x12a>
80100508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010050f:	90                   	nop
      crt[i] = crt[i + 1];
80100510:	0f b7 0a             	movzwl (%edx),%ecx
    for(int i = pos - 1; i < pos + back_counter; i++){
80100513:	83 c6 01             	add    $0x1,%esi
80100516:	83 c2 02             	add    $0x2,%edx
      crt[i] = crt[i + 1];
80100519:	66 89 4a fc          	mov    %cx,-0x4(%edx)
    for(int i = pos - 1; i < pos + back_counter; i++){
8010051d:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
80100523:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
80100526:	39 f7                	cmp    %esi,%edi
80100528:	7f e6                	jg     80100510 <cgaputc+0x110>
    if(pos > 0) --pos;
8010052a:	85 c0                	test   %eax,%eax
8010052c:	0f 85 59 ff ff ff    	jne    8010048b <cgaputc+0x8b>
80100532:	c6 45 e3 00          	movb   $0x0,-0x1d(%ebp)
80100536:	31 db                	xor    %ebx,%ebx
80100538:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
8010053c:	e9 71 ff ff ff       	jmp    801004b2 <cgaputc+0xb2>
80100541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
80100548:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010054d:	f7 e2                	mul    %edx
8010054f:	c1 ea 06             	shr    $0x6,%edx
80100552:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100555:	c1 e0 04             	shl    $0x4,%eax
80100558:	8d 58 50             	lea    0x50(%eax),%ebx
8010055b:	e9 2b ff ff ff       	jmp    8010048b <cgaputc+0x8b>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100560:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100563:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100566:	68 60 0e 00 00       	push   $0xe60
8010056b:	68 a0 80 0b 80       	push   $0x800b80a0
80100570:	68 00 80 0b 80       	push   $0x800b8000
80100575:	e8 c6 49 00 00       	call   80104f40 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010057a:	b8 80 07 00 00       	mov    $0x780,%eax
8010057f:	83 c4 0c             	add    $0xc,%esp
80100582:	29 d8                	sub    %ebx,%eax
80100584:	01 c0                	add    %eax,%eax
80100586:	50                   	push   %eax
80100587:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
8010058e:	6a 00                	push   $0x0
80100590:	50                   	push   %eax
80100591:	e8 0a 49 00 00       	call   80104ea0 <memset>
  outb(CRTPORT+1, pos);
80100596:	88 5d e3             	mov    %bl,-0x1d(%ebp)
80100599:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
8010059f:	83 c4 10             	add    $0x10,%esp
801005a2:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005a6:	e9 07 ff ff ff       	jmp    801004b2 <cgaputc+0xb2>
    panic("pos under/overflow");
801005ab:	83 ec 0c             	sub    $0xc,%esp
801005ae:	68 e5 7a 10 80       	push   $0x80107ae5
801005b3:	e8 c8 fd ff ff       	call   80100380 <panic>
801005b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005bf:	90                   	nop

801005c0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c0:	55                   	push   %ebp
801005c1:	89 e5                	mov    %esp,%ebp
801005c3:	57                   	push   %edi
801005c4:	56                   	push   %esi
801005c5:	53                   	push   %ebx
801005c6:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
801005c9:	ff 75 08             	push   0x8(%ebp)
{
801005cc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005cf:	e8 2c 17 00 00       	call   80101d00 <iunlock>
  acquire(&cons.lock);
801005d4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005db:	e8 00 48 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++)
801005e0:	83 c4 10             	add    $0x10,%esp
801005e3:	85 f6                	test   %esi,%esi
801005e5:	7e 37                	jle    8010061e <consolewrite+0x5e>
801005e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ea:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005ed:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005f3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005f6:	85 d2                	test   %edx,%edx
801005f8:	74 06                	je     80100600 <consolewrite+0x40>
  asm volatile("cli");
801005fa:	fa                   	cli    
    for(;;)
801005fb:	eb fe                	jmp    801005fb <consolewrite+0x3b>
801005fd:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100600:	83 ec 0c             	sub    $0xc,%esp
80100603:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < n; i++)
80100606:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100609:	50                   	push   %eax
8010060a:	e8 b1 5f 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
8010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100612:	e8 e9 fd ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
80100617:	83 c4 10             	add    $0x10,%esp
8010061a:	39 df                	cmp    %ebx,%edi
8010061c:	75 cf                	jne    801005ed <consolewrite+0x2d>
  release(&cons.lock);
8010061e:	83 ec 0c             	sub    $0xc,%esp
80100621:	68 20 ff 10 80       	push   $0x8010ff20
80100626:	e8 55 47 00 00       	call   80104d80 <release>
  ilock(ip);
8010062b:	58                   	pop    %eax
8010062c:	ff 75 08             	push   0x8(%ebp)
8010062f:	e8 ec 15 00 00       	call   80101c20 <ilock>

  return n;
}
80100634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100637:	89 f0                	mov    %esi,%eax
80100639:	5b                   	pop    %ebx
8010063a:	5e                   	pop    %esi
8010063b:	5f                   	pop    %edi
8010063c:	5d                   	pop    %ebp
8010063d:	c3                   	ret    
8010063e:	66 90                	xchg   %ax,%ax

80100640 <printint>:
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	83 ec 2c             	sub    $0x2c,%esp
80100649:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010064c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010064f:	85 c9                	test   %ecx,%ecx
80100651:	74 04                	je     80100657 <printint+0x17>
80100653:	85 c0                	test   %eax,%eax
80100655:	78 7e                	js     801006d5 <printint+0x95>
    x = xx;
80100657:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010065e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100660:	31 db                	xor    %ebx,%ebx
80100662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100668:	89 c8                	mov    %ecx,%eax
8010066a:	31 d2                	xor    %edx,%edx
8010066c:	89 de                	mov    %ebx,%esi
8010066e:	89 cf                	mov    %ecx,%edi
80100670:	f7 75 d4             	divl   -0x2c(%ebp)
80100673:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100676:	0f b6 92 10 7b 10 80 	movzbl -0x7fef84f0(%edx),%edx
  }while((x /= base) != 0);
8010067d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010067f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100683:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100686:	73 e0                	jae    80100668 <printint+0x28>
  if(sign)
80100688:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010068b:	85 c9                	test   %ecx,%ecx
8010068d:	74 0c                	je     8010069b <printint+0x5b>
    buf[i++] = '-';
8010068f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100694:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100696:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010069b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010069f:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801006a4:	85 c0                	test   %eax,%eax
801006a6:	74 08                	je     801006b0 <printint+0x70>
801006a8:	fa                   	cli    
    for(;;)
801006a9:	eb fe                	jmp    801006a9 <printint+0x69>
801006ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801006af:	90                   	nop
    consputc(buf[i]);
801006b0:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
801006b3:	83 ec 0c             	sub    $0xc,%esp
801006b6:	56                   	push   %esi
801006b7:	e8 04 5f 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
801006bc:	89 f0                	mov    %esi,%eax
801006be:	e8 3d fd ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
801006c3:	8d 45 d7             	lea    -0x29(%ebp),%eax
801006c6:	83 c4 10             	add    $0x10,%esp
801006c9:	39 d8                	cmp    %ebx,%eax
801006cb:	74 0e                	je     801006db <printint+0x9b>
    consputc(buf[i]);
801006cd:	0f b6 13             	movzbl (%ebx),%edx
801006d0:	83 eb 01             	sub    $0x1,%ebx
801006d3:	eb ca                	jmp    8010069f <printint+0x5f>
    x = -xx;
801006d5:	f7 d8                	neg    %eax
801006d7:	89 c1                	mov    %eax,%ecx
801006d9:	eb 85                	jmp    80100660 <printint+0x20>
}
801006db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006de:	5b                   	pop    %ebx
801006df:	5e                   	pop    %esi
801006e0:	5f                   	pop    %edi
801006e1:	5d                   	pop    %ebp
801006e2:	c3                   	ret    
801006e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801006f0 <cprintf>:
{
801006f0:	55                   	push   %ebp
801006f1:	89 e5                	mov    %esp,%ebp
801006f3:	57                   	push   %edi
801006f4:	56                   	push   %esi
801006f5:	53                   	push   %ebx
801006f6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006f9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100701:	85 c0                	test   %eax,%eax
80100703:	0f 85 37 01 00 00    	jne    80100840 <cprintf+0x150>
  if (fmt == 0)
80100709:	8b 75 08             	mov    0x8(%ebp),%esi
8010070c:	85 f6                	test   %esi,%esi
8010070e:	0f 84 3d 02 00 00    	je     80100951 <cprintf+0x261>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100714:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100717:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071a:	31 db                	xor    %ebx,%ebx
8010071c:	85 c0                	test   %eax,%eax
8010071e:	74 56                	je     80100776 <cprintf+0x86>
    if(c != '%'){
80100720:	83 f8 25             	cmp    $0x25,%eax
80100723:	0f 85 d7 00 00 00    	jne    80100800 <cprintf+0x110>
    c = fmt[++i] & 0xff;
80100729:	83 c3 01             	add    $0x1,%ebx
8010072c:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100730:	85 d2                	test   %edx,%edx
80100732:	74 42                	je     80100776 <cprintf+0x86>
    switch(c){
80100734:	83 fa 70             	cmp    $0x70,%edx
80100737:	0f 84 94 00 00 00    	je     801007d1 <cprintf+0xe1>
8010073d:	7f 51                	jg     80100790 <cprintf+0xa0>
8010073f:	83 fa 25             	cmp    $0x25,%edx
80100742:	0f 84 48 01 00 00    	je     80100890 <cprintf+0x1a0>
80100748:	83 fa 64             	cmp    $0x64,%edx
8010074b:	0f 85 04 01 00 00    	jne    80100855 <cprintf+0x165>
      printint(*argp++, 10, 1);
80100751:	8d 47 04             	lea    0x4(%edi),%eax
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100761:	8b 07                	mov    (%edi),%eax
80100763:	e8 d8 fe ff ff       	call   80100640 <printint>
80100768:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
8010076e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100772:	85 c0                	test   %eax,%eax
80100774:	75 aa                	jne    80100720 <cprintf+0x30>
  if(locking)
80100776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100779:	85 c0                	test   %eax,%eax
8010077b:	0f 85 b3 01 00 00    	jne    80100934 <cprintf+0x244>
}
80100781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100784:	5b                   	pop    %ebx
80100785:	5e                   	pop    %esi
80100786:	5f                   	pop    %edi
80100787:	5d                   	pop    %ebp
80100788:	c3                   	ret    
80100789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 fa 73             	cmp    $0x73,%edx
80100793:	75 33                	jne    801007c8 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100795:	8d 47 04             	lea    0x4(%edi),%eax
80100798:	8b 3f                	mov    (%edi),%edi
8010079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010079d:	85 ff                	test   %edi,%edi
8010079f:	0f 85 33 01 00 00    	jne    801008d8 <cprintf+0x1e8>
        s = "(null)";
801007a5:	bf f8 7a 10 80       	mov    $0x80107af8,%edi
      for(; *s; s++)
801007aa:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801007ad:	b8 28 00 00 00       	mov    $0x28,%eax
801007b2:	89 fb                	mov    %edi,%ebx
  if(panicked){
801007b4:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
801007ba:	85 d2                	test   %edx,%edx
801007bc:	0f 84 27 01 00 00    	je     801008e9 <cprintf+0x1f9>
801007c2:	fa                   	cli    
    for(;;)
801007c3:	eb fe                	jmp    801007c3 <cprintf+0xd3>
801007c5:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801007c8:	83 fa 78             	cmp    $0x78,%edx
801007cb:	0f 85 84 00 00 00    	jne    80100855 <cprintf+0x165>
      printint(*argp++, 16, 0);
801007d1:	8d 47 04             	lea    0x4(%edi),%eax
801007d4:	31 c9                	xor    %ecx,%ecx
801007d6:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007db:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
801007de:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007e1:	8b 07                	mov    (%edi),%eax
801007e3:	e8 58 fe ff ff       	call   80100640 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
801007ec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007ef:	85 c0                	test   %eax,%eax
801007f1:	0f 85 29 ff ff ff    	jne    80100720 <cprintf+0x30>
801007f7:	e9 7a ff ff ff       	jmp    80100776 <cprintf+0x86>
801007fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100800:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100806:	85 c9                	test   %ecx,%ecx
80100808:	74 06                	je     80100810 <cprintf+0x120>
8010080a:	fa                   	cli    
    for(;;)
8010080b:	eb fe                	jmp    8010080b <cprintf+0x11b>
8010080d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
80100810:	83 ec 0c             	sub    $0xc,%esp
80100813:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100816:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100819:	50                   	push   %eax
8010081a:	e8 a1 5d 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
8010081f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100822:	e8 d9 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100827:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
8010082b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010082e:	85 c0                	test   %eax,%eax
80100830:	0f 85 ea fe ff ff    	jne    80100720 <cprintf+0x30>
80100836:	e9 3b ff ff ff       	jmp    80100776 <cprintf+0x86>
8010083b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010083f:	90                   	nop
    acquire(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 20 ff 10 80       	push   $0x8010ff20
80100848:	e8 93 45 00 00       	call   80104de0 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 b4 fe ff ff       	jmp    80100709 <cprintf+0x19>
  if(panicked){
80100855:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
8010085b:	85 c9                	test   %ecx,%ecx
8010085d:	75 71                	jne    801008d0 <cprintf+0x1e0>
    uartputc(c);
8010085f:	83 ec 0c             	sub    $0xc,%esp
80100862:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100865:	6a 25                	push   $0x25
80100867:	e8 54 5d 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
8010086c:	b8 25 00 00 00       	mov    $0x25,%eax
80100871:	e8 8a fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100876:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	85 d2                	test   %edx,%edx
80100881:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100884:	0f 84 8e 00 00 00    	je     80100918 <cprintf+0x228>
8010088a:	fa                   	cli    
    for(;;)
8010088b:	eb fe                	jmp    8010088b <cprintf+0x19b>
8010088d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100890:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100895:	85 c0                	test   %eax,%eax
80100897:	74 07                	je     801008a0 <cprintf+0x1b0>
80100899:	fa                   	cli    
    for(;;)
8010089a:	eb fe                	jmp    8010089a <cprintf+0x1aa>
8010089c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
801008a0:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008a3:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801008a6:	6a 25                	push   $0x25
801008a8:	e8 13 5d 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
801008ad:	b8 25 00 00 00       	mov    $0x25,%eax
801008b2:	e8 49 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
801008bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008be:	85 c0                	test   %eax,%eax
801008c0:	0f 85 5a fe ff ff    	jne    80100720 <cprintf+0x30>
801008c6:	e9 ab fe ff ff       	jmp    80100776 <cprintf+0x86>
801008cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008cf:	90                   	nop
801008d0:	fa                   	cli    
    for(;;)
801008d1:	eb fe                	jmp    801008d1 <cprintf+0x1e1>
801008d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801008d7:	90                   	nop
      for(; *s; s++)
801008d8:	0f b6 07             	movzbl (%edi),%eax
801008db:	84 c0                	test   %al,%al
801008dd:	74 6a                	je     80100949 <cprintf+0x259>
801008df:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801008e2:	89 fb                	mov    %edi,%ebx
801008e4:	e9 cb fe ff ff       	jmp    801007b4 <cprintf+0xc4>
    uartputc(c);
801008e9:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
801008ec:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
801008ef:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801008f2:	57                   	push   %edi
801008f3:	e8 c8 5c 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
801008f8:	89 f8                	mov    %edi,%eax
801008fa:	e8 01 fb ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
801008ff:	0f b6 03             	movzbl (%ebx),%eax
80100902:	83 c4 10             	add    $0x10,%esp
80100905:	84 c0                	test   %al,%al
80100907:	0f 85 a7 fe ff ff    	jne    801007b4 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
8010090d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
80100910:	8b 7d e0             	mov    -0x20(%ebp),%edi
80100913:	e9 53 fe ff ff       	jmp    8010076b <cprintf+0x7b>
    uartputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010091e:	52                   	push   %edx
8010091f:	e8 9c 5c 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100924:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100927:	e8 d4 fa ff ff       	call   80100400 <cgaputc>
}
8010092c:	83 c4 10             	add    $0x10,%esp
8010092f:	e9 37 fe ff ff       	jmp    8010076b <cprintf+0x7b>
    release(&cons.lock);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	68 20 ff 10 80       	push   $0x8010ff20
8010093c:	e8 3f 44 00 00       	call   80104d80 <release>
80100941:	83 c4 10             	add    $0x10,%esp
}
80100944:	e9 38 fe ff ff       	jmp    80100781 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100949:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010094c:	e9 1a fe ff ff       	jmp    8010076b <cprintf+0x7b>
    panic("null fmt");
80100951:	83 ec 0c             	sub    $0xc,%esp
80100954:	68 ff 7a 10 80       	push   $0x80107aff
80100959:	e8 22 fa ff ff       	call   80100380 <panic>
8010095e:	66 90                	xchg   %ax,%ax

80100960 <get_cursor_pos>:
get_cursor_pos(){
80100960:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100961:	b8 0e 00 00 00       	mov    $0xe,%eax
80100966:	89 e5                	mov    %esp,%ebp
80100968:	56                   	push   %esi
80100969:	be d4 03 00 00       	mov    $0x3d4,%esi
8010096e:	53                   	push   %ebx
8010096f:	89 f2                	mov    %esi,%edx
80100971:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100972:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100977:	89 da                	mov    %ebx,%edx
80100979:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
8010097a:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010097d:	89 f2                	mov    %esi,%edx
8010097f:	b8 0f 00 00 00       	mov    $0xf,%eax
80100984:	c1 e1 08             	shl    $0x8,%ecx
80100987:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100988:	89 da                	mov    %ebx,%edx
8010098a:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010098b:	0f b6 c0             	movzbl %al,%eax
}
8010098e:	5b                   	pop    %ebx
8010098f:	5e                   	pop    %esi
  pos |= inb(CRTPORT+1);
80100990:	09 c8                	or     %ecx,%eax
}
80100992:	5d                   	pop    %ebp
80100993:	c3                   	ret    
80100994:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010099b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010099f:	90                   	nop

801009a0 <change_cursor_pos>:
{
801009a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801009a1:	b8 0e 00 00 00       	mov    $0xe,%eax
801009a6:	89 e5                	mov    %esp,%ebp
801009a8:	56                   	push   %esi
801009a9:	be d4 03 00 00       	mov    $0x3d4,%esi
801009ae:	53                   	push   %ebx
801009af:	8b 4d 08             	mov    0x8(%ebp),%ecx
801009b2:	89 f2                	mov    %esi,%edx
801009b4:	ee                   	out    %al,(%dx)
801009b5:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  outb(CRTPORT+1, pos>>8);
801009ba:	89 c8                	mov    %ecx,%eax
801009bc:	c1 f8 08             	sar    $0x8,%eax
801009bf:	89 da                	mov    %ebx,%edx
801009c1:	ee                   	out    %al,(%dx)
801009c2:	b8 0f 00 00 00       	mov    $0xf,%eax
801009c7:	89 f2                	mov    %esi,%edx
801009c9:	ee                   	out    %al,(%dx)
801009ca:	89 c8                	mov    %ecx,%eax
801009cc:	89 da                	mov    %ebx,%edx
801009ce:	ee                   	out    %al,(%dx)
}
801009cf:	5b                   	pop    %ebx
801009d0:	5e                   	pop    %esi
801009d1:	5d                   	pop    %ebp
801009d2:	c3                   	ret    
801009d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801009e0 <delword>:
{
801009e0:	55                   	push   %ebp
801009e1:	b8 0e 00 00 00       	mov    $0xe,%eax
801009e6:	89 e5                	mov    %esp,%ebp
801009e8:	57                   	push   %edi
801009e9:	56                   	push   %esi
801009ea:	be d4 03 00 00       	mov    $0x3d4,%esi
801009ef:	53                   	push   %ebx
801009f0:	89 f2                	mov    %esi,%edx
801009f2:	83 ec 0c             	sub    $0xc,%esp
801009f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801009f6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801009fb:	89 da                	mov    %ebx,%edx
801009fd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801009fe:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a01:	89 f2                	mov    %esi,%edx
80100a03:	b8 0f 00 00 00       	mov    $0xf,%eax
80100a08:	c1 e1 08             	shl    $0x8,%ecx
80100a0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a0c:	89 da                	mov    %ebx,%edx
80100a0e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100a0f:	0f b6 c0             	movzbl %al,%eax
80100a12:	09 c8                	or     %ecx,%eax
      if(crt[pos - 2] == ('$' | 0x0700)){
80100a14:	66 81 bc 00 fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%eax,%eax,1)
80100a1b:	80 24 07 
80100a1e:	0f 84 9e 00 00 00    	je     80100ac2 <delword+0xe2>
80100a24:	be 0e 00 00 00       	mov    $0xe,%esi
80100a29:	bb d4 03 00 00       	mov    $0x3d4,%ebx
      if(input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100a2e:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
  if(panicked){
80100a33:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
      if(input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100a39:	83 e8 01             	sub    $0x1,%eax
80100a3c:	89 c2                	mov    %eax,%edx
        input.e--;
80100a3e:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
      if(input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100a43:	83 e2 7f             	and    $0x7f,%edx
80100a46:	80 ba 80 fe 10 80 20 	cmpb   $0x20,-0x7fef0180(%edx)
80100a4d:	74 7b                	je     80100aca <delword+0xea>
  if(panicked){
80100a4f:	85 c9                	test   %ecx,%ecx
80100a51:	74 0d                	je     80100a60 <delword+0x80>
  asm volatile("cli");
80100a53:	fa                   	cli    
    for(;;)
80100a54:	eb fe                	jmp    80100a54 <delword+0x74>
80100a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a60:	83 ec 0c             	sub    $0xc,%esp
80100a63:	6a 08                	push   $0x8
80100a65:	e8 56 5b 00 00       	call   801065c0 <uartputc>
80100a6a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a71:	e8 4a 5b 00 00       	call   801065c0 <uartputc>
80100a76:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a7d:	e8 3e 5b 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100a82:	b8 00 01 00 00       	mov    $0x100,%eax
80100a87:	e8 74 f9 ff ff       	call   80100400 <cgaputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a8c:	89 f0                	mov    %esi,%eax
80100a8e:	89 da                	mov    %ebx,%edx
80100a90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100a91:	bf d5 03 00 00       	mov    $0x3d5,%edi
80100a96:	89 fa                	mov    %edi,%edx
80100a98:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100a99:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100a9c:	89 da                	mov    %ebx,%edx
80100a9e:	b8 0f 00 00 00       	mov    $0xf,%eax
80100aa3:	c1 e1 08             	shl    $0x8,%ecx
80100aa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100aa7:	89 fa                	mov    %edi,%edx
80100aa9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100aaa:	0f b6 c0             	movzbl %al,%eax
      if(crt[pos - 2] == ('$' | 0x0700)){
80100aad:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
80100ab0:	09 c8                	or     %ecx,%eax
      if(crt[pos - 2] == ('$' | 0x0700)){
80100ab2:	66 81 bc 00 fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%eax,%eax,1)
80100ab9:	80 24 07 
80100abc:	0f 85 6c ff ff ff    	jne    80100a2e <delword+0x4e>
}
80100ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ac5:	5b                   	pop    %ebx
80100ac6:	5e                   	pop    %esi
80100ac7:	5f                   	pop    %edi
80100ac8:	5d                   	pop    %ebp
80100ac9:	c3                   	ret    
  if(panicked){
80100aca:	85 c9                	test   %ecx,%ecx
80100acc:	74 0a                	je     80100ad8 <delword+0xf8>
  asm volatile("cli");
80100ace:	fa                   	cli    
    for(;;)
80100acf:	eb fe                	jmp    80100acf <delword+0xef>
80100ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ad8:	83 ec 0c             	sub    $0xc,%esp
80100adb:	6a 08                	push   $0x8
80100add:	e8 de 5a 00 00       	call   801065c0 <uartputc>
80100ae2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae9:	e8 d2 5a 00 00       	call   801065c0 <uartputc>
80100aee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100af5:	e8 c6 5a 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100afa:	83 c4 10             	add    $0x10,%esp
}
80100afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  cgaputc(c);
80100b00:	b8 00 01 00 00       	mov    $0x100,%eax
}
80100b05:	5b                   	pop    %ebx
80100b06:	5e                   	pop    %esi
80100b07:	5f                   	pop    %edi
80100b08:	5d                   	pop    %ebp
  cgaputc(c);
80100b09:	e9 f2 f8 ff ff       	jmp    80100400 <cgaputc>
80100b0e:	66 90                	xchg   %ax,%ax

80100b10 <go_to_beginning_of_line>:
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b14:	bf 0e 00 00 00       	mov    $0xe,%edi
80100b19:	56                   	push   %esi
80100b1a:	be d4 03 00 00       	mov    $0x3d4,%esi
80100b1f:	89 f8                	mov    %edi,%eax
80100b21:	53                   	push   %ebx
80100b22:	89 f2                	mov    %esi,%edx
80100b24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b25:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100b2a:	89 da                	mov    %ebx,%edx
80100b2c:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100b2d:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b30:	89 f2                	mov    %esi,%edx
80100b32:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b37:	c1 e1 08             	shl    $0x8,%ecx
80100b3a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b3b:	89 da                	mov    %ebx,%edx
80100b3d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100b3e:	0f b6 c0             	movzbl %al,%eax
80100b41:	09 c1                	or     %eax,%ecx
  if(crt[pos - 2] == ('$' | 0x0700)){ // if at the begining of line, do nothing.
80100b43:	66 81 bc 09 fc 7f 0b 	cmpw   $0x724,-0x7ff48004(%ecx,%ecx,1)
80100b4a:	80 24 07 
80100b4d:	74 3e                	je     80100b8d <go_to_beginning_of_line+0x7d>
  int change = pos % 80 - 2;
80100b4f:	89 c8                	mov    %ecx,%eax
80100b51:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100b56:	f7 e2                	mul    %edx
80100b58:	c1 ea 06             	shr    $0x6,%edx
80100b5b:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100b5e:	c1 e0 04             	shl    $0x4,%eax
80100b61:	29 c1                	sub    %eax,%ecx
80100b63:	89 ca                	mov    %ecx,%edx
  next_pos = pos - change;
80100b65:	8d 48 02             	lea    0x2(%eax),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b68:	89 f8                	mov    %edi,%eax
  back_counter += (change - 1);
80100b6a:	83 ea 03             	sub    $0x3,%edx
80100b6d:	01 15 0c ff 10 80    	add    %edx,0x8010ff0c
80100b73:	89 f2                	mov    %esi,%edx
80100b75:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100b76:	89 cf                	mov    %ecx,%edi
80100b78:	89 da                	mov    %ebx,%edx
80100b7a:	c1 ff 08             	sar    $0x8,%edi
80100b7d:	89 f8                	mov    %edi,%eax
80100b7f:	ee                   	out    %al,(%dx)
80100b80:	b8 0f 00 00 00       	mov    $0xf,%eax
80100b85:	89 f2                	mov    %esi,%edx
80100b87:	ee                   	out    %al,(%dx)
80100b88:	89 c8                	mov    %ecx,%eax
80100b8a:	89 da                	mov    %ebx,%edx
80100b8c:	ee                   	out    %al,(%dx)
}
80100b8d:	5b                   	pop    %ebx
80100b8e:	5e                   	pop    %esi
80100b8f:	5f                   	pop    %edi
80100b90:	5d                   	pop    %ebp
80100b91:	c3                   	ret    
80100b92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ba0 <go_to_end_of_line>:
{
80100ba0:	55                   	push   %ebp
80100ba1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100ba6:	89 e5                	mov    %esp,%ebp
80100ba8:	57                   	push   %edi
80100ba9:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100bae:	56                   	push   %esi
80100baf:	89 fa                	mov    %edi,%edx
80100bb1:	53                   	push   %ebx
80100bb2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bb3:	be d5 03 00 00       	mov    $0x3d5,%esi
80100bb8:	89 f2                	mov    %esi,%edx
80100bba:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100bbb:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bbe:	89 fa                	mov    %edi,%edx
80100bc0:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bc5:	c1 e3 08             	shl    $0x8,%ebx
80100bc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bc9:	89 f2                	mov    %esi,%edx
80100bcb:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100bcc:	0f b6 c8             	movzbl %al,%ecx
  int change = pos % 80 - 2;
80100bcf:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  pos |= inb(CRTPORT+1);
80100bd4:	09 d9                	or     %ebx,%ecx
  if(change == input.e){ // if at the end of line, do nothing.
80100bd6:	8b 1d 08 ff 10 80    	mov    0x8010ff08,%ebx
  int change = pos % 80 - 2;
80100bdc:	89 c8                	mov    %ecx,%eax
80100bde:	f7 e2                	mul    %edx
80100be0:	89 c8                	mov    %ecx,%eax
80100be2:	c1 ea 06             	shr    $0x6,%edx
80100be5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80100be8:	c1 e2 04             	shl    $0x4,%edx
80100beb:	29 d0                	sub    %edx,%eax
80100bed:	83 e8 02             	sub    $0x2,%eax
  if(change == input.e){ // if at the end of line, do nothing.
80100bf0:	39 c3                	cmp    %eax,%ebx
80100bf2:	74 2d                	je     80100c21 <go_to_end_of_line+0x81>
  next_pos = input.e + pos - change;
80100bf4:	01 cb                	add    %ecx,%ebx
80100bf6:	29 c3                	sub    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bf8:	b8 0e 00 00 00       	mov    $0xe,%eax
  back_counter += (next_pos - pos);
80100bfd:	89 da                	mov    %ebx,%edx
80100bff:	29 ca                	sub    %ecx,%edx
80100c01:	01 15 0c ff 10 80    	add    %edx,0x8010ff0c
80100c07:	89 fa                	mov    %edi,%edx
80100c09:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100c0a:	89 d9                	mov    %ebx,%ecx
80100c0c:	89 f2                	mov    %esi,%edx
80100c0e:	c1 f9 08             	sar    $0x8,%ecx
80100c11:	89 c8                	mov    %ecx,%eax
80100c13:	ee                   	out    %al,(%dx)
80100c14:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c19:	89 fa                	mov    %edi,%edx
80100c1b:	ee                   	out    %al,(%dx)
80100c1c:	89 d8                	mov    %ebx,%eax
80100c1e:	89 f2                	mov    %esi,%edx
80100c20:	ee                   	out    %al,(%dx)
}
80100c21:	5b                   	pop    %ebx
80100c22:	5e                   	pop    %esi
80100c23:	5f                   	pop    %edi
80100c24:	5d                   	pop    %ebp
80100c25:	c3                   	ret    
80100c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c2d:	8d 76 00             	lea    0x0(%esi),%esi

80100c30 <consoleintr>:
{
80100c30:	55                   	push   %ebp
80100c31:	89 e5                	mov    %esp,%ebp
80100c33:	57                   	push   %edi
  int c, doprocdump = 0;
80100c34:	31 ff                	xor    %edi,%edi
{
80100c36:	56                   	push   %esi
80100c37:	53                   	push   %ebx
80100c38:	83 ec 28             	sub    $0x28,%esp
80100c3b:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
80100c3e:	68 20 ff 10 80       	push   $0x8010ff20
80100c43:	e8 98 41 00 00       	call   80104de0 <acquire>
  while((c = getc()) >= 0){
80100c48:	83 c4 10             	add    $0x10,%esp
80100c4b:	ff d6                	call   *%esi
80100c4d:	85 c0                	test   %eax,%eax
80100c4f:	0f 88 bb 00 00 00    	js     80100d10 <consoleintr+0xe0>
    switch(c){
80100c55:	83 f8 17             	cmp    $0x17,%eax
80100c58:	0f 84 da 01 00 00    	je     80100e38 <consoleintr+0x208>
80100c5e:	0f 8f 7c 00 00 00    	jg     80100ce0 <consoleintr+0xb0>
80100c64:	83 f8 10             	cmp    $0x10,%eax
80100c67:	0f 84 c3 00 00 00    	je     80100d30 <consoleintr+0x100>
80100c6d:	83 f8 15             	cmp    $0x15,%eax
80100c70:	75 3e                	jne    80100cb0 <consoleintr+0x80>
      while(input.e != input.w &&
80100c72:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100c77:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100c7d:	74 cc                	je     80100c4b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100c7f:	83 e8 01             	sub    $0x1,%eax
80100c82:	89 c2                	mov    %eax,%edx
80100c84:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100c87:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100c8e:	74 bb                	je     80100c4b <consoleintr+0x1b>
  if(panicked){
80100c90:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100c96:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100c9b:	85 d2                	test   %edx,%edx
80100c9d:	0f 84 97 00 00 00    	je     80100d3a <consoleintr+0x10a>
  asm volatile("cli");
80100ca3:	fa                   	cli    
    for(;;)
80100ca4:	eb fe                	jmp    80100ca4 <consoleintr+0x74>
80100ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100cad:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100cb0:	83 f8 08             	cmp    $0x8,%eax
80100cb3:	0f 85 c7 00 00 00    	jne    80100d80 <consoleintr+0x150>
      if(input.e != input.w){
80100cb9:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100cbe:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100cc4:	74 85                	je     80100c4b <consoleintr+0x1b>
        input.e--;
80100cc6:	83 e8 01             	sub    $0x1,%eax
80100cc9:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100cce:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100cd3:	85 c0                	test   %eax,%eax
80100cd5:	0f 84 77 01 00 00    	je     80100e52 <consoleintr+0x222>
80100cdb:	fa                   	cli    
    for(;;)
80100cdc:	eb fe                	jmp    80100cdc <consoleintr+0xac>
80100cde:	66 90                	xchg   %ax,%ax
    switch(c){
80100ce0:	83 f8 7d             	cmp    $0x7d,%eax
80100ce3:	0f 84 5f 01 00 00    	je     80100e48 <consoleintr+0x218>
80100ce9:	83 f8 7f             	cmp    $0x7f,%eax
80100cec:	74 cb                	je     80100cb9 <consoleintr+0x89>
80100cee:	83 f8 7b             	cmp    $0x7b,%eax
80100cf1:	0f 85 91 00 00 00    	jne    80100d88 <consoleintr+0x158>
      go_to_beginning_of_line();
80100cf7:	e8 14 fe ff ff       	call   80100b10 <go_to_beginning_of_line>
  while((c = getc()) >= 0){
80100cfc:	ff d6                	call   *%esi
80100cfe:	85 c0                	test   %eax,%eax
80100d00:	0f 89 4f ff ff ff    	jns    80100c55 <consoleintr+0x25>
80100d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d0d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	68 20 ff 10 80       	push   $0x8010ff20
80100d18:	e8 63 40 00 00       	call   80104d80 <release>
  if(doprocdump) {
80100d1d:	83 c4 10             	add    $0x10,%esp
80100d20:	85 ff                	test   %edi,%edi
80100d22:	0f 85 68 01 00 00    	jne    80100e90 <consoleintr+0x260>
}
80100d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d2b:	5b                   	pop    %ebx
80100d2c:	5e                   	pop    %esi
80100d2d:	5f                   	pop    %edi
80100d2e:	5d                   	pop    %ebp
80100d2f:	c3                   	ret    
    switch(c){
80100d30:	bf 01 00 00 00       	mov    $0x1,%edi
80100d35:	e9 11 ff ff ff       	jmp    80100c4b <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100d3a:	83 ec 0c             	sub    $0xc,%esp
80100d3d:	6a 08                	push   $0x8
80100d3f:	e8 7c 58 00 00       	call   801065c0 <uartputc>
80100d44:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100d4b:	e8 70 58 00 00       	call   801065c0 <uartputc>
80100d50:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100d57:	e8 64 58 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100d5c:	b8 00 01 00 00       	mov    $0x100,%eax
80100d61:	e8 9a f6 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100d66:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100d6b:	83 c4 10             	add    $0x10,%esp
80100d6e:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100d74:	0f 85 05 ff ff ff    	jne    80100c7f <consoleintr+0x4f>
80100d7a:	e9 cc fe ff ff       	jmp    80100c4b <consoleintr+0x1b>
80100d7f:	90                   	nop
      if(c != 0 && input.e - input.r < INPUT_BUF){
80100d80:	85 c0                	test   %eax,%eax
80100d82:	0f 84 c3 fe ff ff    	je     80100c4b <consoleintr+0x1b>
80100d88:	8b 0d 08 ff 10 80    	mov    0x8010ff08,%ecx
80100d8e:	89 ca                	mov    %ecx,%edx
80100d90:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
80100d96:	83 fa 7f             	cmp    $0x7f,%edx
80100d99:	0f 87 ac fe ff ff    	ja     80100c4b <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d9f:	89 ca                	mov    %ecx,%edx
80100da1:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(panicked){
80100da4:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100daa:	89 1d 08 ff 10 80    	mov    %ebx,0x8010ff08
80100db0:	83 e2 7f             	and    $0x7f,%edx
        c = (c == '\r') ? '\n' : c;
80100db3:	83 f8 0d             	cmp    $0xd,%eax
80100db6:	0f 84 e0 00 00 00    	je     80100e9c <consoleintr+0x26c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100dbc:	88 82 80 fe 10 80    	mov    %al,-0x7fef0180(%edx)
  if(panicked){
80100dc2:	85 c9                	test   %ecx,%ecx
80100dc4:	0f 85 bc 00 00 00    	jne    80100e86 <consoleintr+0x256>
  if(c == BACKSPACE){
80100dca:	3d 00 01 00 00       	cmp    $0x100,%eax
80100dcf:	0f 85 f3 00 00 00    	jne    80100ec8 <consoleintr+0x298>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100dd5:	83 ec 0c             	sub    $0xc,%esp
80100dd8:	6a 08                	push   $0x8
80100dda:	e8 e1 57 00 00       	call   801065c0 <uartputc>
80100ddf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100de6:	e8 d5 57 00 00       	call   801065c0 <uartputc>
80100deb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100df2:	e8 c9 57 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100df7:	b8 00 01 00 00       	mov    $0x100,%eax
80100dfc:	e8 ff f5 ff ff       	call   80100400 <cgaputc>
80100e01:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e04:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80100e09:	83 e8 80             	sub    $0xffffff80,%eax
80100e0c:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100e12:	0f 85 33 fe ff ff    	jne    80100c4b <consoleintr+0x1b>
          wakeup(&input.r);
80100e18:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100e1b:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100e20:	68 00 ff 10 80       	push   $0x8010ff00
80100e25:	e8 76 37 00 00       	call   801045a0 <wakeup>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	e9 19 fe ff ff       	jmp    80100c4b <consoleintr+0x1b>
80100e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      delword();
80100e38:	e8 a3 fb ff ff       	call   801009e0 <delword>
      break;
80100e3d:	e9 09 fe ff ff       	jmp    80100c4b <consoleintr+0x1b>
80100e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      go_to_end_of_line();
80100e48:	e8 53 fd ff ff       	call   80100ba0 <go_to_end_of_line>
      break;
80100e4d:	e9 f9 fd ff ff       	jmp    80100c4b <consoleintr+0x1b>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100e52:	83 ec 0c             	sub    $0xc,%esp
80100e55:	6a 08                	push   $0x8
80100e57:	e8 64 57 00 00       	call   801065c0 <uartputc>
80100e5c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100e63:	e8 58 57 00 00       	call   801065c0 <uartputc>
80100e68:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100e6f:	e8 4c 57 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100e74:	b8 00 01 00 00       	mov    $0x100,%eax
80100e79:	e8 82 f5 ff ff       	call   80100400 <cgaputc>
}
80100e7e:	83 c4 10             	add    $0x10,%esp
80100e81:	e9 c5 fd ff ff       	jmp    80100c4b <consoleintr+0x1b>
80100e86:	fa                   	cli    
    for(;;)
80100e87:	eb fe                	jmp    80100e87 <consoleintr+0x257>
80100e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80100e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e93:	5b                   	pop    %ebx
80100e94:	5e                   	pop    %esi
80100e95:	5f                   	pop    %edi
80100e96:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100e97:	e9 e4 37 00 00       	jmp    80104680 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100e9c:	c6 82 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%edx)
  if(panicked){
80100ea3:	85 c9                	test   %ecx,%ecx
80100ea5:	75 df                	jne    80100e86 <consoleintr+0x256>
    uartputc(c);
80100ea7:	83 ec 0c             	sub    $0xc,%esp
80100eaa:	6a 0a                	push   $0xa
80100eac:	e8 0f 57 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
80100eb6:	e8 45 f5 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100ebb:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ec0:	83 c4 10             	add    $0x10,%esp
80100ec3:	e9 50 ff ff ff       	jmp    80100e18 <consoleintr+0x1e8>
    uartputc(c);
80100ec8:	83 ec 0c             	sub    $0xc,%esp
80100ecb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ece:	50                   	push   %eax
80100ecf:	e8 ec 56 00 00       	call   801065c0 <uartputc>
  cgaputc(c);
80100ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed7:	e8 24 f5 ff ff       	call   80100400 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100edc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edf:	83 c4 10             	add    $0x10,%esp
80100ee2:	83 f8 0a             	cmp    $0xa,%eax
80100ee5:	74 09                	je     80100ef0 <consoleintr+0x2c0>
80100ee7:	83 f8 04             	cmp    $0x4,%eax
80100eea:	0f 85 14 ff ff ff    	jne    80100e04 <consoleintr+0x1d4>
          input.w = input.e;
80100ef0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100ef5:	e9 1e ff ff ff       	jmp    80100e18 <consoleintr+0x1e8>
80100efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f00 <consoleinit>:

void
consoleinit(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f06:	68 08 7b 10 80       	push   $0x80107b08
80100f0b:	68 20 ff 10 80       	push   $0x8010ff20
80100f10:	e8 fb 3c 00 00       	call   80104c10 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f15:	58                   	pop    %eax
80100f16:	5a                   	pop    %edx
80100f17:	6a 00                	push   $0x0
80100f19:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f1b:	c7 05 0c 09 11 80 c0 	movl   $0x801005c0,0x8011090c
80100f22:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100f25:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100f2c:	02 10 80 
  cons.locking = 1;
80100f2f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100f36:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f39:	e8 e2 19 00 00       	call   80102920 <ioapicenable>
80100f3e:	83 c4 10             	add    $0x10,%esp
80100f41:	c9                   	leave  
80100f42:	c3                   	ret    
80100f43:	66 90                	xchg   %ax,%ax
80100f45:	66 90                	xchg   %ax,%ax
80100f47:	66 90                	xchg   %ax,%ax
80100f49:	66 90                	xchg   %ax,%ax
80100f4b:	66 90                	xchg   %ax,%ax
80100f4d:	66 90                	xchg   %ax,%ax
80100f4f:	90                   	nop

80100f50 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100f5c:	e8 af 2e 00 00       	call   80103e10 <myproc>
80100f61:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100f67:	e8 94 22 00 00       	call   80103200 <begin_op>

  if((ip = namei(path)) == 0){
80100f6c:	83 ec 0c             	sub    $0xc,%esp
80100f6f:	ff 75 08             	push   0x8(%ebp)
80100f72:	e8 c9 15 00 00       	call   80102540 <namei>
80100f77:	83 c4 10             	add    $0x10,%esp
80100f7a:	85 c0                	test   %eax,%eax
80100f7c:	0f 84 02 03 00 00    	je     80101284 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100f82:	83 ec 0c             	sub    $0xc,%esp
80100f85:	89 c3                	mov    %eax,%ebx
80100f87:	50                   	push   %eax
80100f88:	e8 93 0c 00 00       	call   80101c20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100f8d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100f93:	6a 34                	push   $0x34
80100f95:	6a 00                	push   $0x0
80100f97:	50                   	push   %eax
80100f98:	53                   	push   %ebx
80100f99:	e8 92 0f 00 00       	call   80101f30 <readi>
80100f9e:	83 c4 20             	add    $0x20,%esp
80100fa1:	83 f8 34             	cmp    $0x34,%eax
80100fa4:	74 22                	je     80100fc8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	53                   	push   %ebx
80100faa:	e8 01 0f 00 00       	call   80101eb0 <iunlockput>
    end_op();
80100faf:	e8 bc 22 00 00       	call   80103270 <end_op>
80100fb4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100fb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbf:	5b                   	pop    %ebx
80100fc0:	5e                   	pop    %esi
80100fc1:	5f                   	pop    %edi
80100fc2:	5d                   	pop    %ebp
80100fc3:	c3                   	ret    
80100fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100fc8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100fcf:	45 4c 46 
80100fd2:	75 d2                	jne    80100fa6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100fd4:	e8 77 67 00 00       	call   80107750 <setupkvm>
80100fd9:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100fdf:	85 c0                	test   %eax,%eax
80100fe1:	74 c3                	je     80100fa6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100fe3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100fea:	00 
80100feb:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100ff1:	0f 84 ac 02 00 00    	je     801012a3 <exec+0x353>
  sz = 0;
80100ff7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100ffe:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101001:	31 ff                	xor    %edi,%edi
80101003:	e9 8e 00 00 00       	jmp    80101096 <exec+0x146>
80101008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80101010:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101017:	75 6c                	jne    80101085 <exec+0x135>
    if(ph.memsz < ph.filesz)
80101019:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010101f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101025:	0f 82 87 00 00 00    	jb     801010b2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010102b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101031:	72 7f                	jb     801010b2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101033:	83 ec 04             	sub    $0x4,%esp
80101036:	50                   	push   %eax
80101037:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
8010103d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101043:	e8 28 65 00 00       	call   80107570 <allocuvm>
80101048:	83 c4 10             	add    $0x10,%esp
8010104b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80101051:	85 c0                	test   %eax,%eax
80101053:	74 5d                	je     801010b2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80101055:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
8010105b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80101060:	75 50                	jne    801010b2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80101062:	83 ec 0c             	sub    $0xc,%esp
80101065:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
8010106b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80101071:	53                   	push   %ebx
80101072:	50                   	push   %eax
80101073:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80101079:	e8 02 64 00 00       	call   80107480 <loaduvm>
8010107e:	83 c4 20             	add    $0x20,%esp
80101081:	85 c0                	test   %eax,%eax
80101083:	78 2d                	js     801010b2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101085:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
8010108c:	83 c7 01             	add    $0x1,%edi
8010108f:	83 c6 20             	add    $0x20,%esi
80101092:	39 f8                	cmp    %edi,%eax
80101094:	7e 3a                	jle    801010d0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80101096:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
8010109c:	6a 20                	push   $0x20
8010109e:	56                   	push   %esi
8010109f:	50                   	push   %eax
801010a0:	53                   	push   %ebx
801010a1:	e8 8a 0e 00 00       	call   80101f30 <readi>
801010a6:	83 c4 10             	add    $0x10,%esp
801010a9:	83 f8 20             	cmp    $0x20,%eax
801010ac:	0f 84 5e ff ff ff    	je     80101010 <exec+0xc0>
    freevm(pgdir);
801010b2:	83 ec 0c             	sub    $0xc,%esp
801010b5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801010bb:	e8 10 66 00 00       	call   801076d0 <freevm>
  if(ip){
801010c0:	83 c4 10             	add    $0x10,%esp
801010c3:	e9 de fe ff ff       	jmp    80100fa6 <exec+0x56>
801010c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010cf:	90                   	nop
  sz = PGROUNDUP(sz);
801010d0:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
801010d6:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
801010dc:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801010e2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	53                   	push   %ebx
801010ec:	e8 bf 0d 00 00       	call   80101eb0 <iunlockput>
  end_op();
801010f1:	e8 7a 21 00 00       	call   80103270 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
801010f6:	83 c4 0c             	add    $0xc,%esp
801010f9:	56                   	push   %esi
801010fa:	57                   	push   %edi
801010fb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101101:	57                   	push   %edi
80101102:	e8 69 64 00 00       	call   80107570 <allocuvm>
80101107:	83 c4 10             	add    $0x10,%esp
8010110a:	89 c6                	mov    %eax,%esi
8010110c:	85 c0                	test   %eax,%eax
8010110e:	0f 84 94 00 00 00    	je     801011a8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101114:	83 ec 08             	sub    $0x8,%esp
80101117:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
8010111d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010111f:	50                   	push   %eax
80101120:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101121:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101123:	e8 c8 66 00 00       	call   801077f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101128:	8b 45 0c             	mov    0xc(%ebp),%eax
8010112b:	83 c4 10             	add    $0x10,%esp
8010112e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80101134:	8b 00                	mov    (%eax),%eax
80101136:	85 c0                	test   %eax,%eax
80101138:	0f 84 8b 00 00 00    	je     801011c9 <exec+0x279>
8010113e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80101144:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
8010114a:	eb 23                	jmp    8010116f <exec+0x21f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101150:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80101153:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
8010115a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
8010115d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80101163:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80101166:	85 c0                	test   %eax,%eax
80101168:	74 59                	je     801011c3 <exec+0x273>
    if(argc >= MAXARG)
8010116a:	83 ff 20             	cmp    $0x20,%edi
8010116d:	74 39                	je     801011a8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	50                   	push   %eax
80101173:	e8 28 3f 00 00       	call   801050a0 <strlen>
80101178:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
8010117a:	58                   	pop    %eax
8010117b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
8010117e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101181:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80101184:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80101187:	e8 14 3f 00 00       	call   801050a0 <strlen>
8010118c:	83 c0 01             	add    $0x1,%eax
8010118f:	50                   	push   %eax
80101190:	8b 45 0c             	mov    0xc(%ebp),%eax
80101193:	ff 34 b8             	push   (%eax,%edi,4)
80101196:	53                   	push   %ebx
80101197:	56                   	push   %esi
80101198:	e8 23 68 00 00       	call   801079c0 <copyout>
8010119d:	83 c4 20             	add    $0x20,%esp
801011a0:	85 c0                	test   %eax,%eax
801011a2:	79 ac                	jns    80101150 <exec+0x200>
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011a8:	83 ec 0c             	sub    $0xc,%esp
801011ab:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011b1:	e8 1a 65 00 00       	call   801076d0 <freevm>
801011b6:	83 c4 10             	add    $0x10,%esp
  return -1;
801011b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011be:	e9 f9 fd ff ff       	jmp    80100fbc <exec+0x6c>
801011c3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011c9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
801011d0:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
801011d2:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
801011d9:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011dd:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
801011df:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
801011e2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
801011e8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
801011ea:	50                   	push   %eax
801011eb:	52                   	push   %edx
801011ec:	53                   	push   %ebx
801011ed:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
801011f3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
801011fa:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
801011fd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101203:	e8 b8 67 00 00       	call   801079c0 <copyout>
80101208:	83 c4 10             	add    $0x10,%esp
8010120b:	85 c0                	test   %eax,%eax
8010120d:	78 99                	js     801011a8 <exec+0x258>
  for(last=s=path; *s; s++)
8010120f:	8b 45 08             	mov    0x8(%ebp),%eax
80101212:	8b 55 08             	mov    0x8(%ebp),%edx
80101215:	0f b6 00             	movzbl (%eax),%eax
80101218:	84 c0                	test   %al,%al
8010121a:	74 13                	je     8010122f <exec+0x2df>
8010121c:	89 d1                	mov    %edx,%ecx
8010121e:	66 90                	xchg   %ax,%ax
      last = s+1;
80101220:	83 c1 01             	add    $0x1,%ecx
80101223:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101225:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80101228:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010122b:	84 c0                	test   %al,%al
8010122d:	75 f1                	jne    80101220 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
8010122f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101235:	83 ec 04             	sub    $0x4,%esp
80101238:	6a 10                	push   $0x10
8010123a:	89 f8                	mov    %edi,%eax
8010123c:	52                   	push   %edx
8010123d:	83 c0 6c             	add    $0x6c,%eax
80101240:	50                   	push   %eax
80101241:	e8 1a 3e 00 00       	call   80105060 <safestrcpy>
  curproc->pgdir = pgdir;
80101246:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
8010124c:	89 f8                	mov    %edi,%eax
8010124e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80101251:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80101253:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80101256:	89 c1                	mov    %eax,%ecx
80101258:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
8010125e:	8b 40 18             	mov    0x18(%eax),%eax
80101261:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80101264:	8b 41 18             	mov    0x18(%ecx),%eax
80101267:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
8010126a:	89 0c 24             	mov    %ecx,(%esp)
8010126d:	e8 7e 60 00 00       	call   801072f0 <switchuvm>
  freevm(oldpgdir);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 56 64 00 00       	call   801076d0 <freevm>
  return 0;
8010127a:	83 c4 10             	add    $0x10,%esp
8010127d:	31 c0                	xor    %eax,%eax
8010127f:	e9 38 fd ff ff       	jmp    80100fbc <exec+0x6c>
    end_op();
80101284:	e8 e7 1f 00 00       	call   80103270 <end_op>
    cprintf("exec: fail\n");
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	68 21 7b 10 80       	push   $0x80107b21
80101291:	e8 5a f4 ff ff       	call   801006f0 <cprintf>
    return -1;
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010129e:	e9 19 fd ff ff       	jmp    80100fbc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012a3:	be 00 20 00 00       	mov    $0x2000,%esi
801012a8:	31 ff                	xor    %edi,%edi
801012aa:	e9 39 fe ff ff       	jmp    801010e8 <exec+0x198>
801012af:	90                   	nop

801012b0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
801012b6:	68 2d 7b 10 80       	push   $0x80107b2d
801012bb:	68 60 ff 10 80       	push   $0x8010ff60
801012c0:	e8 4b 39 00 00       	call   80104c10 <initlock>
}
801012c5:	83 c4 10             	add    $0x10,%esp
801012c8:	c9                   	leave  
801012c9:	c3                   	ret    
801012ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801012d0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012d4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
801012d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801012dc:	68 60 ff 10 80       	push   $0x8010ff60
801012e1:	e8 fa 3a 00 00       	call   80104de0 <acquire>
801012e6:	83 c4 10             	add    $0x10,%esp
801012e9:	eb 10                	jmp    801012fb <filealloc+0x2b>
801012eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012ef:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012f0:	83 c3 18             	add    $0x18,%ebx
801012f3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
801012f9:	74 25                	je     80101320 <filealloc+0x50>
    if(f->ref == 0){
801012fb:	8b 43 04             	mov    0x4(%ebx),%eax
801012fe:	85 c0                	test   %eax,%eax
80101300:	75 ee                	jne    801012f0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101302:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101305:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010130c:	68 60 ff 10 80       	push   $0x8010ff60
80101311:	e8 6a 3a 00 00       	call   80104d80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101316:	89 d8                	mov    %ebx,%eax
      return f;
80101318:	83 c4 10             	add    $0x10,%esp
}
8010131b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010131e:	c9                   	leave  
8010131f:	c3                   	ret    
  release(&ftable.lock);
80101320:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101323:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101325:	68 60 ff 10 80       	push   $0x8010ff60
8010132a:	e8 51 3a 00 00       	call   80104d80 <release>
}
8010132f:	89 d8                	mov    %ebx,%eax
  return 0;
80101331:	83 c4 10             	add    $0x10,%esp
}
80101334:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101337:	c9                   	leave  
80101338:	c3                   	ret    
80101339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101340 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	53                   	push   %ebx
80101344:	83 ec 10             	sub    $0x10,%esp
80101347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010134a:	68 60 ff 10 80       	push   $0x8010ff60
8010134f:	e8 8c 3a 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
80101354:	8b 43 04             	mov    0x4(%ebx),%eax
80101357:	83 c4 10             	add    $0x10,%esp
8010135a:	85 c0                	test   %eax,%eax
8010135c:	7e 1a                	jle    80101378 <filedup+0x38>
    panic("filedup");
  f->ref++;
8010135e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101361:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101364:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80101367:	68 60 ff 10 80       	push   $0x8010ff60
8010136c:	e8 0f 3a 00 00       	call   80104d80 <release>
  return f;
}
80101371:	89 d8                	mov    %ebx,%eax
80101373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101376:	c9                   	leave  
80101377:	c3                   	ret    
    panic("filedup");
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	68 34 7b 10 80       	push   $0x80107b34
80101380:	e8 fb ef ff ff       	call   80100380 <panic>
80101385:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 28             	sub    $0x28,%esp
80101399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010139c:	68 60 ff 10 80       	push   $0x8010ff60
801013a1:	e8 3a 3a 00 00       	call   80104de0 <acquire>
  if(f->ref < 1)
801013a6:	8b 53 04             	mov    0x4(%ebx),%edx
801013a9:	83 c4 10             	add    $0x10,%esp
801013ac:	85 d2                	test   %edx,%edx
801013ae:	0f 8e a5 00 00 00    	jle    80101459 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
801013b4:	83 ea 01             	sub    $0x1,%edx
801013b7:	89 53 04             	mov    %edx,0x4(%ebx)
801013ba:	75 44                	jne    80101400 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
801013bc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
801013c0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
801013c3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
801013c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
801013cb:	8b 73 0c             	mov    0xc(%ebx),%esi
801013ce:	88 45 e7             	mov    %al,-0x19(%ebp)
801013d1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
801013d4:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
801013d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801013dc:	e8 9f 39 00 00       	call   80104d80 <release>

  if(ff.type == FD_PIPE)
801013e1:	83 c4 10             	add    $0x10,%esp
801013e4:	83 ff 01             	cmp    $0x1,%edi
801013e7:	74 57                	je     80101440 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
801013e9:	83 ff 02             	cmp    $0x2,%edi
801013ec:	74 2a                	je     80101418 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
801013ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f1:	5b                   	pop    %ebx
801013f2:	5e                   	pop    %esi
801013f3:	5f                   	pop    %edi
801013f4:	5d                   	pop    %ebp
801013f5:	c3                   	ret    
801013f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013fd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101400:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101407:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010140e:	e9 6d 39 00 00       	jmp    80104d80 <release>
80101413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101417:	90                   	nop
    begin_op();
80101418:	e8 e3 1d 00 00       	call   80103200 <begin_op>
    iput(ff.ip);
8010141d:	83 ec 0c             	sub    $0xc,%esp
80101420:	ff 75 e0             	push   -0x20(%ebp)
80101423:	e8 28 09 00 00       	call   80101d50 <iput>
    end_op();
80101428:	83 c4 10             	add    $0x10,%esp
}
8010142b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010142e:	5b                   	pop    %ebx
8010142f:	5e                   	pop    %esi
80101430:	5f                   	pop    %edi
80101431:	5d                   	pop    %ebp
    end_op();
80101432:	e9 39 1e 00 00       	jmp    80103270 <end_op>
80101437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010143e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101440:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101444:	83 ec 08             	sub    $0x8,%esp
80101447:	53                   	push   %ebx
80101448:	56                   	push   %esi
80101449:	e8 82 25 00 00       	call   801039d0 <pipeclose>
8010144e:	83 c4 10             	add    $0x10,%esp
}
80101451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5f                   	pop    %edi
80101457:	5d                   	pop    %ebp
80101458:	c3                   	ret    
    panic("fileclose");
80101459:	83 ec 0c             	sub    $0xc,%esp
8010145c:	68 3c 7b 10 80       	push   $0x80107b3c
80101461:	e8 1a ef ff ff       	call   80100380 <panic>
80101466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146d:	8d 76 00             	lea    0x0(%esi),%esi

80101470 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	83 ec 04             	sub    $0x4,%esp
80101477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010147a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010147d:	75 31                	jne    801014b0 <filestat+0x40>
    ilock(f->ip);
8010147f:	83 ec 0c             	sub    $0xc,%esp
80101482:	ff 73 10             	push   0x10(%ebx)
80101485:	e8 96 07 00 00       	call   80101c20 <ilock>
    stati(f->ip, st);
8010148a:	58                   	pop    %eax
8010148b:	5a                   	pop    %edx
8010148c:	ff 75 0c             	push   0xc(%ebp)
8010148f:	ff 73 10             	push   0x10(%ebx)
80101492:	e8 69 0a 00 00       	call   80101f00 <stati>
    iunlock(f->ip);
80101497:	59                   	pop    %ecx
80101498:	ff 73 10             	push   0x10(%ebx)
8010149b:	e8 60 08 00 00       	call   80101d00 <iunlock>
    return 0;
  }
  return -1;
}
801014a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801014a3:	83 c4 10             	add    $0x10,%esp
801014a6:	31 c0                	xor    %eax,%eax
}
801014a8:	c9                   	leave  
801014a9:	c3                   	ret    
801014aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801014b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801014b8:	c9                   	leave  
801014b9:	c3                   	ret    
801014ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801014c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	53                   	push   %ebx
801014c6:	83 ec 0c             	sub    $0xc,%esp
801014c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801014cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801014cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801014d2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801014d6:	74 60                	je     80101538 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801014d8:	8b 03                	mov    (%ebx),%eax
801014da:	83 f8 01             	cmp    $0x1,%eax
801014dd:	74 41                	je     80101520 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801014df:	83 f8 02             	cmp    $0x2,%eax
801014e2:	75 5b                	jne    8010153f <fileread+0x7f>
    ilock(f->ip);
801014e4:	83 ec 0c             	sub    $0xc,%esp
801014e7:	ff 73 10             	push   0x10(%ebx)
801014ea:	e8 31 07 00 00       	call   80101c20 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801014ef:	57                   	push   %edi
801014f0:	ff 73 14             	push   0x14(%ebx)
801014f3:	56                   	push   %esi
801014f4:	ff 73 10             	push   0x10(%ebx)
801014f7:	e8 34 0a 00 00       	call   80101f30 <readi>
801014fc:	83 c4 20             	add    $0x20,%esp
801014ff:	89 c6                	mov    %eax,%esi
80101501:	85 c0                	test   %eax,%eax
80101503:	7e 03                	jle    80101508 <fileread+0x48>
      f->off += r;
80101505:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101508:	83 ec 0c             	sub    $0xc,%esp
8010150b:	ff 73 10             	push   0x10(%ebx)
8010150e:	e8 ed 07 00 00       	call   80101d00 <iunlock>
    return r;
80101513:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101516:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101519:	89 f0                	mov    %esi,%eax
8010151b:	5b                   	pop    %ebx
8010151c:	5e                   	pop    %esi
8010151d:	5f                   	pop    %edi
8010151e:	5d                   	pop    %ebp
8010151f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101520:	8b 43 0c             	mov    0xc(%ebx),%eax
80101523:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101526:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101529:	5b                   	pop    %ebx
8010152a:	5e                   	pop    %esi
8010152b:	5f                   	pop    %edi
8010152c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010152d:	e9 3e 26 00 00       	jmp    80103b70 <piperead>
80101532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101538:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010153d:	eb d7                	jmp    80101516 <fileread+0x56>
  panic("fileread");
8010153f:	83 ec 0c             	sub    $0xc,%esp
80101542:	68 46 7b 10 80       	push   $0x80107b46
80101547:	e8 34 ee ff ff       	call   80100380 <panic>
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
8010155c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010155f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101562:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101565:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010156c:	0f 84 bd 00 00 00    	je     8010162f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101572:	8b 03                	mov    (%ebx),%eax
80101574:	83 f8 01             	cmp    $0x1,%eax
80101577:	0f 84 bf 00 00 00    	je     8010163c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010157d:	83 f8 02             	cmp    $0x2,%eax
80101580:	0f 85 c8 00 00 00    	jne    8010164e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101589:	31 f6                	xor    %esi,%esi
    while(i < n){
8010158b:	85 c0                	test   %eax,%eax
8010158d:	7f 30                	jg     801015bf <filewrite+0x6f>
8010158f:	e9 94 00 00 00       	jmp    80101628 <filewrite+0xd8>
80101594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101598:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010159b:	83 ec 0c             	sub    $0xc,%esp
8010159e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
801015a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801015a4:	e8 57 07 00 00       	call   80101d00 <iunlock>
      end_op();
801015a9:	e8 c2 1c 00 00       	call   80103270 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801015ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801015b1:	83 c4 10             	add    $0x10,%esp
801015b4:	39 c7                	cmp    %eax,%edi
801015b6:	75 5c                	jne    80101614 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801015b8:	01 fe                	add    %edi,%esi
    while(i < n){
801015ba:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801015bd:	7e 69                	jle    80101628 <filewrite+0xd8>
      int n1 = n - i;
801015bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801015c2:	b8 00 06 00 00       	mov    $0x600,%eax
801015c7:	29 f7                	sub    %esi,%edi
801015c9:	39 c7                	cmp    %eax,%edi
801015cb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801015ce:	e8 2d 1c 00 00       	call   80103200 <begin_op>
      ilock(f->ip);
801015d3:	83 ec 0c             	sub    $0xc,%esp
801015d6:	ff 73 10             	push   0x10(%ebx)
801015d9:	e8 42 06 00 00       	call   80101c20 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801015de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015e1:	57                   	push   %edi
801015e2:	ff 73 14             	push   0x14(%ebx)
801015e5:	01 f0                	add    %esi,%eax
801015e7:	50                   	push   %eax
801015e8:	ff 73 10             	push   0x10(%ebx)
801015eb:	e8 40 0a 00 00       	call   80102030 <writei>
801015f0:	83 c4 20             	add    $0x20,%esp
801015f3:	85 c0                	test   %eax,%eax
801015f5:	7f a1                	jg     80101598 <filewrite+0x48>
      iunlock(f->ip);
801015f7:	83 ec 0c             	sub    $0xc,%esp
801015fa:	ff 73 10             	push   0x10(%ebx)
801015fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101600:	e8 fb 06 00 00       	call   80101d00 <iunlock>
      end_op();
80101605:	e8 66 1c 00 00       	call   80103270 <end_op>
      if(r < 0)
8010160a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010160d:	83 c4 10             	add    $0x10,%esp
80101610:	85 c0                	test   %eax,%eax
80101612:	75 1b                	jne    8010162f <filewrite+0xdf>
        panic("short filewrite");
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	68 4f 7b 10 80       	push   $0x80107b4f
8010161c:	e8 5f ed ff ff       	call   80100380 <panic>
80101621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101628:	89 f0                	mov    %esi,%eax
8010162a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010162d:	74 05                	je     80101634 <filewrite+0xe4>
8010162f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101634:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5f                   	pop    %edi
8010163a:	5d                   	pop    %ebp
8010163b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010163c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010163f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101642:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101645:	5b                   	pop    %ebx
80101646:	5e                   	pop    %esi
80101647:	5f                   	pop    %edi
80101648:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101649:	e9 22 24 00 00       	jmp    80103a70 <pipewrite>
  panic("filewrite");
8010164e:	83 ec 0c             	sub    $0xc,%esp
80101651:	68 55 7b 10 80       	push   $0x80107b55
80101656:	e8 25 ed ff ff       	call   80100380 <panic>
8010165b:	66 90                	xchg   %ax,%ax
8010165d:	66 90                	xchg   %ax,%ax
8010165f:	90                   	nop

80101660 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101660:	55                   	push   %ebp
80101661:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101663:	89 d0                	mov    %edx,%eax
80101665:	c1 e8 0c             	shr    $0xc,%eax
80101668:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
8010166e:	89 e5                	mov    %esp,%ebp
80101670:	56                   	push   %esi
80101671:	53                   	push   %ebx
80101672:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101674:	83 ec 08             	sub    $0x8,%esp
80101677:	50                   	push   %eax
80101678:	51                   	push   %ecx
80101679:	e8 52 ea ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010167e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101680:	c1 fb 03             	sar    $0x3,%ebx
80101683:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101686:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101688:	83 e1 07             	and    $0x7,%ecx
8010168b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101690:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101696:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101698:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010169d:	85 c1                	test   %eax,%ecx
8010169f:	74 23                	je     801016c4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801016a1:	f7 d0                	not    %eax
  log_write(bp);
801016a3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801016a6:	21 c8                	and    %ecx,%eax
801016a8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801016ac:	56                   	push   %esi
801016ad:	e8 2e 1d 00 00       	call   801033e0 <log_write>
  brelse(bp);
801016b2:	89 34 24             	mov    %esi,(%esp)
801016b5:	e8 36 eb ff ff       	call   801001f0 <brelse>
}
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c0:	5b                   	pop    %ebx
801016c1:	5e                   	pop    %esi
801016c2:	5d                   	pop    %ebp
801016c3:	c3                   	ret    
    panic("freeing free block");
801016c4:	83 ec 0c             	sub    $0xc,%esp
801016c7:	68 5f 7b 10 80       	push   $0x80107b5f
801016cc:	e8 af ec ff ff       	call   80100380 <panic>
801016d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016df:	90                   	nop

801016e0 <balloc>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	57                   	push   %edi
801016e4:	56                   	push   %esi
801016e5:	53                   	push   %ebx
801016e6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801016e9:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
801016ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801016f2:	85 c9                	test   %ecx,%ecx
801016f4:	0f 84 87 00 00 00    	je     80101781 <balloc+0xa1>
801016fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101701:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101704:	83 ec 08             	sub    $0x8,%esp
80101707:	89 f0                	mov    %esi,%eax
80101709:	c1 f8 0c             	sar    $0xc,%eax
8010170c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101712:	50                   	push   %eax
80101713:	ff 75 d8             	push   -0x28(%ebp)
80101716:	e8 b5 e9 ff ff       	call   801000d0 <bread>
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101721:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80101726:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101729:	31 c0                	xor    %eax,%eax
8010172b:	eb 2f                	jmp    8010175c <balloc+0x7c>
8010172d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101730:	89 c1                	mov    %eax,%ecx
80101732:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101737:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010173a:	83 e1 07             	and    $0x7,%ecx
8010173d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010173f:	89 c1                	mov    %eax,%ecx
80101741:	c1 f9 03             	sar    $0x3,%ecx
80101744:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101749:	89 fa                	mov    %edi,%edx
8010174b:	85 df                	test   %ebx,%edi
8010174d:	74 41                	je     80101790 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010174f:	83 c0 01             	add    $0x1,%eax
80101752:	83 c6 01             	add    $0x1,%esi
80101755:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010175a:	74 05                	je     80101761 <balloc+0x81>
8010175c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010175f:	77 cf                	ja     80101730 <balloc+0x50>
    brelse(bp);
80101761:	83 ec 0c             	sub    $0xc,%esp
80101764:	ff 75 e4             	push   -0x1c(%ebp)
80101767:	e8 84 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010176c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101773:	83 c4 10             	add    $0x10,%esp
80101776:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101779:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
8010177f:	77 80                	ja     80101701 <balloc+0x21>
  panic("balloc: out of blocks");
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	68 72 7b 10 80       	push   $0x80107b72
80101789:	e8 f2 eb ff ff       	call   80100380 <panic>
8010178e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101790:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101793:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101796:	09 da                	or     %ebx,%edx
80101798:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010179c:	57                   	push   %edi
8010179d:	e8 3e 1c 00 00       	call   801033e0 <log_write>
        brelse(bp);
801017a2:	89 3c 24             	mov    %edi,(%esp)
801017a5:	e8 46 ea ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801017aa:	58                   	pop    %eax
801017ab:	5a                   	pop    %edx
801017ac:	56                   	push   %esi
801017ad:	ff 75 d8             	push   -0x28(%ebp)
801017b0:	e8 1b e9 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801017b5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801017b8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801017ba:	8d 40 5c             	lea    0x5c(%eax),%eax
801017bd:	68 00 02 00 00       	push   $0x200
801017c2:	6a 00                	push   $0x0
801017c4:	50                   	push   %eax
801017c5:	e8 d6 36 00 00       	call   80104ea0 <memset>
  log_write(bp);
801017ca:	89 1c 24             	mov    %ebx,(%esp)
801017cd:	e8 0e 1c 00 00       	call   801033e0 <log_write>
  brelse(bp);
801017d2:	89 1c 24             	mov    %ebx,(%esp)
801017d5:	e8 16 ea ff ff       	call   801001f0 <brelse>
}
801017da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017dd:	89 f0                	mov    %esi,%eax
801017df:	5b                   	pop    %ebx
801017e0:	5e                   	pop    %esi
801017e1:	5f                   	pop    %edi
801017e2:	5d                   	pop    %ebp
801017e3:	c3                   	ret    
801017e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	89 c7                	mov    %eax,%edi
801017f6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801017f7:	31 f6                	xor    %esi,%esi
{
801017f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017fa:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801017ff:	83 ec 28             	sub    $0x28,%esp
80101802:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101805:	68 60 09 11 80       	push   $0x80110960
8010180a:	e8 d1 35 00 00       	call   80104de0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010180f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101812:	83 c4 10             	add    $0x10,%esp
80101815:	eb 1b                	jmp    80101832 <iget+0x42>
80101817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010181e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101820:	39 3b                	cmp    %edi,(%ebx)
80101822:	74 6c                	je     80101890 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101824:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010182a:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
80101830:	73 26                	jae    80101858 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101832:	8b 43 08             	mov    0x8(%ebx),%eax
80101835:	85 c0                	test   %eax,%eax
80101837:	7f e7                	jg     80101820 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101839:	85 f6                	test   %esi,%esi
8010183b:	75 e7                	jne    80101824 <iget+0x34>
8010183d:	85 c0                	test   %eax,%eax
8010183f:	75 76                	jne    801018b7 <iget+0xc7>
80101841:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101843:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101849:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010184f:	72 e1                	jb     80101832 <iget+0x42>
80101851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101858:	85 f6                	test   %esi,%esi
8010185a:	74 79                	je     801018d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010185c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010185f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101861:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101864:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010186b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101872:	68 60 09 11 80       	push   $0x80110960
80101877:	e8 04 35 00 00       	call   80104d80 <release>

  return ip;
8010187c:	83 c4 10             	add    $0x10,%esp
}
8010187f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101882:	89 f0                	mov    %esi,%eax
80101884:	5b                   	pop    %ebx
80101885:	5e                   	pop    %esi
80101886:	5f                   	pop    %edi
80101887:	5d                   	pop    %ebp
80101888:	c3                   	ret    
80101889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101890:	39 53 04             	cmp    %edx,0x4(%ebx)
80101893:	75 8f                	jne    80101824 <iget+0x34>
      release(&icache.lock);
80101895:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101898:	83 c0 01             	add    $0x1,%eax
      return ip;
8010189b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010189d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
801018a2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801018a5:	e8 d6 34 00 00       	call   80104d80 <release>
      return ip;
801018aa:	83 c4 10             	add    $0x10,%esp
}
801018ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b0:	89 f0                	mov    %esi,%eax
801018b2:	5b                   	pop    %ebx
801018b3:	5e                   	pop    %esi
801018b4:	5f                   	pop    %edi
801018b5:	5d                   	pop    %ebp
801018b6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018bd:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801018c3:	73 10                	jae    801018d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018c5:	8b 43 08             	mov    0x8(%ebx),%eax
801018c8:	85 c0                	test   %eax,%eax
801018ca:	0f 8f 50 ff ff ff    	jg     80101820 <iget+0x30>
801018d0:	e9 68 ff ff ff       	jmp    8010183d <iget+0x4d>
    panic("iget: no inodes");
801018d5:	83 ec 0c             	sub    $0xc,%esp
801018d8:	68 88 7b 10 80       	push   $0x80107b88
801018dd:	e8 9e ea ff ff       	call   80100380 <panic>
801018e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	89 c6                	mov    %eax,%esi
801018f7:	53                   	push   %ebx
801018f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801018fb:	83 fa 0b             	cmp    $0xb,%edx
801018fe:	0f 86 8c 00 00 00    	jbe    80101990 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101904:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101907:	83 fb 7f             	cmp    $0x7f,%ebx
8010190a:	0f 87 a2 00 00 00    	ja     801019b2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101910:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101916:	85 c0                	test   %eax,%eax
80101918:	74 5e                	je     80101978 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010191a:	83 ec 08             	sub    $0x8,%esp
8010191d:	50                   	push   %eax
8010191e:	ff 36                	push   (%esi)
80101920:	e8 ab e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101925:	83 c4 10             	add    $0x10,%esp
80101928:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010192c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010192e:	8b 3b                	mov    (%ebx),%edi
80101930:	85 ff                	test   %edi,%edi
80101932:	74 1c                	je     80101950 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101934:	83 ec 0c             	sub    $0xc,%esp
80101937:	52                   	push   %edx
80101938:	e8 b3 e8 ff ff       	call   801001f0 <brelse>
8010193d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101943:	89 f8                	mov    %edi,%eax
80101945:	5b                   	pop    %ebx
80101946:	5e                   	pop    %esi
80101947:	5f                   	pop    %edi
80101948:	5d                   	pop    %ebp
80101949:	c3                   	ret    
8010194a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101950:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101953:	8b 06                	mov    (%esi),%eax
80101955:	e8 86 fd ff ff       	call   801016e0 <balloc>
      log_write(bp);
8010195a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010195d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101960:	89 03                	mov    %eax,(%ebx)
80101962:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101964:	52                   	push   %edx
80101965:	e8 76 1a 00 00       	call   801033e0 <log_write>
8010196a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010196d:	83 c4 10             	add    $0x10,%esp
80101970:	eb c2                	jmp    80101934 <bmap+0x44>
80101972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101978:	8b 06                	mov    (%esi),%eax
8010197a:	e8 61 fd ff ff       	call   801016e0 <balloc>
8010197f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101985:	eb 93                	jmp    8010191a <bmap+0x2a>
80101987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101990:	8d 5a 14             	lea    0x14(%edx),%ebx
80101993:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101997:	85 ff                	test   %edi,%edi
80101999:	75 a5                	jne    80101940 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010199b:	8b 00                	mov    (%eax),%eax
8010199d:	e8 3e fd ff ff       	call   801016e0 <balloc>
801019a2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801019a6:	89 c7                	mov    %eax,%edi
}
801019a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ab:	5b                   	pop    %ebx
801019ac:	89 f8                	mov    %edi,%eax
801019ae:	5e                   	pop    %esi
801019af:	5f                   	pop    %edi
801019b0:	5d                   	pop    %ebp
801019b1:	c3                   	ret    
  panic("bmap: out of range");
801019b2:	83 ec 0c             	sub    $0xc,%esp
801019b5:	68 98 7b 10 80       	push   $0x80107b98
801019ba:	e8 c1 e9 ff ff       	call   80100380 <panic>
801019bf:	90                   	nop

801019c0 <readsb>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	56                   	push   %esi
801019c4:	53                   	push   %ebx
801019c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801019c8:	83 ec 08             	sub    $0x8,%esp
801019cb:	6a 01                	push   $0x1
801019cd:	ff 75 08             	push   0x8(%ebp)
801019d0:	e8 fb e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801019d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801019d8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801019da:	8d 40 5c             	lea    0x5c(%eax),%eax
801019dd:	6a 1c                	push   $0x1c
801019df:	50                   	push   %eax
801019e0:	56                   	push   %esi
801019e1:	e8 5a 35 00 00       	call   80104f40 <memmove>
  brelse(bp);
801019e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019e9:	83 c4 10             	add    $0x10,%esp
}
801019ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019ef:	5b                   	pop    %ebx
801019f0:	5e                   	pop    %esi
801019f1:	5d                   	pop    %ebp
  brelse(bp);
801019f2:	e9 f9 e7 ff ff       	jmp    801001f0 <brelse>
801019f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019fe:	66 90                	xchg   %ax,%ax

80101a00 <iinit>:
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	53                   	push   %ebx
80101a04:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101a09:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a0c:	68 ab 7b 10 80       	push   $0x80107bab
80101a11:	68 60 09 11 80       	push   $0x80110960
80101a16:	e8 f5 31 00 00       	call   80104c10 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a1b:	83 c4 10             	add    $0x10,%esp
80101a1e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a20:	83 ec 08             	sub    $0x8,%esp
80101a23:	68 b2 7b 10 80       	push   $0x80107bb2
80101a28:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a29:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a2f:	e8 ac 30 00 00       	call   80104ae0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
80101a3d:	75 e1                	jne    80101a20 <iinit+0x20>
  bp = bread(dev, 1);
80101a3f:	83 ec 08             	sub    $0x8,%esp
80101a42:	6a 01                	push   $0x1
80101a44:	ff 75 08             	push   0x8(%ebp)
80101a47:	e8 84 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a4c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a4f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a51:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a54:	6a 1c                	push   $0x1c
80101a56:	50                   	push   %eax
80101a57:	68 b4 25 11 80       	push   $0x801125b4
80101a5c:	e8 df 34 00 00       	call   80104f40 <memmove>
  brelse(bp);
80101a61:	89 1c 24             	mov    %ebx,(%esp)
80101a64:	e8 87 e7 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a69:	ff 35 cc 25 11 80    	push   0x801125cc
80101a6f:	ff 35 c8 25 11 80    	push   0x801125c8
80101a75:	ff 35 c4 25 11 80    	push   0x801125c4
80101a7b:	ff 35 c0 25 11 80    	push   0x801125c0
80101a81:	ff 35 bc 25 11 80    	push   0x801125bc
80101a87:	ff 35 b8 25 11 80    	push   0x801125b8
80101a8d:	ff 35 b4 25 11 80    	push   0x801125b4
80101a93:	68 18 7c 10 80       	push   $0x80107c18
80101a98:	e8 53 ec ff ff       	call   801006f0 <cprintf>
}
80101a9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101aa0:	83 c4 30             	add    $0x30,%esp
80101aa3:	c9                   	leave  
80101aa4:	c3                   	ret    
80101aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ab0 <ialloc>:
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101abc:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101ac3:	8b 75 08             	mov    0x8(%ebp),%esi
80101ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101ac9:	0f 86 91 00 00 00    	jbe    80101b60 <ialloc+0xb0>
80101acf:	bf 01 00 00 00       	mov    $0x1,%edi
80101ad4:	eb 21                	jmp    80101af7 <ialloc+0x47>
80101ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101add:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101ae0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101ae3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101ae6:	53                   	push   %ebx
80101ae7:	e8 04 e7 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101aec:	83 c4 10             	add    $0x10,%esp
80101aef:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101af5:	73 69                	jae    80101b60 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101af7:	89 f8                	mov    %edi,%eax
80101af9:	83 ec 08             	sub    $0x8,%esp
80101afc:	c1 e8 03             	shr    $0x3,%eax
80101aff:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101b05:	50                   	push   %eax
80101b06:	56                   	push   %esi
80101b07:	e8 c4 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b0c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b0f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b11:	89 f8                	mov    %edi,%eax
80101b13:	83 e0 07             	and    $0x7,%eax
80101b16:	c1 e0 06             	shl    $0x6,%eax
80101b19:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b1d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b21:	75 bd                	jne    80101ae0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b23:	83 ec 04             	sub    $0x4,%esp
80101b26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b29:	6a 40                	push   $0x40
80101b2b:	6a 00                	push   $0x0
80101b2d:	51                   	push   %ecx
80101b2e:	e8 6d 33 00 00       	call   80104ea0 <memset>
      dip->type = type;
80101b33:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b3a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b3d:	89 1c 24             	mov    %ebx,(%esp)
80101b40:	e8 9b 18 00 00       	call   801033e0 <log_write>
      brelse(bp);
80101b45:	89 1c 24             	mov    %ebx,(%esp)
80101b48:	e8 a3 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b4d:	83 c4 10             	add    $0x10,%esp
}
80101b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101b53:	89 fa                	mov    %edi,%edx
}
80101b55:	5b                   	pop    %ebx
      return iget(dev, inum);
80101b56:	89 f0                	mov    %esi,%eax
}
80101b58:	5e                   	pop    %esi
80101b59:	5f                   	pop    %edi
80101b5a:	5d                   	pop    %ebp
      return iget(dev, inum);
80101b5b:	e9 90 fc ff ff       	jmp    801017f0 <iget>
  panic("ialloc: no inodes");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 b8 7b 10 80       	push   $0x80107bb8
80101b68:	e8 13 e8 ff ff       	call   80100380 <panic>
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi

80101b70 <iupdate>:
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	56                   	push   %esi
80101b74:	53                   	push   %ebx
80101b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b78:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b7b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b7e:	83 ec 08             	sub    $0x8,%esp
80101b81:	c1 e8 03             	shr    $0x3,%eax
80101b84:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101b8a:	50                   	push   %eax
80101b8b:	ff 73 a4             	push   -0x5c(%ebx)
80101b8e:	e8 3d e5 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101b93:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101b97:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b9a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b9c:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101b9f:	83 e0 07             	and    $0x7,%eax
80101ba2:	c1 e0 06             	shl    $0x6,%eax
80101ba5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101ba9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101bac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bb0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101bb3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101bb7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101bbb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101bbf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101bc3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101bc7:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101bca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bcd:	6a 34                	push   $0x34
80101bcf:	53                   	push   %ebx
80101bd0:	50                   	push   %eax
80101bd1:	e8 6a 33 00 00       	call   80104f40 <memmove>
  log_write(bp);
80101bd6:	89 34 24             	mov    %esi,(%esp)
80101bd9:	e8 02 18 00 00       	call   801033e0 <log_write>
  brelse(bp);
80101bde:	89 75 08             	mov    %esi,0x8(%ebp)
80101be1:	83 c4 10             	add    $0x10,%esp
}
80101be4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101be7:	5b                   	pop    %ebx
80101be8:	5e                   	pop    %esi
80101be9:	5d                   	pop    %ebp
  brelse(bp);
80101bea:	e9 01 e6 ff ff       	jmp    801001f0 <brelse>
80101bef:	90                   	nop

80101bf0 <idup>:
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	53                   	push   %ebx
80101bf4:	83 ec 10             	sub    $0x10,%esp
80101bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101bfa:	68 60 09 11 80       	push   $0x80110960
80101bff:	e8 dc 31 00 00       	call   80104de0 <acquire>
  ip->ref++;
80101c04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c08:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101c0f:	e8 6c 31 00 00       	call   80104d80 <release>
}
80101c14:	89 d8                	mov    %ebx,%eax
80101c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c19:	c9                   	leave  
80101c1a:	c3                   	ret    
80101c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c1f:	90                   	nop

80101c20 <ilock>:
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	56                   	push   %esi
80101c24:	53                   	push   %ebx
80101c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c28:	85 db                	test   %ebx,%ebx
80101c2a:	0f 84 b7 00 00 00    	je     80101ce7 <ilock+0xc7>
80101c30:	8b 53 08             	mov    0x8(%ebx),%edx
80101c33:	85 d2                	test   %edx,%edx
80101c35:	0f 8e ac 00 00 00    	jle    80101ce7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c3b:	83 ec 0c             	sub    $0xc,%esp
80101c3e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101c41:	50                   	push   %eax
80101c42:	e8 d9 2e 00 00       	call   80104b20 <acquiresleep>
  if(ip->valid == 0){
80101c47:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101c4a:	83 c4 10             	add    $0x10,%esp
80101c4d:	85 c0                	test   %eax,%eax
80101c4f:	74 0f                	je     80101c60 <ilock+0x40>
}
80101c51:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c54:	5b                   	pop    %ebx
80101c55:	5e                   	pop    %esi
80101c56:	5d                   	pop    %ebp
80101c57:	c3                   	ret    
80101c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c5f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c60:	8b 43 04             	mov    0x4(%ebx),%eax
80101c63:	83 ec 08             	sub    $0x8,%esp
80101c66:	c1 e8 03             	shr    $0x3,%eax
80101c69:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101c6f:	50                   	push   %eax
80101c70:	ff 33                	push   (%ebx)
80101c72:	e8 59 e4 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c77:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c7a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c7c:	8b 43 04             	mov    0x4(%ebx),%eax
80101c7f:	83 e0 07             	and    $0x7,%eax
80101c82:	c1 e0 06             	shl    $0x6,%eax
80101c85:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101c89:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c8c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101c8f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101c93:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101c97:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101c9b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101c9f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ca3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ca7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101cab:	8b 50 fc             	mov    -0x4(%eax),%edx
80101cae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cb1:	6a 34                	push   $0x34
80101cb3:	50                   	push   %eax
80101cb4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101cb7:	50                   	push   %eax
80101cb8:	e8 83 32 00 00       	call   80104f40 <memmove>
    brelse(bp);
80101cbd:	89 34 24             	mov    %esi,(%esp)
80101cc0:	e8 2b e5 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101cc5:	83 c4 10             	add    $0x10,%esp
80101cc8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101ccd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101cd4:	0f 85 77 ff ff ff    	jne    80101c51 <ilock+0x31>
      panic("ilock: no type");
80101cda:	83 ec 0c             	sub    $0xc,%esp
80101cdd:	68 d0 7b 10 80       	push   $0x80107bd0
80101ce2:	e8 99 e6 ff ff       	call   80100380 <panic>
    panic("ilock");
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	68 ca 7b 10 80       	push   $0x80107bca
80101cef:	e8 8c e6 ff ff       	call   80100380 <panic>
80101cf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101cff:	90                   	nop

80101d00 <iunlock>:
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	56                   	push   %esi
80101d04:	53                   	push   %ebx
80101d05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d08:	85 db                	test   %ebx,%ebx
80101d0a:	74 28                	je     80101d34 <iunlock+0x34>
80101d0c:	83 ec 0c             	sub    $0xc,%esp
80101d0f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d12:	56                   	push   %esi
80101d13:	e8 a8 2e 00 00       	call   80104bc0 <holdingsleep>
80101d18:	83 c4 10             	add    $0x10,%esp
80101d1b:	85 c0                	test   %eax,%eax
80101d1d:	74 15                	je     80101d34 <iunlock+0x34>
80101d1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101d22:	85 c0                	test   %eax,%eax
80101d24:	7e 0e                	jle    80101d34 <iunlock+0x34>
  releasesleep(&ip->lock);
80101d26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d2c:	5b                   	pop    %ebx
80101d2d:	5e                   	pop    %esi
80101d2e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d2f:	e9 4c 2e 00 00       	jmp    80104b80 <releasesleep>
    panic("iunlock");
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 df 7b 10 80       	push   $0x80107bdf
80101d3c:	e8 3f e6 ff ff       	call   80100380 <panic>
80101d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d4f:	90                   	nop

80101d50 <iput>:
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 28             	sub    $0x28,%esp
80101d59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101d5c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101d5f:	57                   	push   %edi
80101d60:	e8 bb 2d 00 00       	call   80104b20 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101d65:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101d68:	83 c4 10             	add    $0x10,%esp
80101d6b:	85 d2                	test   %edx,%edx
80101d6d:	74 07                	je     80101d76 <iput+0x26>
80101d6f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101d74:	74 32                	je     80101da8 <iput+0x58>
  releasesleep(&ip->lock);
80101d76:	83 ec 0c             	sub    $0xc,%esp
80101d79:	57                   	push   %edi
80101d7a:	e8 01 2e 00 00       	call   80104b80 <releasesleep>
  acquire(&icache.lock);
80101d7f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101d86:	e8 55 30 00 00       	call   80104de0 <acquire>
  ip->ref--;
80101d8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101d8f:	83 c4 10             	add    $0x10,%esp
80101d92:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9c:	5b                   	pop    %ebx
80101d9d:	5e                   	pop    %esi
80101d9e:	5f                   	pop    %edi
80101d9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101da0:	e9 db 2f 00 00       	jmp    80104d80 <release>
80101da5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	68 60 09 11 80       	push   $0x80110960
80101db0:	e8 2b 30 00 00       	call   80104de0 <acquire>
    int r = ip->ref;
80101db5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101db8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dbf:	e8 bc 2f 00 00       	call   80104d80 <release>
    if(r == 1){
80101dc4:	83 c4 10             	add    $0x10,%esp
80101dc7:	83 fe 01             	cmp    $0x1,%esi
80101dca:	75 aa                	jne    80101d76 <iput+0x26>
80101dcc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101dd2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101dd5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101dd8:	89 cf                	mov    %ecx,%edi
80101dda:	eb 0b                	jmp    80101de7 <iput+0x97>
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101de0:	83 c6 04             	add    $0x4,%esi
80101de3:	39 fe                	cmp    %edi,%esi
80101de5:	74 19                	je     80101e00 <iput+0xb0>
    if(ip->addrs[i]){
80101de7:	8b 16                	mov    (%esi),%edx
80101de9:	85 d2                	test   %edx,%edx
80101deb:	74 f3                	je     80101de0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101ded:	8b 03                	mov    (%ebx),%eax
80101def:	e8 6c f8 ff ff       	call   80101660 <bfree>
      ip->addrs[i] = 0;
80101df4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101dfa:	eb e4                	jmp    80101de0 <iput+0x90>
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e00:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e09:	85 c0                	test   %eax,%eax
80101e0b:	75 2d                	jne    80101e3a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e0d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e10:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e17:	53                   	push   %ebx
80101e18:	e8 53 fd ff ff       	call   80101b70 <iupdate>
      ip->type = 0;
80101e1d:	31 c0                	xor    %eax,%eax
80101e1f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e23:	89 1c 24             	mov    %ebx,(%esp)
80101e26:	e8 45 fd ff ff       	call   80101b70 <iupdate>
      ip->valid = 0;
80101e2b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e32:	83 c4 10             	add    $0x10,%esp
80101e35:	e9 3c ff ff ff       	jmp    80101d76 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e3a:	83 ec 08             	sub    $0x8,%esp
80101e3d:	50                   	push   %eax
80101e3e:	ff 33                	push   (%ebx)
80101e40:	e8 8b e2 ff ff       	call   801000d0 <bread>
80101e45:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101e48:	83 c4 10             	add    $0x10,%esp
80101e4b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101e51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e54:	8d 70 5c             	lea    0x5c(%eax),%esi
80101e57:	89 cf                	mov    %ecx,%edi
80101e59:	eb 0c                	jmp    80101e67 <iput+0x117>
80101e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e5f:	90                   	nop
80101e60:	83 c6 04             	add    $0x4,%esi
80101e63:	39 f7                	cmp    %esi,%edi
80101e65:	74 0f                	je     80101e76 <iput+0x126>
      if(a[j])
80101e67:	8b 16                	mov    (%esi),%edx
80101e69:	85 d2                	test   %edx,%edx
80101e6b:	74 f3                	je     80101e60 <iput+0x110>
        bfree(ip->dev, a[j]);
80101e6d:	8b 03                	mov    (%ebx),%eax
80101e6f:	e8 ec f7 ff ff       	call   80101660 <bfree>
80101e74:	eb ea                	jmp    80101e60 <iput+0x110>
    brelse(bp);
80101e76:	83 ec 0c             	sub    $0xc,%esp
80101e79:	ff 75 e4             	push   -0x1c(%ebp)
80101e7c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e7f:	e8 6c e3 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e84:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101e8a:	8b 03                	mov    (%ebx),%eax
80101e8c:	e8 cf f7 ff ff       	call   80101660 <bfree>
    ip->addrs[NDIRECT] = 0;
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101e9b:	00 00 00 
80101e9e:	e9 6a ff ff ff       	jmp    80101e0d <iput+0xbd>
80101ea3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101eb0 <iunlockput>:
{
80101eb0:	55                   	push   %ebp
80101eb1:	89 e5                	mov    %esp,%ebp
80101eb3:	56                   	push   %esi
80101eb4:	53                   	push   %ebx
80101eb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101eb8:	85 db                	test   %ebx,%ebx
80101eba:	74 34                	je     80101ef0 <iunlockput+0x40>
80101ebc:	83 ec 0c             	sub    $0xc,%esp
80101ebf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ec2:	56                   	push   %esi
80101ec3:	e8 f8 2c 00 00       	call   80104bc0 <holdingsleep>
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	85 c0                	test   %eax,%eax
80101ecd:	74 21                	je     80101ef0 <iunlockput+0x40>
80101ecf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ed2:	85 c0                	test   %eax,%eax
80101ed4:	7e 1a                	jle    80101ef0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ed6:	83 ec 0c             	sub    $0xc,%esp
80101ed9:	56                   	push   %esi
80101eda:	e8 a1 2c 00 00       	call   80104b80 <releasesleep>
  iput(ip);
80101edf:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ee2:	83 c4 10             	add    $0x10,%esp
}
80101ee5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ee8:	5b                   	pop    %ebx
80101ee9:	5e                   	pop    %esi
80101eea:	5d                   	pop    %ebp
  iput(ip);
80101eeb:	e9 60 fe ff ff       	jmp    80101d50 <iput>
    panic("iunlock");
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	68 df 7b 10 80       	push   $0x80107bdf
80101ef8:	e8 83 e4 ff ff       	call   80100380 <panic>
80101efd:	8d 76 00             	lea    0x0(%esi),%esi

80101f00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	8b 55 08             	mov    0x8(%ebp),%edx
80101f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f09:	8b 0a                	mov    (%edx),%ecx
80101f0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f23:	8b 52 58             	mov    0x58(%edx),%edx
80101f26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f29:	5d                   	pop    %ebp
80101f2a:	c3                   	ret    
80101f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop

80101f30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3f:	8b 75 10             	mov    0x10(%ebp),%esi
80101f42:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f45:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f48:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101f4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101f50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101f53:	0f 84 a7 00 00 00    	je     80102000 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101f59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101f5c:	8b 40 58             	mov    0x58(%eax),%eax
80101f5f:	39 c6                	cmp    %eax,%esi
80101f61:	0f 87 ba 00 00 00    	ja     80102021 <readi+0xf1>
80101f67:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101f6a:	31 c9                	xor    %ecx,%ecx
80101f6c:	89 da                	mov    %ebx,%edx
80101f6e:	01 f2                	add    %esi,%edx
80101f70:	0f 92 c1             	setb   %cl
80101f73:	89 cf                	mov    %ecx,%edi
80101f75:	0f 82 a6 00 00 00    	jb     80102021 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101f7b:	89 c1                	mov    %eax,%ecx
80101f7d:	29 f1                	sub    %esi,%ecx
80101f7f:	39 d0                	cmp    %edx,%eax
80101f81:	0f 43 cb             	cmovae %ebx,%ecx
80101f84:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f87:	85 c9                	test   %ecx,%ecx
80101f89:	74 67                	je     80101ff2 <readi+0xc2>
80101f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f8f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101f93:	89 f2                	mov    %esi,%edx
80101f95:	c1 ea 09             	shr    $0x9,%edx
80101f98:	89 d8                	mov    %ebx,%eax
80101f9a:	e8 51 f9 ff ff       	call   801018f0 <bmap>
80101f9f:	83 ec 08             	sub    $0x8,%esp
80101fa2:	50                   	push   %eax
80101fa3:	ff 33                	push   (%ebx)
80101fa5:	e8 26 e1 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101faa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fad:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fb2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101fb4:	89 f0                	mov    %esi,%eax
80101fb6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fbb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fbd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101fc2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101fc6:	39 d9                	cmp    %ebx,%ecx
80101fc8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101fcb:	83 c4 0c             	add    $0xc,%esp
80101fce:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fcf:	01 df                	add    %ebx,%edi
80101fd1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101fd3:	50                   	push   %eax
80101fd4:	ff 75 e0             	push   -0x20(%ebp)
80101fd7:	e8 64 2f 00 00       	call   80104f40 <memmove>
    brelse(bp);
80101fdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101fdf:	89 14 24             	mov    %edx,(%esp)
80101fe2:	e8 09 e2 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fe7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ff0:	77 9e                	ja     80101f90 <readi+0x60>
  }
  return n;
80101ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
80101ffd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102000:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102004:	66 83 f8 09          	cmp    $0x9,%ax
80102008:	77 17                	ja     80102021 <readi+0xf1>
8010200a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80102011:	85 c0                	test   %eax,%eax
80102013:	74 0c                	je     80102021 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102015:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102018:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010201b:	5b                   	pop    %ebx
8010201c:	5e                   	pop    %esi
8010201d:	5f                   	pop    %edi
8010201e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010201f:	ff e0                	jmp    *%eax
      return -1;
80102021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102026:	eb cd                	jmp    80101ff5 <readi+0xc5>
80102028:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010202f:	90                   	nop

80102030 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 1c             	sub    $0x1c,%esp
80102039:	8b 45 08             	mov    0x8(%ebp),%eax
8010203c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010203f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102042:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80102047:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010204a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010204d:	8b 75 10             	mov    0x10(%ebp),%esi
80102050:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80102053:	0f 84 b7 00 00 00    	je     80102110 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80102059:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010205c:	3b 70 58             	cmp    0x58(%eax),%esi
8010205f:	0f 87 e7 00 00 00    	ja     8010214c <writei+0x11c>
80102065:	8b 7d e0             	mov    -0x20(%ebp),%edi
80102068:	31 d2                	xor    %edx,%edx
8010206a:	89 f8                	mov    %edi,%eax
8010206c:	01 f0                	add    %esi,%eax
8010206e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102071:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102076:	0f 87 d0 00 00 00    	ja     8010214c <writei+0x11c>
8010207c:	85 d2                	test   %edx,%edx
8010207e:	0f 85 c8 00 00 00    	jne    8010214c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102084:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010208b:	85 ff                	test   %edi,%edi
8010208d:	74 72                	je     80102101 <writei+0xd1>
8010208f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102090:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102093:	89 f2                	mov    %esi,%edx
80102095:	c1 ea 09             	shr    $0x9,%edx
80102098:	89 f8                	mov    %edi,%eax
8010209a:	e8 51 f8 ff ff       	call   801018f0 <bmap>
8010209f:	83 ec 08             	sub    $0x8,%esp
801020a2:	50                   	push   %eax
801020a3:	ff 37                	push   (%edi)
801020a5:	e8 26 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020aa:	b9 00 02 00 00       	mov    $0x200,%ecx
801020af:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801020b2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020b5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801020b7:	89 f0                	mov    %esi,%eax
801020b9:	25 ff 01 00 00       	and    $0x1ff,%eax
801020be:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
801020c0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801020c4:	39 d9                	cmp    %ebx,%ecx
801020c6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801020c9:	83 c4 0c             	add    $0xc,%esp
801020cc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020cd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
801020cf:	ff 75 dc             	push   -0x24(%ebp)
801020d2:	50                   	push   %eax
801020d3:	e8 68 2e 00 00       	call   80104f40 <memmove>
    log_write(bp);
801020d8:	89 3c 24             	mov    %edi,(%esp)
801020db:	e8 00 13 00 00       	call   801033e0 <log_write>
    brelse(bp);
801020e0:	89 3c 24             	mov    %edi,(%esp)
801020e3:	e8 08 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020e8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801020eb:	83 c4 10             	add    $0x10,%esp
801020ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020f1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801020f4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
801020f7:	77 97                	ja     80102090 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
801020f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020fc:	3b 70 58             	cmp    0x58(%eax),%esi
801020ff:	77 37                	ja     80102138 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102101:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102104:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102107:	5b                   	pop    %ebx
80102108:	5e                   	pop    %esi
80102109:	5f                   	pop    %edi
8010210a:	5d                   	pop    %ebp
8010210b:	c3                   	ret    
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102110:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102114:	66 83 f8 09          	cmp    $0x9,%ax
80102118:	77 32                	ja     8010214c <writei+0x11c>
8010211a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80102121:	85 c0                	test   %eax,%eax
80102123:	74 27                	je     8010214c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102125:	89 55 10             	mov    %edx,0x10(%ebp)
}
80102128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010212b:	5b                   	pop    %ebx
8010212c:	5e                   	pop    %esi
8010212d:	5f                   	pop    %edi
8010212e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010212f:	ff e0                	jmp    *%eax
80102131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102138:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010213b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010213e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102141:	50                   	push   %eax
80102142:	e8 29 fa ff ff       	call   80101b70 <iupdate>
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	eb b5                	jmp    80102101 <writei+0xd1>
      return -1;
8010214c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102151:	eb b1                	jmp    80102104 <writei+0xd4>
80102153:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010215a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102160 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80102166:	6a 0e                	push   $0xe
80102168:	ff 75 0c             	push   0xc(%ebp)
8010216b:	ff 75 08             	push   0x8(%ebp)
8010216e:	e8 3d 2e 00 00       	call   80104fb0 <strncmp>
}
80102173:	c9                   	leave  
80102174:	c3                   	ret    
80102175:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102180 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	57                   	push   %edi
80102184:	56                   	push   %esi
80102185:	53                   	push   %ebx
80102186:	83 ec 1c             	sub    $0x1c,%esp
80102189:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010218c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102191:	0f 85 85 00 00 00    	jne    8010221c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102197:	8b 53 58             	mov    0x58(%ebx),%edx
8010219a:	31 ff                	xor    %edi,%edi
8010219c:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010219f:	85 d2                	test   %edx,%edx
801021a1:	74 3e                	je     801021e1 <dirlookup+0x61>
801021a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021a8:	6a 10                	push   $0x10
801021aa:	57                   	push   %edi
801021ab:	56                   	push   %esi
801021ac:	53                   	push   %ebx
801021ad:	e8 7e fd ff ff       	call   80101f30 <readi>
801021b2:	83 c4 10             	add    $0x10,%esp
801021b5:	83 f8 10             	cmp    $0x10,%eax
801021b8:	75 55                	jne    8010220f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
801021ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021bf:	74 18                	je     801021d9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
801021c1:	83 ec 04             	sub    $0x4,%esp
801021c4:	8d 45 da             	lea    -0x26(%ebp),%eax
801021c7:	6a 0e                	push   $0xe
801021c9:	50                   	push   %eax
801021ca:	ff 75 0c             	push   0xc(%ebp)
801021cd:	e8 de 2d 00 00       	call   80104fb0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	85 c0                	test   %eax,%eax
801021d7:	74 17                	je     801021f0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021d9:	83 c7 10             	add    $0x10,%edi
801021dc:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021df:	72 c7                	jb     801021a8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
801021e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801021e4:	31 c0                	xor    %eax,%eax
}
801021e6:	5b                   	pop    %ebx
801021e7:	5e                   	pop    %esi
801021e8:	5f                   	pop    %edi
801021e9:	5d                   	pop    %ebp
801021ea:	c3                   	ret    
801021eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop
      if(poff)
801021f0:	8b 45 10             	mov    0x10(%ebp),%eax
801021f3:	85 c0                	test   %eax,%eax
801021f5:	74 05                	je     801021fc <dirlookup+0x7c>
        *poff = off;
801021f7:	8b 45 10             	mov    0x10(%ebp),%eax
801021fa:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801021fc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102200:	8b 03                	mov    (%ebx),%eax
80102202:	e8 e9 f5 ff ff       	call   801017f0 <iget>
}
80102207:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010220a:	5b                   	pop    %ebx
8010220b:	5e                   	pop    %esi
8010220c:	5f                   	pop    %edi
8010220d:	5d                   	pop    %ebp
8010220e:	c3                   	ret    
      panic("dirlookup read");
8010220f:	83 ec 0c             	sub    $0xc,%esp
80102212:	68 f9 7b 10 80       	push   $0x80107bf9
80102217:	e8 64 e1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010221c:	83 ec 0c             	sub    $0xc,%esp
8010221f:	68 e7 7b 10 80       	push   $0x80107be7
80102224:	e8 57 e1 ff ff       	call   80100380 <panic>
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	89 c3                	mov    %eax,%ebx
80102238:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010223b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010223e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102241:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80102244:	0f 84 64 01 00 00    	je     801023ae <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
8010224a:	e8 c1 1b 00 00       	call   80103e10 <myproc>
  acquire(&icache.lock);
8010224f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102252:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102255:	68 60 09 11 80       	push   $0x80110960
8010225a:	e8 81 2b 00 00       	call   80104de0 <acquire>
  ip->ref++;
8010225f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102263:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010226a:	e8 11 2b 00 00       	call   80104d80 <release>
8010226f:	83 c4 10             	add    $0x10,%esp
80102272:	eb 07                	jmp    8010227b <namex+0x4b>
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102278:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010227b:	0f b6 03             	movzbl (%ebx),%eax
8010227e:	3c 2f                	cmp    $0x2f,%al
80102280:	74 f6                	je     80102278 <namex+0x48>
  if(*path == 0)
80102282:	84 c0                	test   %al,%al
80102284:	0f 84 06 01 00 00    	je     80102390 <namex+0x160>
  while(*path != '/' && *path != 0)
8010228a:	0f b6 03             	movzbl (%ebx),%eax
8010228d:	84 c0                	test   %al,%al
8010228f:	0f 84 10 01 00 00    	je     801023a5 <namex+0x175>
80102295:	89 df                	mov    %ebx,%edi
80102297:	3c 2f                	cmp    $0x2f,%al
80102299:	0f 84 06 01 00 00    	je     801023a5 <namex+0x175>
8010229f:	90                   	nop
801022a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
801022a4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
801022a7:	3c 2f                	cmp    $0x2f,%al
801022a9:	74 04                	je     801022af <namex+0x7f>
801022ab:	84 c0                	test   %al,%al
801022ad:	75 f1                	jne    801022a0 <namex+0x70>
  len = path - s;
801022af:	89 f8                	mov    %edi,%eax
801022b1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
801022b3:	83 f8 0d             	cmp    $0xd,%eax
801022b6:	0f 8e ac 00 00 00    	jle    80102368 <namex+0x138>
    memmove(name, s, DIRSIZ);
801022bc:	83 ec 04             	sub    $0x4,%esp
801022bf:	6a 0e                	push   $0xe
801022c1:	53                   	push   %ebx
    path++;
801022c2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
801022c4:	ff 75 e4             	push   -0x1c(%ebp)
801022c7:	e8 74 2c 00 00       	call   80104f40 <memmove>
801022cc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
801022cf:	80 3f 2f             	cmpb   $0x2f,(%edi)
801022d2:	75 0c                	jne    801022e0 <namex+0xb0>
801022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
801022d8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801022db:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801022de:	74 f8                	je     801022d8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801022e0:	83 ec 0c             	sub    $0xc,%esp
801022e3:	56                   	push   %esi
801022e4:	e8 37 f9 ff ff       	call   80101c20 <ilock>
    if(ip->type != T_DIR){
801022e9:	83 c4 10             	add    $0x10,%esp
801022ec:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801022f1:	0f 85 cd 00 00 00    	jne    801023c4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801022f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801022fa:	85 c0                	test   %eax,%eax
801022fc:	74 09                	je     80102307 <namex+0xd7>
801022fe:	80 3b 00             	cmpb   $0x0,(%ebx)
80102301:	0f 84 22 01 00 00    	je     80102429 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	6a 00                	push   $0x0
8010230c:	ff 75 e4             	push   -0x1c(%ebp)
8010230f:	56                   	push   %esi
80102310:	e8 6b fe ff ff       	call   80102180 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102315:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80102318:	83 c4 10             	add    $0x10,%esp
8010231b:	89 c7                	mov    %eax,%edi
8010231d:	85 c0                	test   %eax,%eax
8010231f:	0f 84 e1 00 00 00    	je     80102406 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102325:	83 ec 0c             	sub    $0xc,%esp
80102328:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010232b:	52                   	push   %edx
8010232c:	e8 8f 28 00 00       	call   80104bc0 <holdingsleep>
80102331:	83 c4 10             	add    $0x10,%esp
80102334:	85 c0                	test   %eax,%eax
80102336:	0f 84 30 01 00 00    	je     8010246c <namex+0x23c>
8010233c:	8b 56 08             	mov    0x8(%esi),%edx
8010233f:	85 d2                	test   %edx,%edx
80102341:	0f 8e 25 01 00 00    	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
80102347:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010234a:	83 ec 0c             	sub    $0xc,%esp
8010234d:	52                   	push   %edx
8010234e:	e8 2d 28 00 00       	call   80104b80 <releasesleep>
  iput(ip);
80102353:	89 34 24             	mov    %esi,(%esp)
80102356:	89 fe                	mov    %edi,%esi
80102358:	e8 f3 f9 ff ff       	call   80101d50 <iput>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	e9 16 ff ff ff       	jmp    8010227b <namex+0x4b>
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80102368:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010236b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
8010236e:	83 ec 04             	sub    $0x4,%esp
80102371:	89 55 e0             	mov    %edx,-0x20(%ebp)
80102374:	50                   	push   %eax
80102375:	53                   	push   %ebx
    name[len] = 0;
80102376:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80102378:	ff 75 e4             	push   -0x1c(%ebp)
8010237b:	e8 c0 2b 00 00       	call   80104f40 <memmove>
    name[len] = 0;
80102380:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102383:	83 c4 10             	add    $0x10,%esp
80102386:	c6 02 00             	movb   $0x0,(%edx)
80102389:	e9 41 ff ff ff       	jmp    801022cf <namex+0x9f>
8010238e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102390:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102393:	85 c0                	test   %eax,%eax
80102395:	0f 85 be 00 00 00    	jne    80102459 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010239b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010239e:	89 f0                	mov    %esi,%eax
801023a0:	5b                   	pop    %ebx
801023a1:	5e                   	pop    %esi
801023a2:	5f                   	pop    %edi
801023a3:	5d                   	pop    %ebp
801023a4:	c3                   	ret    
  while(*path != '/' && *path != 0)
801023a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801023a8:	89 df                	mov    %ebx,%edi
801023aa:	31 c0                	xor    %eax,%eax
801023ac:	eb c0                	jmp    8010236e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
801023ae:	ba 01 00 00 00       	mov    $0x1,%edx
801023b3:	b8 01 00 00 00       	mov    $0x1,%eax
801023b8:	e8 33 f4 ff ff       	call   801017f0 <iget>
801023bd:	89 c6                	mov    %eax,%esi
801023bf:	e9 b7 fe ff ff       	jmp    8010227b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	8d 5e 0c             	lea    0xc(%esi),%ebx
801023ca:	53                   	push   %ebx
801023cb:	e8 f0 27 00 00       	call   80104bc0 <holdingsleep>
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	85 c0                	test   %eax,%eax
801023d5:	0f 84 91 00 00 00    	je     8010246c <namex+0x23c>
801023db:	8b 46 08             	mov    0x8(%esi),%eax
801023de:	85 c0                	test   %eax,%eax
801023e0:	0f 8e 86 00 00 00    	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
801023e6:	83 ec 0c             	sub    $0xc,%esp
801023e9:	53                   	push   %ebx
801023ea:	e8 91 27 00 00       	call   80104b80 <releasesleep>
  iput(ip);
801023ef:	89 34 24             	mov    %esi,(%esp)
      return 0;
801023f2:	31 f6                	xor    %esi,%esi
  iput(ip);
801023f4:	e8 57 f9 ff ff       	call   80101d50 <iput>
      return 0;
801023f9:	83 c4 10             	add    $0x10,%esp
}
801023fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ff:	89 f0                	mov    %esi,%eax
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5f                   	pop    %edi
80102404:	5d                   	pop    %ebp
80102405:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102406:	83 ec 0c             	sub    $0xc,%esp
80102409:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010240c:	52                   	push   %edx
8010240d:	e8 ae 27 00 00       	call   80104bc0 <holdingsleep>
80102412:	83 c4 10             	add    $0x10,%esp
80102415:	85 c0                	test   %eax,%eax
80102417:	74 53                	je     8010246c <namex+0x23c>
80102419:	8b 4e 08             	mov    0x8(%esi),%ecx
8010241c:	85 c9                	test   %ecx,%ecx
8010241e:	7e 4c                	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
80102420:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102423:	83 ec 0c             	sub    $0xc,%esp
80102426:	52                   	push   %edx
80102427:	eb c1                	jmp    801023ea <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102429:	83 ec 0c             	sub    $0xc,%esp
8010242c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010242f:	53                   	push   %ebx
80102430:	e8 8b 27 00 00       	call   80104bc0 <holdingsleep>
80102435:	83 c4 10             	add    $0x10,%esp
80102438:	85 c0                	test   %eax,%eax
8010243a:	74 30                	je     8010246c <namex+0x23c>
8010243c:	8b 7e 08             	mov    0x8(%esi),%edi
8010243f:	85 ff                	test   %edi,%edi
80102441:	7e 29                	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
80102443:	83 ec 0c             	sub    $0xc,%esp
80102446:	53                   	push   %ebx
80102447:	e8 34 27 00 00       	call   80104b80 <releasesleep>
}
8010244c:	83 c4 10             	add    $0x10,%esp
}
8010244f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102452:	89 f0                	mov    %esi,%eax
80102454:	5b                   	pop    %ebx
80102455:	5e                   	pop    %esi
80102456:	5f                   	pop    %edi
80102457:	5d                   	pop    %ebp
80102458:	c3                   	ret    
    iput(ip);
80102459:	83 ec 0c             	sub    $0xc,%esp
8010245c:	56                   	push   %esi
    return 0;
8010245d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010245f:	e8 ec f8 ff ff       	call   80101d50 <iput>
    return 0;
80102464:	83 c4 10             	add    $0x10,%esp
80102467:	e9 2f ff ff ff       	jmp    8010239b <namex+0x16b>
    panic("iunlock");
8010246c:	83 ec 0c             	sub    $0xc,%esp
8010246f:	68 df 7b 10 80       	push   $0x80107bdf
80102474:	e8 07 df ff ff       	call   80100380 <panic>
80102479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102480 <dirlink>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	57                   	push   %edi
80102484:	56                   	push   %esi
80102485:	53                   	push   %ebx
80102486:	83 ec 20             	sub    $0x20,%esp
80102489:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010248c:	6a 00                	push   $0x0
8010248e:	ff 75 0c             	push   0xc(%ebp)
80102491:	53                   	push   %ebx
80102492:	e8 e9 fc ff ff       	call   80102180 <dirlookup>
80102497:	83 c4 10             	add    $0x10,%esp
8010249a:	85 c0                	test   %eax,%eax
8010249c:	75 67                	jne    80102505 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010249e:	8b 7b 58             	mov    0x58(%ebx),%edi
801024a1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024a4:	85 ff                	test   %edi,%edi
801024a6:	74 29                	je     801024d1 <dirlink+0x51>
801024a8:	31 ff                	xor    %edi,%edi
801024aa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024ad:	eb 09                	jmp    801024b8 <dirlink+0x38>
801024af:	90                   	nop
801024b0:	83 c7 10             	add    $0x10,%edi
801024b3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024b6:	73 19                	jae    801024d1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b8:	6a 10                	push   $0x10
801024ba:	57                   	push   %edi
801024bb:	56                   	push   %esi
801024bc:	53                   	push   %ebx
801024bd:	e8 6e fa ff ff       	call   80101f30 <readi>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	83 f8 10             	cmp    $0x10,%eax
801024c8:	75 4e                	jne    80102518 <dirlink+0x98>
    if(de.inum == 0)
801024ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024cf:	75 df                	jne    801024b0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801024d1:	83 ec 04             	sub    $0x4,%esp
801024d4:	8d 45 da             	lea    -0x26(%ebp),%eax
801024d7:	6a 0e                	push   $0xe
801024d9:	ff 75 0c             	push   0xc(%ebp)
801024dc:	50                   	push   %eax
801024dd:	e8 1e 2b 00 00       	call   80105000 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024e2:	6a 10                	push   $0x10
  de.inum = inum;
801024e4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024e7:	57                   	push   %edi
801024e8:	56                   	push   %esi
801024e9:	53                   	push   %ebx
  de.inum = inum;
801024ea:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024ee:	e8 3d fb ff ff       	call   80102030 <writei>
801024f3:	83 c4 20             	add    $0x20,%esp
801024f6:	83 f8 10             	cmp    $0x10,%eax
801024f9:	75 2a                	jne    80102525 <dirlink+0xa5>
  return 0;
801024fb:	31 c0                	xor    %eax,%eax
}
801024fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102500:	5b                   	pop    %ebx
80102501:	5e                   	pop    %esi
80102502:	5f                   	pop    %edi
80102503:	5d                   	pop    %ebp
80102504:	c3                   	ret    
    iput(ip);
80102505:	83 ec 0c             	sub    $0xc,%esp
80102508:	50                   	push   %eax
80102509:	e8 42 f8 ff ff       	call   80101d50 <iput>
    return -1;
8010250e:	83 c4 10             	add    $0x10,%esp
80102511:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102516:	eb e5                	jmp    801024fd <dirlink+0x7d>
      panic("dirlink read");
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	68 08 7c 10 80       	push   $0x80107c08
80102520:	e8 5b de ff ff       	call   80100380 <panic>
    panic("dirlink");
80102525:	83 ec 0c             	sub    $0xc,%esp
80102528:	68 ee 81 10 80       	push   $0x801081ee
8010252d:	e8 4e de ff ff       	call   80100380 <panic>
80102532:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102540 <namei>:

struct inode*
namei(char *path)
{
80102540:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102541:	31 d2                	xor    %edx,%edx
{
80102543:	89 e5                	mov    %esp,%ebp
80102545:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102548:	8b 45 08             	mov    0x8(%ebp),%eax
8010254b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010254e:	e8 dd fc ff ff       	call   80102230 <namex>
}
80102553:	c9                   	leave  
80102554:	c3                   	ret    
80102555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102560 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102560:	55                   	push   %ebp
  return namex(path, 1, name);
80102561:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102566:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102568:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010256b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010256e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010256f:	e9 bc fc ff ff       	jmp    80102230 <namex>
80102574:	66 90                	xchg   %ax,%ax
80102576:	66 90                	xchg   %ax,%ax
80102578:	66 90                	xchg   %ax,%ax
8010257a:	66 90                	xchg   %ax,%ax
8010257c:	66 90                	xchg   %ax,%ax
8010257e:	66 90                	xchg   %ax,%ax

80102580 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	57                   	push   %edi
80102584:	56                   	push   %esi
80102585:	53                   	push   %ebx
80102586:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102589:	85 c0                	test   %eax,%eax
8010258b:	0f 84 b4 00 00 00    	je     80102645 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102591:	8b 70 08             	mov    0x8(%eax),%esi
80102594:	89 c3                	mov    %eax,%ebx
80102596:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010259c:	0f 87 96 00 00 00    	ja     80102638 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ae:	66 90                	xchg   %ax,%ax
801025b0:	89 ca                	mov    %ecx,%edx
801025b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025b3:	83 e0 c0             	and    $0xffffffc0,%eax
801025b6:	3c 40                	cmp    $0x40,%al
801025b8:	75 f6                	jne    801025b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ba:	31 ff                	xor    %edi,%edi
801025bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025c1:	89 f8                	mov    %edi,%eax
801025c3:	ee                   	out    %al,(%dx)
801025c4:	b8 01 00 00 00       	mov    $0x1,%eax
801025c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025ce:	ee                   	out    %al,(%dx)
801025cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025d4:	89 f0                	mov    %esi,%eax
801025d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025d7:	89 f0                	mov    %esi,%eax
801025d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025de:	c1 f8 08             	sar    $0x8,%eax
801025e1:	ee                   	out    %al,(%dx)
801025e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025e7:	89 f8                	mov    %edi,%eax
801025e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801025ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025f3:	c1 e0 04             	shl    $0x4,%eax
801025f6:	83 e0 10             	and    $0x10,%eax
801025f9:	83 c8 e0             	or     $0xffffffe0,%eax
801025fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025fd:	f6 03 04             	testb  $0x4,(%ebx)
80102600:	75 16                	jne    80102618 <idestart+0x98>
80102602:	b8 20 00 00 00       	mov    $0x20,%eax
80102607:	89 ca                	mov    %ecx,%edx
80102609:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010260a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010260d:	5b                   	pop    %ebx
8010260e:	5e                   	pop    %esi
8010260f:	5f                   	pop    %edi
80102610:	5d                   	pop    %ebp
80102611:	c3                   	ret    
80102612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102618:	b8 30 00 00 00       	mov    $0x30,%eax
8010261d:	89 ca                	mov    %ecx,%edx
8010261f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102620:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102625:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102628:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010262d:	fc                   	cld    
8010262e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102630:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102633:	5b                   	pop    %ebx
80102634:	5e                   	pop    %esi
80102635:	5f                   	pop    %edi
80102636:	5d                   	pop    %ebp
80102637:	c3                   	ret    
    panic("incorrect blockno");
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	68 74 7c 10 80       	push   $0x80107c74
80102640:	e8 3b dd ff ff       	call   80100380 <panic>
    panic("idestart");
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	68 6b 7c 10 80       	push   $0x80107c6b
8010264d:	e8 2e dd ff ff       	call   80100380 <panic>
80102652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102660 <ideinit>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102666:	68 86 7c 10 80       	push   $0x80107c86
8010266b:	68 00 26 11 80       	push   $0x80112600
80102670:	e8 9b 25 00 00       	call   80104c10 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102675:	58                   	pop    %eax
80102676:	a1 84 27 11 80       	mov    0x80112784,%eax
8010267b:	5a                   	pop    %edx
8010267c:	83 e8 01             	sub    $0x1,%eax
8010267f:	50                   	push   %eax
80102680:	6a 0e                	push   $0xe
80102682:	e8 99 02 00 00       	call   80102920 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102687:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010268a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010268f:	90                   	nop
80102690:	ec                   	in     (%dx),%al
80102691:	83 e0 c0             	and    $0xffffffc0,%eax
80102694:	3c 40                	cmp    $0x40,%al
80102696:	75 f8                	jne    80102690 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102698:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010269d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026a2:	ee                   	out    %al,(%dx)
801026a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026ad:	eb 06                	jmp    801026b5 <ideinit+0x55>
801026af:	90                   	nop
  for(i=0; i<1000; i++){
801026b0:	83 e9 01             	sub    $0x1,%ecx
801026b3:	74 0f                	je     801026c4 <ideinit+0x64>
801026b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026b6:	84 c0                	test   %al,%al
801026b8:	74 f6                	je     801026b0 <ideinit+0x50>
      havedisk1 = 1;
801026ba:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
801026c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026ce:	ee                   	out    %al,(%dx)
}
801026cf:	c9                   	leave  
801026d0:	c3                   	ret    
801026d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026df:	90                   	nop

801026e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	57                   	push   %edi
801026e4:	56                   	push   %esi
801026e5:	53                   	push   %ebx
801026e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026e9:	68 00 26 11 80       	push   $0x80112600
801026ee:	e8 ed 26 00 00       	call   80104de0 <acquire>

  if((b = idequeue) == 0){
801026f3:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
801026f9:	83 c4 10             	add    $0x10,%esp
801026fc:	85 db                	test   %ebx,%ebx
801026fe:	74 63                	je     80102763 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102700:	8b 43 58             	mov    0x58(%ebx),%eax
80102703:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102708:	8b 33                	mov    (%ebx),%esi
8010270a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102710:	75 2f                	jne    80102741 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102712:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271e:	66 90                	xchg   %ax,%ax
80102720:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102721:	89 c1                	mov    %eax,%ecx
80102723:	83 e1 c0             	and    $0xffffffc0,%ecx
80102726:	80 f9 40             	cmp    $0x40,%cl
80102729:	75 f5                	jne    80102720 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010272b:	a8 21                	test   $0x21,%al
8010272d:	75 12                	jne    80102741 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010272f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102732:	b9 80 00 00 00       	mov    $0x80,%ecx
80102737:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010273c:	fc                   	cld    
8010273d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010273f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102741:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102744:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102747:	83 ce 02             	or     $0x2,%esi
8010274a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010274c:	53                   	push   %ebx
8010274d:	e8 4e 1e 00 00       	call   801045a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102752:	a1 e4 25 11 80       	mov    0x801125e4,%eax
80102757:	83 c4 10             	add    $0x10,%esp
8010275a:	85 c0                	test   %eax,%eax
8010275c:	74 05                	je     80102763 <ideintr+0x83>
    idestart(idequeue);
8010275e:	e8 1d fe ff ff       	call   80102580 <idestart>
    release(&idelock);
80102763:	83 ec 0c             	sub    $0xc,%esp
80102766:	68 00 26 11 80       	push   $0x80112600
8010276b:	e8 10 26 00 00       	call   80104d80 <release>

  release(&idelock);
}
80102770:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102773:	5b                   	pop    %ebx
80102774:	5e                   	pop    %esi
80102775:	5f                   	pop    %edi
80102776:	5d                   	pop    %ebp
80102777:	c3                   	ret    
80102778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277f:	90                   	nop

80102780 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	53                   	push   %ebx
80102784:	83 ec 10             	sub    $0x10,%esp
80102787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010278a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010278d:	50                   	push   %eax
8010278e:	e8 2d 24 00 00       	call   80104bc0 <holdingsleep>
80102793:	83 c4 10             	add    $0x10,%esp
80102796:	85 c0                	test   %eax,%eax
80102798:	0f 84 c3 00 00 00    	je     80102861 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 03                	mov    (%ebx),%eax
801027a0:	83 e0 06             	and    $0x6,%eax
801027a3:	83 f8 02             	cmp    $0x2,%eax
801027a6:	0f 84 a8 00 00 00    	je     80102854 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027ac:	8b 53 04             	mov    0x4(%ebx),%edx
801027af:	85 d2                	test   %edx,%edx
801027b1:	74 0d                	je     801027c0 <iderw+0x40>
801027b3:	a1 e0 25 11 80       	mov    0x801125e0,%eax
801027b8:	85 c0                	test   %eax,%eax
801027ba:	0f 84 87 00 00 00    	je     80102847 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	68 00 26 11 80       	push   $0x80112600
801027c8:	e8 13 26 00 00       	call   80104de0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027cd:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
801027d2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027d9:	83 c4 10             	add    $0x10,%esp
801027dc:	85 c0                	test   %eax,%eax
801027de:	74 60                	je     80102840 <iderw+0xc0>
801027e0:	89 c2                	mov    %eax,%edx
801027e2:	8b 40 58             	mov    0x58(%eax),%eax
801027e5:	85 c0                	test   %eax,%eax
801027e7:	75 f7                	jne    801027e0 <iderw+0x60>
801027e9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027ec:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027ee:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
801027f4:	74 3a                	je     80102830 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027f6:	8b 03                	mov    (%ebx),%eax
801027f8:	83 e0 06             	and    $0x6,%eax
801027fb:	83 f8 02             	cmp    $0x2,%eax
801027fe:	74 1b                	je     8010281b <iderw+0x9b>
    sleep(b, &idelock);
80102800:	83 ec 08             	sub    $0x8,%esp
80102803:	68 00 26 11 80       	push   $0x80112600
80102808:	53                   	push   %ebx
80102809:	e8 d2 1c 00 00       	call   801044e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010280e:	8b 03                	mov    (%ebx),%eax
80102810:	83 c4 10             	add    $0x10,%esp
80102813:	83 e0 06             	and    $0x6,%eax
80102816:	83 f8 02             	cmp    $0x2,%eax
80102819:	75 e5                	jne    80102800 <iderw+0x80>
  }


  release(&idelock);
8010281b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102825:	c9                   	leave  
  release(&idelock);
80102826:	e9 55 25 00 00       	jmp    80104d80 <release>
8010282b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    idestart(b);
80102830:	89 d8                	mov    %ebx,%eax
80102832:	e8 49 fd ff ff       	call   80102580 <idestart>
80102837:	eb bd                	jmp    801027f6 <iderw+0x76>
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102840:	ba e4 25 11 80       	mov    $0x801125e4,%edx
80102845:	eb a5                	jmp    801027ec <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102847:	83 ec 0c             	sub    $0xc,%esp
8010284a:	68 b5 7c 10 80       	push   $0x80107cb5
8010284f:	e8 2c db ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102854:	83 ec 0c             	sub    $0xc,%esp
80102857:	68 a0 7c 10 80       	push   $0x80107ca0
8010285c:	e8 1f db ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102861:	83 ec 0c             	sub    $0xc,%esp
80102864:	68 8a 7c 10 80       	push   $0x80107c8a
80102869:	e8 12 db ff ff       	call   80100380 <panic>
8010286e:	66 90                	xchg   %ax,%ax

80102870 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102870:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102871:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102878:	00 c0 fe 
{
8010287b:	89 e5                	mov    %esp,%ebp
8010287d:	56                   	push   %esi
8010287e:	53                   	push   %ebx
  ioapic->reg = reg;
8010287f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102886:	00 00 00 
  return ioapic->data;
80102889:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010288f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102892:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102898:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010289e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028a5:	c1 ee 10             	shr    $0x10,%esi
801028a8:	89 f0                	mov    %esi,%eax
801028aa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028ad:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801028b0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028b3:	39 c2                	cmp    %eax,%edx
801028b5:	74 16                	je     801028cd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028b7:	83 ec 0c             	sub    $0xc,%esp
801028ba:	68 d4 7c 10 80       	push   $0x80107cd4
801028bf:	e8 2c de ff ff       	call   801006f0 <cprintf>
  ioapic->reg = reg;
801028c4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801028ca:	83 c4 10             	add    $0x10,%esp
801028cd:	83 c6 21             	add    $0x21,%esi
{
801028d0:	ba 10 00 00 00       	mov    $0x10,%edx
801028d5:	b8 20 00 00 00       	mov    $0x20,%eax
801028da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801028e0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028e2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801028e4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801028ea:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028ed:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801028f3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801028f6:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
801028f9:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801028fc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801028fe:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102904:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010290b:	39 f0                	cmp    %esi,%eax
8010290d:	75 d1                	jne    801028e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010290f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102912:	5b                   	pop    %ebx
80102913:	5e                   	pop    %esi
80102914:	5d                   	pop    %ebp
80102915:	c3                   	ret    
80102916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010291d:	8d 76 00             	lea    0x0(%esi),%esi

80102920 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102920:	55                   	push   %ebp
  ioapic->reg = reg;
80102921:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102927:	89 e5                	mov    %esp,%ebp
80102929:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010292c:	8d 50 20             	lea    0x20(%eax),%edx
8010292f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102933:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102935:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010293b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010293e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102941:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102944:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102946:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010294b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010294e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102951:	5d                   	pop    %ebp
80102952:	c3                   	ret    
80102953:	66 90                	xchg   %ax,%ax
80102955:	66 90                	xchg   %ax,%ax
80102957:	66 90                	xchg   %ax,%ax
80102959:	66 90                	xchg   %ax,%ax
8010295b:	66 90                	xchg   %ax,%ax
8010295d:	66 90                	xchg   %ax,%ax
8010295f:	90                   	nop

80102960 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	53                   	push   %ebx
80102964:	83 ec 04             	sub    $0x4,%esp
80102967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010296a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102970:	75 76                	jne    801029e8 <kfree+0x88>
80102972:	81 fb 50 65 11 80    	cmp    $0x80116550,%ebx
80102978:	72 6e                	jb     801029e8 <kfree+0x88>
8010297a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102980:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102985:	77 61                	ja     801029e8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102987:	83 ec 04             	sub    $0x4,%esp
8010298a:	68 00 10 00 00       	push   $0x1000
8010298f:	6a 01                	push   $0x1
80102991:	53                   	push   %ebx
80102992:	e8 09 25 00 00       	call   80104ea0 <memset>

  if(kmem.use_lock)
80102997:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010299d:	83 c4 10             	add    $0x10,%esp
801029a0:	85 d2                	test   %edx,%edx
801029a2:	75 1c                	jne    801029c0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029a4:	a1 78 26 11 80       	mov    0x80112678,%eax
801029a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029ab:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801029b0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801029b6:	85 c0                	test   %eax,%eax
801029b8:	75 1e                	jne    801029d8 <kfree+0x78>
    release(&kmem.lock);
}
801029ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029bd:	c9                   	leave  
801029be:	c3                   	ret    
801029bf:	90                   	nop
    acquire(&kmem.lock);
801029c0:	83 ec 0c             	sub    $0xc,%esp
801029c3:	68 40 26 11 80       	push   $0x80112640
801029c8:	e8 13 24 00 00       	call   80104de0 <acquire>
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	eb d2                	jmp    801029a4 <kfree+0x44>
801029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029d8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801029df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e2:	c9                   	leave  
    release(&kmem.lock);
801029e3:	e9 98 23 00 00       	jmp    80104d80 <release>
    panic("kfree");
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	68 06 7d 10 80       	push   $0x80107d06
801029f0:	e8 8b d9 ff ff       	call   80100380 <panic>
801029f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a00 <freerange>:
{
80102a00:	55                   	push   %ebp
80102a01:	89 e5                	mov    %esp,%ebp
80102a03:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a04:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a07:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a0a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a0b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a11:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a1d:	39 de                	cmp    %ebx,%esi
80102a1f:	72 23                	jb     80102a44 <freerange+0x44>
80102a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a28:	83 ec 0c             	sub    $0xc,%esp
80102a2b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a37:	50                   	push   %eax
80102a38:	e8 23 ff ff ff       	call   80102960 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a3d:	83 c4 10             	add    $0x10,%esp
80102a40:	39 f3                	cmp    %esi,%ebx
80102a42:	76 e4                	jbe    80102a28 <freerange+0x28>
}
80102a44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a47:	5b                   	pop    %ebx
80102a48:	5e                   	pop    %esi
80102a49:	5d                   	pop    %ebp
80102a4a:	c3                   	ret    
80102a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop

80102a50 <kinit2>:
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a54:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a57:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a5a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a5b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a61:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a67:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a6d:	39 de                	cmp    %ebx,%esi
80102a6f:	72 23                	jb     80102a94 <kinit2+0x44>
80102a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102a78:	83 ec 0c             	sub    $0xc,%esp
80102a7b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a81:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a87:	50                   	push   %eax
80102a88:	e8 d3 fe ff ff       	call   80102960 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a8d:	83 c4 10             	add    $0x10,%esp
80102a90:	39 de                	cmp    %ebx,%esi
80102a92:	73 e4                	jae    80102a78 <kinit2+0x28>
  kmem.use_lock = 1;
80102a94:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
80102a9b:	00 00 00 
}
80102a9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102aa1:	5b                   	pop    %ebx
80102aa2:	5e                   	pop    %esi
80102aa3:	5d                   	pop    %ebp
80102aa4:	c3                   	ret    
80102aa5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ab0 <kinit1>:
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	56                   	push   %esi
80102ab4:	53                   	push   %ebx
80102ab5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102ab8:	83 ec 08             	sub    $0x8,%esp
80102abb:	68 0c 7d 10 80       	push   $0x80107d0c
80102ac0:	68 40 26 11 80       	push   $0x80112640
80102ac5:	e8 46 21 00 00       	call   80104c10 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102aca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ad0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102ad7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102ada:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ae0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ae6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aec:	39 de                	cmp    %ebx,%esi
80102aee:	72 1c                	jb     80102b0c <kinit1+0x5c>
    kfree(p);
80102af0:	83 ec 0c             	sub    $0xc,%esp
80102af3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102aff:	50                   	push   %eax
80102b00:	e8 5b fe ff ff       	call   80102960 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b05:	83 c4 10             	add    $0x10,%esp
80102b08:	39 de                	cmp    %ebx,%esi
80102b0a:	73 e4                	jae    80102af0 <kinit1+0x40>
}
80102b0c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5d                   	pop    %ebp
80102b12:	c3                   	ret    
80102b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b20 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102b20:	a1 74 26 11 80       	mov    0x80112674,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	75 1f                	jne    80102b48 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b29:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102b2e:	85 c0                	test   %eax,%eax
80102b30:	74 0e                	je     80102b40 <kalloc+0x20>
    kmem.freelist = r->next;
80102b32:	8b 10                	mov    (%eax),%edx
80102b34:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102b3a:	c3                   	ret    
80102b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b3f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b40:	c3                   	ret    
80102b41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b48:	55                   	push   %ebp
80102b49:	89 e5                	mov    %esp,%ebp
80102b4b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b4e:	68 40 26 11 80       	push   $0x80112640
80102b53:	e8 88 22 00 00       	call   80104de0 <acquire>
  r = kmem.freelist;
80102b58:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
80102b5d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
80102b63:	83 c4 10             	add    $0x10,%esp
80102b66:	85 c0                	test   %eax,%eax
80102b68:	74 08                	je     80102b72 <kalloc+0x52>
    kmem.freelist = r->next;
80102b6a:	8b 08                	mov    (%eax),%ecx
80102b6c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102b72:	85 d2                	test   %edx,%edx
80102b74:	74 16                	je     80102b8c <kalloc+0x6c>
    release(&kmem.lock);
80102b76:	83 ec 0c             	sub    $0xc,%esp
80102b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b7c:	68 40 26 11 80       	push   $0x80112640
80102b81:	e8 fa 21 00 00       	call   80104d80 <release>
  return (char*)r;
80102b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102b89:	83 c4 10             	add    $0x10,%esp
}
80102b8c:	c9                   	leave  
80102b8d:	c3                   	ret    
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b90:	ba 64 00 00 00       	mov    $0x64,%edx
80102b95:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b96:	a8 01                	test   $0x1,%al
80102b98:	0f 84 c2 00 00 00    	je     80102c60 <kbdgetc+0xd0>
{
80102b9e:	55                   	push   %ebp
80102b9f:	ba 60 00 00 00       	mov    $0x60,%edx
80102ba4:	89 e5                	mov    %esp,%ebp
80102ba6:	53                   	push   %ebx
80102ba7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102ba8:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
80102bae:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102bb1:	3c e0                	cmp    $0xe0,%al
80102bb3:	74 5b                	je     80102c10 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bb5:	89 da                	mov    %ebx,%edx
80102bb7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
80102bba:	84 c0                	test   %al,%al
80102bbc:	78 62                	js     80102c20 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bbe:	85 d2                	test   %edx,%edx
80102bc0:	74 09                	je     80102bcb <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bc2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bc5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102bc8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102bcb:	0f b6 91 40 7e 10 80 	movzbl -0x7fef81c0(%ecx),%edx
  shift ^= togglecode[data];
80102bd2:	0f b6 81 40 7d 10 80 	movzbl -0x7fef82c0(%ecx),%eax
  shift |= shiftcode[data];
80102bd9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102bdb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bdd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102bdf:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102be5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102be8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102beb:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
80102bf2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102bf6:	74 0b                	je     80102c03 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102bf8:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bfb:	83 fa 19             	cmp    $0x19,%edx
80102bfe:	77 48                	ja     80102c48 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c00:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c06:	c9                   	leave  
80102c07:	c3                   	ret    
80102c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c0f:	90                   	nop
    shift |= E0ESC;
80102c10:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c13:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c15:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
80102c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c1e:	c9                   	leave  
80102c1f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102c20:	83 e0 7f             	and    $0x7f,%eax
80102c23:	85 d2                	test   %edx,%edx
80102c25:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102c28:	0f b6 81 40 7e 10 80 	movzbl -0x7fef81c0(%ecx),%eax
80102c2f:	83 c8 40             	or     $0x40,%eax
80102c32:	0f b6 c0             	movzbl %al,%eax
80102c35:	f7 d0                	not    %eax
80102c37:	21 d8                	and    %ebx,%eax
}
80102c39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102c3c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
    return 0;
80102c41:	31 c0                	xor    %eax,%eax
}
80102c43:	c9                   	leave  
80102c44:	c3                   	ret    
80102c45:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102c48:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c4b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c51:	c9                   	leave  
      c += 'a' - 'A';
80102c52:	83 f9 1a             	cmp    $0x1a,%ecx
80102c55:	0f 42 c2             	cmovb  %edx,%eax
}
80102c58:	c3                   	ret    
80102c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c65:	c3                   	ret    
80102c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c6d:	8d 76 00             	lea    0x0(%esi),%esi

80102c70 <kbdintr>:

void
kbdintr(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c76:	68 90 2b 10 80       	push   $0x80102b90
80102c7b:	e8 b0 df ff ff       	call   80100c30 <consoleintr>
}
80102c80:	83 c4 10             	add    $0x10,%esp
80102c83:	c9                   	leave  
80102c84:	c3                   	ret    
80102c85:	66 90                	xchg   %ax,%ax
80102c87:	66 90                	xchg   %ax,%ax
80102c89:	66 90                	xchg   %ax,%ax
80102c8b:	66 90                	xchg   %ax,%ax
80102c8d:	66 90                	xchg   %ax,%ax
80102c8f:	90                   	nop

80102c90 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c90:	a1 80 26 11 80       	mov    0x80112680,%eax
80102c95:	85 c0                	test   %eax,%eax
80102c97:	0f 84 cb 00 00 00    	je     80102d68 <lapicinit+0xd8>
  lapic[index] = value;
80102c9d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ca4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102caa:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102cb1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cbe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ccb:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cd8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cdb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cde:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ce5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ceb:	8b 50 30             	mov    0x30(%eax),%edx
80102cee:	c1 ea 10             	shr    $0x10,%edx
80102cf1:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102cf7:	75 77                	jne    80102d70 <lapicinit+0xe0>
  lapic[index] = value;
80102cf9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d03:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d06:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d20:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d2d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d3a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d41:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d44:	8b 50 20             	mov    0x20(%eax),%edx
80102d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d4e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d56:	80 e6 10             	and    $0x10,%dh
80102d59:	75 f5                	jne    80102d50 <lapicinit+0xc0>
  lapic[index] = value;
80102d5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d68:	c3                   	ret    
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102d70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d7a:	8b 50 20             	mov    0x20(%eax),%edx
}
80102d7d:	e9 77 ff ff ff       	jmp    80102cf9 <lapicinit+0x69>
80102d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d90:	a1 80 26 11 80       	mov    0x80112680,%eax
80102d95:	85 c0                	test   %eax,%eax
80102d97:	74 07                	je     80102da0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102d99:	8b 40 20             	mov    0x20(%eax),%eax
80102d9c:	c1 e8 18             	shr    $0x18,%eax
80102d9f:	c3                   	ret    
    return 0;
80102da0:	31 c0                	xor    %eax,%eax
}
80102da2:	c3                   	ret    
80102da3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102db0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102db0:	a1 80 26 11 80       	mov    0x80112680,%eax
80102db5:	85 c0                	test   %eax,%eax
80102db7:	74 0d                	je     80102dc6 <lapiceoi+0x16>
  lapic[index] = value;
80102db9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102dc0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102dc6:	c3                   	ret    
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102dd0:	c3                   	ret    
80102dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop

80102de0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102de0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102de1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102de6:	ba 70 00 00 00       	mov    $0x70,%edx
80102deb:	89 e5                	mov    %esp,%ebp
80102ded:	53                   	push   %ebx
80102dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102df1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102df4:	ee                   	out    %al,(%dx)
80102df5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dfa:	ba 71 00 00 00       	mov    $0x71,%edx
80102dff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e00:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102e02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e1e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102e23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e6d:	c9                   	leave  
80102e6e:	c3                   	ret    
80102e6f:	90                   	nop

80102e70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e70:	55                   	push   %ebp
80102e71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e76:	ba 70 00 00 00       	mov    $0x70,%edx
80102e7b:	89 e5                	mov    %esp,%ebp
80102e7d:	57                   	push   %edi
80102e7e:	56                   	push   %esi
80102e7f:	53                   	push   %ebx
80102e80:	83 ec 4c             	sub    $0x4c,%esp
80102e83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e84:	ba 71 00 00 00       	mov    $0x71,%edx
80102e89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102e8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e8d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e95:	8d 76 00             	lea    0x0(%esi),%esi
80102e98:	31 c0                	xor    %eax,%eax
80102e9a:	89 da                	mov    %ebx,%edx
80102e9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ea2:	89 ca                	mov    %ecx,%edx
80102ea4:	ec                   	in     (%dx),%al
80102ea5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea8:	89 da                	mov    %ebx,%edx
80102eaa:	b8 02 00 00 00       	mov    $0x2,%eax
80102eaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eb0:	89 ca                	mov    %ecx,%edx
80102eb2:	ec                   	in     (%dx),%al
80102eb3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb6:	89 da                	mov    %ebx,%edx
80102eb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ebd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ebe:	89 ca                	mov    %ecx,%edx
80102ec0:	ec                   	in     (%dx),%al
80102ec1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec4:	89 da                	mov    %ebx,%edx
80102ec6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ecb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ecc:	89 ca                	mov    %ecx,%edx
80102ece:	ec                   	in     (%dx),%al
80102ecf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed2:	89 da                	mov    %ebx,%edx
80102ed4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ed9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eda:	89 ca                	mov    %ecx,%edx
80102edc:	ec                   	in     (%dx),%al
80102edd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102edf:	89 da                	mov    %ebx,%edx
80102ee1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ee6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee7:	89 ca                	mov    %ecx,%edx
80102ee9:	ec                   	in     (%dx),%al
80102eea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eec:	89 da                	mov    %ebx,%edx
80102eee:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ef3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef4:	89 ca                	mov    %ecx,%edx
80102ef6:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ef7:	84 c0                	test   %al,%al
80102ef9:	78 9d                	js     80102e98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102efb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102eff:	89 fa                	mov    %edi,%edx
80102f01:	0f b6 fa             	movzbl %dl,%edi
80102f04:	89 f2                	mov    %esi,%edx
80102f06:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f09:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f0d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f10:	89 da                	mov    %ebx,%edx
80102f12:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f15:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f18:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f1c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f22:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f29:	31 c0                	xor    %eax,%eax
80102f2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2c:	89 ca                	mov    %ecx,%edx
80102f2e:	ec                   	in     (%dx),%al
80102f2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f32:	89 da                	mov    %ebx,%edx
80102f34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f37:	b8 02 00 00 00       	mov    $0x2,%eax
80102f3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f3d:	89 ca                	mov    %ecx,%edx
80102f3f:	ec                   	in     (%dx),%al
80102f40:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f43:	89 da                	mov    %ebx,%edx
80102f45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f48:	b8 04 00 00 00       	mov    $0x4,%eax
80102f4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f4e:	89 ca                	mov    %ecx,%edx
80102f50:	ec                   	in     (%dx),%al
80102f51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f54:	89 da                	mov    %ebx,%edx
80102f56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f59:	b8 07 00 00 00       	mov    $0x7,%eax
80102f5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f5f:	89 ca                	mov    %ecx,%edx
80102f61:	ec                   	in     (%dx),%al
80102f62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f65:	89 da                	mov    %ebx,%edx
80102f67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f70:	89 ca                	mov    %ecx,%edx
80102f72:	ec                   	in     (%dx),%al
80102f73:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f76:	89 da                	mov    %ebx,%edx
80102f78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f80:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f81:	89 ca                	mov    %ecx,%edx
80102f83:	ec                   	in     (%dx),%al
80102f84:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f87:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f8d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f90:	6a 18                	push   $0x18
80102f92:	50                   	push   %eax
80102f93:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f96:	50                   	push   %eax
80102f97:	e8 54 1f 00 00       	call   80104ef0 <memcmp>
80102f9c:	83 c4 10             	add    $0x10,%esp
80102f9f:	85 c0                	test   %eax,%eax
80102fa1:	0f 85 f1 fe ff ff    	jne    80102e98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102fa7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102fab:	75 78                	jne    80103025 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102fad:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fb0:	89 c2                	mov    %eax,%edx
80102fb2:	83 e0 0f             	and    $0xf,%eax
80102fb5:	c1 ea 04             	shr    $0x4,%edx
80102fb8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fbe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fc1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fc4:	89 c2                	mov    %eax,%edx
80102fc6:	83 e0 0f             	and    $0xf,%eax
80102fc9:	c1 ea 04             	shr    $0x4,%edx
80102fcc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fcf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fd2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fd8:	89 c2                	mov    %eax,%edx
80102fda:	83 e0 0f             	and    $0xf,%eax
80102fdd:	c1 ea 04             	shr    $0x4,%edx
80102fe0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fe3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fe6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fe9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fec:	89 c2                	mov    %eax,%edx
80102fee:	83 e0 0f             	and    $0xf,%eax
80102ff1:	c1 ea 04             	shr    $0x4,%edx
80102ff4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ff7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ffa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ffd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103000:	89 c2                	mov    %eax,%edx
80103002:	83 e0 0f             	and    $0xf,%eax
80103005:	c1 ea 04             	shr    $0x4,%edx
80103008:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010300b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010300e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103011:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103014:	89 c2                	mov    %eax,%edx
80103016:	83 e0 0f             	and    $0xf,%eax
80103019:	c1 ea 04             	shr    $0x4,%edx
8010301c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010301f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103022:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103025:	8b 75 08             	mov    0x8(%ebp),%esi
80103028:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010302b:	89 06                	mov    %eax,(%esi)
8010302d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103030:	89 46 04             	mov    %eax,0x4(%esi)
80103033:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103036:	89 46 08             	mov    %eax,0x8(%esi)
80103039:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010303c:	89 46 0c             	mov    %eax,0xc(%esi)
8010303f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103042:	89 46 10             	mov    %eax,0x10(%esi)
80103045:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103048:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010304b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103052:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103055:	5b                   	pop    %ebx
80103056:	5e                   	pop    %esi
80103057:	5f                   	pop    %edi
80103058:	5d                   	pop    %ebp
80103059:	c3                   	ret    
8010305a:	66 90                	xchg   %ax,%ax
8010305c:	66 90                	xchg   %ax,%ax
8010305e:	66 90                	xchg   %ax,%ax

80103060 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103060:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103066:	85 c9                	test   %ecx,%ecx
80103068:	0f 8e 8a 00 00 00    	jle    801030f8 <install_trans+0x98>
{
8010306e:	55                   	push   %ebp
8010306f:	89 e5                	mov    %esp,%ebp
80103071:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103072:	31 ff                	xor    %edi,%edi
{
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 0c             	sub    $0xc,%esp
80103079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103080:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103085:	83 ec 08             	sub    $0x8,%esp
80103088:	01 f8                	add    %edi,%eax
8010308a:	83 c0 01             	add    $0x1,%eax
8010308d:	50                   	push   %eax
8010308e:	ff 35 e4 26 11 80    	push   0x801126e4
80103094:	e8 37 d0 ff ff       	call   801000d0 <bread>
80103099:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010309b:	58                   	pop    %eax
8010309c:	5a                   	pop    %edx
8010309d:	ff 34 bd ec 26 11 80 	push   -0x7feed914(,%edi,4)
801030a4:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
801030aa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030ad:	e8 1e d0 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030b2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030b5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030b7:	8d 46 5c             	lea    0x5c(%esi),%eax
801030ba:	68 00 02 00 00       	push   $0x200
801030bf:	50                   	push   %eax
801030c0:	8d 43 5c             	lea    0x5c(%ebx),%eax
801030c3:	50                   	push   %eax
801030c4:	e8 77 1e 00 00       	call   80104f40 <memmove>
    bwrite(dbuf);  // write dst to disk
801030c9:	89 1c 24             	mov    %ebx,(%esp)
801030cc:	e8 df d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801030d1:	89 34 24             	mov    %esi,(%esp)
801030d4:	e8 17 d1 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801030d9:	89 1c 24             	mov    %ebx,(%esp)
801030dc:	e8 0f d1 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030e1:	83 c4 10             	add    $0x10,%esp
801030e4:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
801030ea:	7f 94                	jg     80103080 <install_trans+0x20>
  }
}
801030ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ef:	5b                   	pop    %ebx
801030f0:	5e                   	pop    %esi
801030f1:	5f                   	pop    %edi
801030f2:	5d                   	pop    %ebp
801030f3:	c3                   	ret    
801030f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030f8:	c3                   	ret    
801030f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103100 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	53                   	push   %ebx
80103104:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103107:	ff 35 d4 26 11 80    	push   0x801126d4
8010310d:	ff 35 e4 26 11 80    	push   0x801126e4
80103113:	e8 b8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103118:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010311b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010311d:	a1 e8 26 11 80       	mov    0x801126e8,%eax
80103122:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103125:	85 c0                	test   %eax,%eax
80103127:	7e 19                	jle    80103142 <write_head+0x42>
80103129:	31 d2                	xor    %edx,%edx
8010312b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103130:	8b 0c 95 ec 26 11 80 	mov    -0x7feed914(,%edx,4),%ecx
80103137:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010313b:	83 c2 01             	add    $0x1,%edx
8010313e:	39 d0                	cmp    %edx,%eax
80103140:	75 ee                	jne    80103130 <write_head+0x30>
  }
  bwrite(buf);
80103142:	83 ec 0c             	sub    $0xc,%esp
80103145:	53                   	push   %ebx
80103146:	e8 65 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010314b:	89 1c 24             	mov    %ebx,(%esp)
8010314e:	e8 9d d0 ff ff       	call   801001f0 <brelse>
}
80103153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	c9                   	leave  
8010315a:	c3                   	ret    
8010315b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010315f:	90                   	nop

80103160 <initlog>:
{
80103160:	55                   	push   %ebp
80103161:	89 e5                	mov    %esp,%ebp
80103163:	53                   	push   %ebx
80103164:	83 ec 2c             	sub    $0x2c,%esp
80103167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010316a:	68 40 7f 10 80       	push   $0x80107f40
8010316f:	68 a0 26 11 80       	push   $0x801126a0
80103174:	e8 97 1a 00 00       	call   80104c10 <initlock>
  readsb(dev, &sb);
80103179:	58                   	pop    %eax
8010317a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010317d:	5a                   	pop    %edx
8010317e:	50                   	push   %eax
8010317f:	53                   	push   %ebx
80103180:	e8 3b e8 ff ff       	call   801019c0 <readsb>
  log.start = sb.logstart;
80103185:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80103188:	59                   	pop    %ecx
  log.dev = dev;
80103189:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
8010318f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103192:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80103197:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
8010319d:	5a                   	pop    %edx
8010319e:	50                   	push   %eax
8010319f:	53                   	push   %ebx
801031a0:	e8 2b cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031a5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031a8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801031ab:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
801031b1:	85 db                	test   %ebx,%ebx
801031b3:	7e 1d                	jle    801031d2 <initlog+0x72>
801031b5:	31 d2                	xor    %edx,%edx
801031b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031be:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801031c0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801031c4:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	39 d3                	cmp    %edx,%ebx
801031d0:	75 ee                	jne    801031c0 <initlog+0x60>
  brelse(buf);
801031d2:	83 ec 0c             	sub    $0xc,%esp
801031d5:	50                   	push   %eax
801031d6:	e8 15 d0 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031db:	e8 80 fe ff ff       	call   80103060 <install_trans>
  log.lh.n = 0;
801031e0:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
801031e7:	00 00 00 
  write_head(); // clear the log
801031ea:	e8 11 ff ff ff       	call   80103100 <write_head>
}
801031ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031f2:	83 c4 10             	add    $0x10,%esp
801031f5:	c9                   	leave  
801031f6:	c3                   	ret    
801031f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fe:	66 90                	xchg   %ax,%ax

80103200 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103200:	55                   	push   %ebp
80103201:	89 e5                	mov    %esp,%ebp
80103203:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103206:	68 a0 26 11 80       	push   $0x801126a0
8010320b:	e8 d0 1b 00 00       	call   80104de0 <acquire>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	eb 18                	jmp    8010322d <begin_op+0x2d>
80103215:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103218:	83 ec 08             	sub    $0x8,%esp
8010321b:	68 a0 26 11 80       	push   $0x801126a0
80103220:	68 a0 26 11 80       	push   $0x801126a0
80103225:	e8 b6 12 00 00       	call   801044e0 <sleep>
8010322a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010322d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	75 e2                	jne    80103218 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103236:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010323b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103241:	83 c0 01             	add    $0x1,%eax
80103244:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103247:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010324a:	83 fa 1e             	cmp    $0x1e,%edx
8010324d:	7f c9                	jg     80103218 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010324f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103252:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80103257:	68 a0 26 11 80       	push   $0x801126a0
8010325c:	e8 1f 1b 00 00       	call   80104d80 <release>
      break;
    }
  }
}
80103261:	83 c4 10             	add    $0x10,%esp
80103264:	c9                   	leave  
80103265:	c3                   	ret    
80103266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010326d:	8d 76 00             	lea    0x0(%esi),%esi

80103270 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	57                   	push   %edi
80103274:	56                   	push   %esi
80103275:	53                   	push   %ebx
80103276:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103279:	68 a0 26 11 80       	push   $0x801126a0
8010327e:	e8 5d 1b 00 00       	call   80104de0 <acquire>
  log.outstanding -= 1;
80103283:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80103288:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
8010328e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103291:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103294:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
8010329a:	85 f6                	test   %esi,%esi
8010329c:	0f 85 22 01 00 00    	jne    801033c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032a2:	85 db                	test   %ebx,%ebx
801032a4:	0f 85 f6 00 00 00    	jne    801033a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032aa:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
801032b1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032b4:	83 ec 0c             	sub    $0xc,%esp
801032b7:	68 a0 26 11 80       	push   $0x801126a0
801032bc:	e8 bf 1a 00 00       	call   80104d80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032c1:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	85 c9                	test   %ecx,%ecx
801032cc:	7f 42                	jg     80103310 <end_op+0xa0>
    acquire(&log.lock);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	68 a0 26 11 80       	push   $0x801126a0
801032d6:	e8 05 1b 00 00       	call   80104de0 <acquire>
    wakeup(&log);
801032db:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
801032e2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
801032e9:	00 00 00 
    wakeup(&log);
801032ec:	e8 af 12 00 00       	call   801045a0 <wakeup>
    release(&log.lock);
801032f1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801032f8:	e8 83 1a 00 00       	call   80104d80 <release>
801032fd:	83 c4 10             	add    $0x10,%esp
}
80103300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103303:	5b                   	pop    %ebx
80103304:	5e                   	pop    %esi
80103305:	5f                   	pop    %edi
80103306:	5d                   	pop    %ebp
80103307:	c3                   	ret    
80103308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010330f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103310:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103315:	83 ec 08             	sub    $0x8,%esp
80103318:	01 d8                	add    %ebx,%eax
8010331a:	83 c0 01             	add    $0x1,%eax
8010331d:	50                   	push   %eax
8010331e:	ff 35 e4 26 11 80    	push   0x801126e4
80103324:	e8 a7 cd ff ff       	call   801000d0 <bread>
80103329:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010332b:	58                   	pop    %eax
8010332c:	5a                   	pop    %edx
8010332d:	ff 34 9d ec 26 11 80 	push   -0x7feed914(,%ebx,4)
80103334:	ff 35 e4 26 11 80    	push   0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010333a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010333d:	e8 8e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103342:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103345:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103347:	8d 40 5c             	lea    0x5c(%eax),%eax
8010334a:	68 00 02 00 00       	push   $0x200
8010334f:	50                   	push   %eax
80103350:	8d 46 5c             	lea    0x5c(%esi),%eax
80103353:	50                   	push   %eax
80103354:	e8 e7 1b 00 00       	call   80104f40 <memmove>
    bwrite(to);  // write the log
80103359:	89 34 24             	mov    %esi,(%esp)
8010335c:	e8 4f ce ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103361:	89 3c 24             	mov    %edi,(%esp)
80103364:	e8 87 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
80103369:	89 34 24             	mov    %esi,(%esp)
8010336c:	e8 7f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103371:	83 c4 10             	add    $0x10,%esp
80103374:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
8010337a:	7c 94                	jl     80103310 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010337c:	e8 7f fd ff ff       	call   80103100 <write_head>
    install_trans(); // Now install writes to home locations
80103381:	e8 da fc ff ff       	call   80103060 <install_trans>
    log.lh.n = 0;
80103386:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
8010338d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103390:	e8 6b fd ff ff       	call   80103100 <write_head>
80103395:	e9 34 ff ff ff       	jmp    801032ce <end_op+0x5e>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 a0 26 11 80       	push   $0x801126a0
801033a8:	e8 f3 11 00 00       	call   801045a0 <wakeup>
  release(&log.lock);
801033ad:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801033b4:	e8 c7 19 00 00       	call   80104d80 <release>
801033b9:	83 c4 10             	add    $0x10,%esp
}
801033bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bf:	5b                   	pop    %ebx
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
    panic("log.committing");
801033c4:	83 ec 0c             	sub    $0xc,%esp
801033c7:	68 44 7f 10 80       	push   $0x80107f44
801033cc:	e8 af cf ff ff       	call   80100380 <panic>
801033d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033df:	90                   	nop

801033e0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	53                   	push   %ebx
801033e4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033e7:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
801033ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033f0:	83 fa 1d             	cmp    $0x1d,%edx
801033f3:	0f 8f 85 00 00 00    	jg     8010347e <log_write+0x9e>
801033f9:	a1 d8 26 11 80       	mov    0x801126d8,%eax
801033fe:	83 e8 01             	sub    $0x1,%eax
80103401:	39 c2                	cmp    %eax,%edx
80103403:	7d 79                	jge    8010347e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103405:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010340a:	85 c0                	test   %eax,%eax
8010340c:	7e 7d                	jle    8010348b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010340e:	83 ec 0c             	sub    $0xc,%esp
80103411:	68 a0 26 11 80       	push   $0x801126a0
80103416:	e8 c5 19 00 00       	call   80104de0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010341b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103421:	83 c4 10             	add    $0x10,%esp
80103424:	85 d2                	test   %edx,%edx
80103426:	7e 4a                	jle    80103472 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103428:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010342b:	31 c0                	xor    %eax,%eax
8010342d:	eb 08                	jmp    80103437 <log_write+0x57>
8010342f:	90                   	nop
80103430:	83 c0 01             	add    $0x1,%eax
80103433:	39 c2                	cmp    %eax,%edx
80103435:	74 29                	je     80103460 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103437:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
8010343e:	75 f0                	jne    80103430 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103440:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103447:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010344a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010344d:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80103454:	c9                   	leave  
  release(&log.lock);
80103455:	e9 26 19 00 00       	jmp    80104d80 <release>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103460:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
80103467:	83 c2 01             	add    $0x1,%edx
8010346a:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
80103470:	eb d5                	jmp    80103447 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103472:	8b 43 08             	mov    0x8(%ebx),%eax
80103475:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
8010347a:	75 cb                	jne    80103447 <log_write+0x67>
8010347c:	eb e9                	jmp    80103467 <log_write+0x87>
    panic("too big a transaction");
8010347e:	83 ec 0c             	sub    $0xc,%esp
80103481:	68 53 7f 10 80       	push   $0x80107f53
80103486:	e8 f5 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	68 69 7f 10 80       	push   $0x80107f69
80103493:	e8 e8 ce ff ff       	call   80100380 <panic>
80103498:	66 90                	xchg   %ax,%ax
8010349a:	66 90                	xchg   %ax,%ax
8010349c:	66 90                	xchg   %ax,%ax
8010349e:	66 90                	xchg   %ax,%ax

801034a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	53                   	push   %ebx
801034a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801034a7:	e8 44 09 00 00       	call   80103df0 <cpuid>
801034ac:	89 c3                	mov    %eax,%ebx
801034ae:	e8 3d 09 00 00       	call   80103df0 <cpuid>
801034b3:	83 ec 04             	sub    $0x4,%esp
801034b6:	53                   	push   %ebx
801034b7:	50                   	push   %eax
801034b8:	68 84 7f 10 80       	push   $0x80107f84
801034bd:	e8 2e d2 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
801034c2:	e8 29 2d 00 00       	call   801061f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034c7:	e8 c4 08 00 00       	call   80103d90 <mycpu>
801034cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ce:	b8 01 00 00 00       	mov    $0x1,%eax
801034d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034da:	e8 f1 0b 00 00       	call   801040d0 <scheduler>
801034df:	90                   	nop

801034e0 <mpenter>:
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034e6:	e8 f5 3d 00 00       	call   801072e0 <switchkvm>
  seginit();
801034eb:	e8 60 3d 00 00       	call   80107250 <seginit>
  lapicinit();
801034f0:	e8 9b f7 ff ff       	call   80102c90 <lapicinit>
  mpmain();
801034f5:	e8 a6 ff ff ff       	call   801034a0 <mpmain>
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <main>:
{
80103500:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103504:	83 e4 f0             	and    $0xfffffff0,%esp
80103507:	ff 71 fc             	push   -0x4(%ecx)
8010350a:	55                   	push   %ebp
8010350b:	89 e5                	mov    %esp,%ebp
8010350d:	53                   	push   %ebx
8010350e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010350f:	83 ec 08             	sub    $0x8,%esp
80103512:	68 00 00 40 80       	push   $0x80400000
80103517:	68 50 65 11 80       	push   $0x80116550
8010351c:	e8 8f f5 ff ff       	call   80102ab0 <kinit1>
  kvmalloc();      // kernel page table
80103521:	e8 aa 42 00 00       	call   801077d0 <kvmalloc>
  mpinit();        // detect other processors
80103526:	e8 85 01 00 00       	call   801036b0 <mpinit>
  lapicinit();     // interrupt controller
8010352b:	e8 60 f7 ff ff       	call   80102c90 <lapicinit>
  seginit();       // segment descriptors
80103530:	e8 1b 3d 00 00       	call   80107250 <seginit>
  picinit();       // disable pic
80103535:	e8 76 03 00 00       	call   801038b0 <picinit>
  ioapicinit();    // another interrupt controller
8010353a:	e8 31 f3 ff ff       	call   80102870 <ioapicinit>
  consoleinit();   // console hardware
8010353f:	e8 bc d9 ff ff       	call   80100f00 <consoleinit>
  uartinit();      // serial port
80103544:	e8 97 2f 00 00       	call   801064e0 <uartinit>
  pinit();         // process table
80103549:	e8 22 08 00 00       	call   80103d70 <pinit>
  tvinit();        // trap vectors
8010354e:	e8 1d 2c 00 00       	call   80106170 <tvinit>
  binit();         // buffer cache
80103553:	e8 e8 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103558:	e8 53 dd ff ff       	call   801012b0 <fileinit>
  ideinit();       // disk 
8010355d:	e8 fe f0 ff ff       	call   80102660 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103562:	83 c4 0c             	add    $0xc,%esp
80103565:	68 8a 00 00 00       	push   $0x8a
8010356a:	68 8c b4 10 80       	push   $0x8010b48c
8010356f:	68 00 70 00 80       	push   $0x80007000
80103574:	e8 c7 19 00 00       	call   80104f40 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103583:	00 00 00 
80103586:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010358b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103590:	76 7e                	jbe    80103610 <main+0x110>
80103592:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103597:	eb 20                	jmp    801035b9 <main+0xb9>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035a0:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801035a7:	00 00 00 
801035aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035b0:	05 a0 27 11 80       	add    $0x801127a0,%eax
801035b5:	39 c3                	cmp    %eax,%ebx
801035b7:	73 57                	jae    80103610 <main+0x110>
    if(c == mycpu())  // We've started already.
801035b9:	e8 d2 07 00 00       	call   80103d90 <mycpu>
801035be:	39 c3                	cmp    %eax,%ebx
801035c0:	74 de                	je     801035a0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801035c2:	e8 59 f5 ff ff       	call   80102b20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801035c7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801035ca:	c7 05 f8 6f 00 80 e0 	movl   $0x801034e0,0x80006ff8
801035d1:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035d4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035db:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035de:	05 00 10 00 00       	add    $0x1000,%eax
801035e3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801035e8:	0f b6 03             	movzbl (%ebx),%eax
801035eb:	68 00 70 00 00       	push   $0x7000
801035f0:	50                   	push   %eax
801035f1:	e8 ea f7 ff ff       	call   80102de0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035f6:	83 c4 10             	add    $0x10,%esp
801035f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103600:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103606:	85 c0                	test   %eax,%eax
80103608:	74 f6                	je     80103600 <main+0x100>
8010360a:	eb 94                	jmp    801035a0 <main+0xa0>
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103610:	83 ec 08             	sub    $0x8,%esp
80103613:	68 00 00 00 8e       	push   $0x8e000000
80103618:	68 00 00 40 80       	push   $0x80400000
8010361d:	e8 2e f4 ff ff       	call   80102a50 <kinit2>
  userinit();      // first user process
80103622:	e8 19 08 00 00       	call   80103e40 <userinit>
  mpmain();        // finish this processor's setup
80103627:	e8 74 fe ff ff       	call   801034a0 <mpmain>
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103635:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010363b:	53                   	push   %ebx
  e = addr+len;
8010363c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010363f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103642:	39 de                	cmp    %ebx,%esi
80103644:	72 10                	jb     80103656 <mpsearch1+0x26>
80103646:	eb 50                	jmp    80103698 <mpsearch1+0x68>
80103648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010364f:	90                   	nop
80103650:	89 fe                	mov    %edi,%esi
80103652:	39 fb                	cmp    %edi,%ebx
80103654:	76 42                	jbe    80103698 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103656:	83 ec 04             	sub    $0x4,%esp
80103659:	8d 7e 10             	lea    0x10(%esi),%edi
8010365c:	6a 04                	push   $0x4
8010365e:	68 98 7f 10 80       	push   $0x80107f98
80103663:	56                   	push   %esi
80103664:	e8 87 18 00 00       	call   80104ef0 <memcmp>
80103669:	83 c4 10             	add    $0x10,%esp
8010366c:	85 c0                	test   %eax,%eax
8010366e:	75 e0                	jne    80103650 <mpsearch1+0x20>
80103670:	89 f2                	mov    %esi,%edx
80103672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103678:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010367b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010367e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103680:	39 fa                	cmp    %edi,%edx
80103682:	75 f4                	jne    80103678 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103684:	84 c0                	test   %al,%al
80103686:	75 c8                	jne    80103650 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103688:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010368b:	89 f0                	mov    %esi,%eax
8010368d:	5b                   	pop    %ebx
8010368e:	5e                   	pop    %esi
8010368f:	5f                   	pop    %edi
80103690:	5d                   	pop    %ebp
80103691:	c3                   	ret    
80103692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103698:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010369b:	31 f6                	xor    %esi,%esi
}
8010369d:	5b                   	pop    %ebx
8010369e:	89 f0                	mov    %esi,%eax
801036a0:	5e                   	pop    %esi
801036a1:	5f                   	pop    %edi
801036a2:	5d                   	pop    %ebp
801036a3:	c3                   	ret    
801036a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036af:	90                   	nop

801036b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	57                   	push   %edi
801036b4:	56                   	push   %esi
801036b5:	53                   	push   %ebx
801036b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801036b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036c7:	c1 e0 08             	shl    $0x8,%eax
801036ca:	09 d0                	or     %edx,%eax
801036cc:	c1 e0 04             	shl    $0x4,%eax
801036cf:	75 1b                	jne    801036ec <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036d1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036d8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036df:	c1 e0 08             	shl    $0x8,%eax
801036e2:	09 d0                	or     %edx,%eax
801036e4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036e7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036ec:	ba 00 04 00 00       	mov    $0x400,%edx
801036f1:	e8 3a ff ff ff       	call   80103630 <mpsearch1>
801036f6:	89 c3                	mov    %eax,%ebx
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 84 40 01 00 00    	je     80103840 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103700:	8b 73 04             	mov    0x4(%ebx),%esi
80103703:	85 f6                	test   %esi,%esi
80103705:	0f 84 25 01 00 00    	je     80103830 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010370b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010370e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103714:	6a 04                	push   $0x4
80103716:	68 9d 7f 10 80       	push   $0x80107f9d
8010371b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010371c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010371f:	e8 cc 17 00 00       	call   80104ef0 <memcmp>
80103724:	83 c4 10             	add    $0x10,%esp
80103727:	85 c0                	test   %eax,%eax
80103729:	0f 85 01 01 00 00    	jne    80103830 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010372f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103736:	3c 01                	cmp    $0x1,%al
80103738:	74 08                	je     80103742 <mpinit+0x92>
8010373a:	3c 04                	cmp    $0x4,%al
8010373c:	0f 85 ee 00 00 00    	jne    80103830 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103742:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103749:	66 85 d2             	test   %dx,%dx
8010374c:	74 22                	je     80103770 <mpinit+0xc0>
8010374e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103751:	89 f0                	mov    %esi,%eax
  sum = 0;
80103753:	31 d2                	xor    %edx,%edx
80103755:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103758:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010375f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103762:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103764:	39 c7                	cmp    %eax,%edi
80103766:	75 f0                	jne    80103758 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103768:	84 d2                	test   %dl,%dl
8010376a:	0f 85 c0 00 00 00    	jne    80103830 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103770:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103776:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010377b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103782:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103788:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010378d:	03 55 e4             	add    -0x1c(%ebp),%edx
80103790:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103797:	90                   	nop
80103798:	39 d0                	cmp    %edx,%eax
8010379a:	73 15                	jae    801037b1 <mpinit+0x101>
    switch(*p){
8010379c:	0f b6 08             	movzbl (%eax),%ecx
8010379f:	80 f9 02             	cmp    $0x2,%cl
801037a2:	74 4c                	je     801037f0 <mpinit+0x140>
801037a4:	77 3a                	ja     801037e0 <mpinit+0x130>
801037a6:	84 c9                	test   %cl,%cl
801037a8:	74 56                	je     80103800 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037aa:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037ad:	39 d0                	cmp    %edx,%eax
801037af:	72 eb                	jb     8010379c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801037b4:	85 f6                	test   %esi,%esi
801037b6:	0f 84 d9 00 00 00    	je     80103895 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037bc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801037c0:	74 15                	je     801037d7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037c2:	b8 70 00 00 00       	mov    $0x70,%eax
801037c7:	ba 22 00 00 00       	mov    $0x22,%edx
801037cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037cd:	ba 23 00 00 00       	mov    $0x23,%edx
801037d2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037d3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037d6:	ee                   	out    %al,(%dx)
  }
}
801037d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037da:	5b                   	pop    %ebx
801037db:	5e                   	pop    %esi
801037dc:	5f                   	pop    %edi
801037dd:	5d                   	pop    %ebp
801037de:	c3                   	ret    
801037df:	90                   	nop
    switch(*p){
801037e0:	83 e9 03             	sub    $0x3,%ecx
801037e3:	80 f9 01             	cmp    $0x1,%cl
801037e6:	76 c2                	jbe    801037aa <mpinit+0xfa>
801037e8:	31 f6                	xor    %esi,%esi
801037ea:	eb ac                	jmp    80103798 <mpinit+0xe8>
801037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801037f0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801037f4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801037f7:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
801037fd:	eb 99                	jmp    80103798 <mpinit+0xe8>
801037ff:	90                   	nop
      if(ncpu < NCPU) {
80103800:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103806:	83 f9 07             	cmp    $0x7,%ecx
80103809:	7f 19                	jg     80103824 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010380b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103811:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103815:	83 c1 01             	add    $0x1,%ecx
80103818:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010381e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103824:	83 c0 14             	add    $0x14,%eax
      continue;
80103827:	e9 6c ff ff ff       	jmp    80103798 <mpinit+0xe8>
8010382c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	68 a2 7f 10 80       	push   $0x80107fa2
80103838:	e8 43 cb ff ff       	call   80100380 <panic>
8010383d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103840:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103845:	eb 13                	jmp    8010385a <mpinit+0x1aa>
80103847:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010384e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103850:	89 f3                	mov    %esi,%ebx
80103852:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103858:	74 d6                	je     80103830 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010385a:	83 ec 04             	sub    $0x4,%esp
8010385d:	8d 73 10             	lea    0x10(%ebx),%esi
80103860:	6a 04                	push   $0x4
80103862:	68 98 7f 10 80       	push   $0x80107f98
80103867:	53                   	push   %ebx
80103868:	e8 83 16 00 00       	call   80104ef0 <memcmp>
8010386d:	83 c4 10             	add    $0x10,%esp
80103870:	85 c0                	test   %eax,%eax
80103872:	75 dc                	jne    80103850 <mpinit+0x1a0>
80103874:	89 da                	mov    %ebx,%edx
80103876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103880:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103883:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103886:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103888:	39 d6                	cmp    %edx,%esi
8010388a:	75 f4                	jne    80103880 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010388c:	84 c0                	test   %al,%al
8010388e:	75 c0                	jne    80103850 <mpinit+0x1a0>
80103890:	e9 6b fe ff ff       	jmp    80103700 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103895:	83 ec 0c             	sub    $0xc,%esp
80103898:	68 bc 7f 10 80       	push   $0x80107fbc
8010389d:	e8 de ca ff ff       	call   80100380 <panic>
801038a2:	66 90                	xchg   %ax,%ax
801038a4:	66 90                	xchg   %ax,%ax
801038a6:	66 90                	xchg   %ax,%ax
801038a8:	66 90                	xchg   %ax,%ax
801038aa:	66 90                	xchg   %ax,%ax
801038ac:	66 90                	xchg   %ax,%ax
801038ae:	66 90                	xchg   %ax,%ax

801038b0 <picinit>:
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801038b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038b5:	ba 21 00 00 00       	mov    $0x21,%edx
801038ba:	ee                   	out    %al,(%dx)
801038bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801038c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801038c1:	c3                   	ret    
801038c2:	66 90                	xchg   %ax,%ax
801038c4:	66 90                	xchg   %ax,%ax
801038c6:	66 90                	xchg   %ax,%ax
801038c8:	66 90                	xchg   %ax,%ax
801038ca:	66 90                	xchg   %ax,%ax
801038cc:	66 90                	xchg   %ax,%ax
801038ce:	66 90                	xchg   %ax,%ax

801038d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	57                   	push   %edi
801038d4:	56                   	push   %esi
801038d5:	53                   	push   %ebx
801038d6:	83 ec 0c             	sub    $0xc,%esp
801038d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801038df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038eb:	e8 e0 d9 ff ff       	call   801012d0 <filealloc>
801038f0:	89 03                	mov    %eax,(%ebx)
801038f2:	85 c0                	test   %eax,%eax
801038f4:	0f 84 a8 00 00 00    	je     801039a2 <pipealloc+0xd2>
801038fa:	e8 d1 d9 ff ff       	call   801012d0 <filealloc>
801038ff:	89 06                	mov    %eax,(%esi)
80103901:	85 c0                	test   %eax,%eax
80103903:	0f 84 87 00 00 00    	je     80103990 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103909:	e8 12 f2 ff ff       	call   80102b20 <kalloc>
8010390e:	89 c7                	mov    %eax,%edi
80103910:	85 c0                	test   %eax,%eax
80103912:	0f 84 b0 00 00 00    	je     801039c8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103918:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010391f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103922:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103925:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010392c:	00 00 00 
  p->nwrite = 0;
8010392f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103936:	00 00 00 
  p->nread = 0;
80103939:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103940:	00 00 00 
  initlock(&p->lock, "pipe");
80103943:	68 db 7f 10 80       	push   $0x80107fdb
80103948:	50                   	push   %eax
80103949:	e8 c2 12 00 00       	call   80104c10 <initlock>
  (*f0)->type = FD_PIPE;
8010394e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103950:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103953:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103959:	8b 03                	mov    (%ebx),%eax
8010395b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010395f:	8b 03                	mov    (%ebx),%eax
80103961:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103965:	8b 03                	mov    (%ebx),%eax
80103967:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010396a:	8b 06                	mov    (%esi),%eax
8010396c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103972:	8b 06                	mov    (%esi),%eax
80103974:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103978:	8b 06                	mov    (%esi),%eax
8010397a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010397e:	8b 06                	mov    (%esi),%eax
80103980:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103983:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103986:	31 c0                	xor    %eax,%eax
}
80103988:	5b                   	pop    %ebx
80103989:	5e                   	pop    %esi
8010398a:	5f                   	pop    %edi
8010398b:	5d                   	pop    %ebp
8010398c:	c3                   	ret    
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103990:	8b 03                	mov    (%ebx),%eax
80103992:	85 c0                	test   %eax,%eax
80103994:	74 1e                	je     801039b4 <pipealloc+0xe4>
    fileclose(*f0);
80103996:	83 ec 0c             	sub    $0xc,%esp
80103999:	50                   	push   %eax
8010399a:	e8 f1 d9 ff ff       	call   80101390 <fileclose>
8010399f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039a2:	8b 06                	mov    (%esi),%eax
801039a4:	85 c0                	test   %eax,%eax
801039a6:	74 0c                	je     801039b4 <pipealloc+0xe4>
    fileclose(*f1);
801039a8:	83 ec 0c             	sub    $0xc,%esp
801039ab:	50                   	push   %eax
801039ac:	e8 df d9 ff ff       	call   80101390 <fileclose>
801039b1:	83 c4 10             	add    $0x10,%esp
}
801039b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801039b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801039bc:	5b                   	pop    %ebx
801039bd:	5e                   	pop    %esi
801039be:	5f                   	pop    %edi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039c8:	8b 03                	mov    (%ebx),%eax
801039ca:	85 c0                	test   %eax,%eax
801039cc:	75 c8                	jne    80103996 <pipealloc+0xc6>
801039ce:	eb d2                	jmp    801039a2 <pipealloc+0xd2>

801039d0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	56                   	push   %esi
801039d4:	53                   	push   %ebx
801039d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039db:	83 ec 0c             	sub    $0xc,%esp
801039de:	53                   	push   %ebx
801039df:	e8 fc 13 00 00       	call   80104de0 <acquire>
  if(writable){
801039e4:	83 c4 10             	add    $0x10,%esp
801039e7:	85 f6                	test   %esi,%esi
801039e9:	74 65                	je     80103a50 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801039eb:	83 ec 0c             	sub    $0xc,%esp
801039ee:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801039f4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039fb:	00 00 00 
    wakeup(&p->nread);
801039fe:	50                   	push   %eax
801039ff:	e8 9c 0b 00 00       	call   801045a0 <wakeup>
80103a04:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a07:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a0d:	85 d2                	test   %edx,%edx
80103a0f:	75 0a                	jne    80103a1b <pipeclose+0x4b>
80103a11:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a17:	85 c0                	test   %eax,%eax
80103a19:	74 15                	je     80103a30 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a1b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a21:	5b                   	pop    %ebx
80103a22:	5e                   	pop    %esi
80103a23:	5d                   	pop    %ebp
    release(&p->lock);
80103a24:	e9 57 13 00 00       	jmp    80104d80 <release>
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	53                   	push   %ebx
80103a34:	e8 47 13 00 00       	call   80104d80 <release>
    kfree((char*)p);
80103a39:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a3c:	83 c4 10             	add    $0x10,%esp
}
80103a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a42:	5b                   	pop    %ebx
80103a43:	5e                   	pop    %esi
80103a44:	5d                   	pop    %ebp
    kfree((char*)p);
80103a45:	e9 16 ef ff ff       	jmp    80102960 <kfree>
80103a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a60:	00 00 00 
    wakeup(&p->nwrite);
80103a63:	50                   	push   %eax
80103a64:	e8 37 0b 00 00       	call   801045a0 <wakeup>
80103a69:	83 c4 10             	add    $0x10,%esp
80103a6c:	eb 99                	jmp    80103a07 <pipeclose+0x37>
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 28             	sub    $0x28,%esp
80103a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a7c:	53                   	push   %ebx
80103a7d:	e8 5e 13 00 00       	call   80104de0 <acquire>
  for(i = 0; i < n; i++){
80103a82:	8b 45 10             	mov    0x10(%ebp),%eax
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	85 c0                	test   %eax,%eax
80103a8a:	0f 8e c0 00 00 00    	jle    80103b50 <pipewrite+0xe0>
80103a90:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a93:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a99:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aa2:	03 45 10             	add    0x10(%ebp),%eax
80103aa5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aa8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103aae:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ab4:	89 ca                	mov    %ecx,%edx
80103ab6:	05 00 02 00 00       	add    $0x200,%eax
80103abb:	39 c1                	cmp    %eax,%ecx
80103abd:	74 3f                	je     80103afe <pipewrite+0x8e>
80103abf:	eb 67                	jmp    80103b28 <pipewrite+0xb8>
80103ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103ac8:	e8 43 03 00 00       	call   80103e10 <myproc>
80103acd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ad0:	85 c9                	test   %ecx,%ecx
80103ad2:	75 34                	jne    80103b08 <pipewrite+0x98>
      wakeup(&p->nread);
80103ad4:	83 ec 0c             	sub    $0xc,%esp
80103ad7:	57                   	push   %edi
80103ad8:	e8 c3 0a 00 00       	call   801045a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103add:	58                   	pop    %eax
80103ade:	5a                   	pop    %edx
80103adf:	53                   	push   %ebx
80103ae0:	56                   	push   %esi
80103ae1:	e8 fa 09 00 00       	call   801044e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ae6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103aec:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103af2:	83 c4 10             	add    $0x10,%esp
80103af5:	05 00 02 00 00       	add    $0x200,%eax
80103afa:	39 c2                	cmp    %eax,%edx
80103afc:	75 2a                	jne    80103b28 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103afe:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b04:	85 c0                	test   %eax,%eax
80103b06:	75 c0                	jne    80103ac8 <pipewrite+0x58>
        release(&p->lock);
80103b08:	83 ec 0c             	sub    $0xc,%esp
80103b0b:	53                   	push   %ebx
80103b0c:	e8 6f 12 00 00       	call   80104d80 <release>
        return -1;
80103b11:	83 c4 10             	add    $0x10,%esp
80103b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b1c:	5b                   	pop    %ebx
80103b1d:	5e                   	pop    %esi
80103b1e:	5f                   	pop    %edi
80103b1f:	5d                   	pop    %ebp
80103b20:	c3                   	ret    
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b28:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b2b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b2e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b34:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b3a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
80103b3d:	83 c6 01             	add    $0x1,%esi
80103b40:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b43:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b47:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b4a:	0f 85 58 ff ff ff    	jne    80103aa8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b59:	50                   	push   %eax
80103b5a:	e8 41 0a 00 00       	call   801045a0 <wakeup>
  release(&p->lock);
80103b5f:	89 1c 24             	mov    %ebx,(%esp)
80103b62:	e8 19 12 00 00       	call   80104d80 <release>
  return n;
80103b67:	8b 45 10             	mov    0x10(%ebp),%eax
80103b6a:	83 c4 10             	add    $0x10,%esp
80103b6d:	eb aa                	jmp    80103b19 <pipewrite+0xa9>
80103b6f:	90                   	nop

80103b70 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 18             	sub    $0x18,%esp
80103b79:	8b 75 08             	mov    0x8(%ebp),%esi
80103b7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b7f:	56                   	push   %esi
80103b80:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b86:	e8 55 12 00 00       	call   80104de0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b8b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b91:	83 c4 10             	add    $0x10,%esp
80103b94:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103b9a:	74 2f                	je     80103bcb <piperead+0x5b>
80103b9c:	eb 37                	jmp    80103bd5 <piperead+0x65>
80103b9e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103ba0:	e8 6b 02 00 00       	call   80103e10 <myproc>
80103ba5:	8b 48 24             	mov    0x24(%eax),%ecx
80103ba8:	85 c9                	test   %ecx,%ecx
80103baa:	0f 85 80 00 00 00    	jne    80103c30 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103bb0:	83 ec 08             	sub    $0x8,%esp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	e8 26 09 00 00       	call   801044e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bba:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103bc0:	83 c4 10             	add    $0x10,%esp
80103bc3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103bc9:	75 0a                	jne    80103bd5 <piperead+0x65>
80103bcb:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103bd1:	85 c0                	test   %eax,%eax
80103bd3:	75 cb                	jne    80103ba0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bd5:	8b 55 10             	mov    0x10(%ebp),%edx
80103bd8:	31 db                	xor    %ebx,%ebx
80103bda:	85 d2                	test   %edx,%edx
80103bdc:	7f 20                	jg     80103bfe <piperead+0x8e>
80103bde:	eb 2c                	jmp    80103c0c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103be0:	8d 48 01             	lea    0x1(%eax),%ecx
80103be3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103be8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103bee:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103bf3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bf6:	83 c3 01             	add    $0x1,%ebx
80103bf9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103bfc:	74 0e                	je     80103c0c <piperead+0x9c>
    if(p->nread == p->nwrite)
80103bfe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c04:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c0a:	75 d4                	jne    80103be0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c0c:	83 ec 0c             	sub    $0xc,%esp
80103c0f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c15:	50                   	push   %eax
80103c16:	e8 85 09 00 00       	call   801045a0 <wakeup>
  release(&p->lock);
80103c1b:	89 34 24             	mov    %esi,(%esp)
80103c1e:	e8 5d 11 00 00       	call   80104d80 <release>
  return i;
80103c23:	83 c4 10             	add    $0x10,%esp
}
80103c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c29:	89 d8                	mov    %ebx,%eax
80103c2b:	5b                   	pop    %ebx
80103c2c:	5e                   	pop    %esi
80103c2d:	5f                   	pop    %edi
80103c2e:	5d                   	pop    %ebp
80103c2f:	c3                   	ret    
      release(&p->lock);
80103c30:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103c33:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103c38:	56                   	push   %esi
80103c39:	e8 42 11 00 00       	call   80104d80 <release>
      return -1;
80103c3e:	83 c4 10             	add    $0x10,%esp
}
80103c41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c44:	89 d8                	mov    %ebx,%eax
80103c46:	5b                   	pop    %ebx
80103c47:	5e                   	pop    %esi
80103c48:	5f                   	pop    %edi
80103c49:	5d                   	pop    %ebp
80103c4a:	c3                   	ret    
80103c4b:	66 90                	xchg   %ax,%ax
80103c4d:	66 90                	xchg   %ax,%ax
80103c4f:	90                   	nop

80103c50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c54:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
{
80103c59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c5c:	68 a0 2d 11 80       	push   $0x80112da0
80103c61:	e8 7a 11 00 00       	call   80104de0 <acquire>
80103c66:	83 c4 10             	add    $0x10,%esp
80103c69:	eb 10                	jmp    80103c7b <allocproc+0x2b>
80103c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c6f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	83 c3 7c             	add    $0x7c,%ebx
80103c73:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80103c79:	74 75                	je     80103cf0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103c7b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c7e:	85 c0                	test   %eax,%eax
80103c80:	75 ee                	jne    80103c70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c82:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103c87:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c8a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c91:	89 43 10             	mov    %eax,0x10(%ebx)
80103c94:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103c97:	68 a0 2d 11 80       	push   $0x80112da0
  p->pid = nextpid++;
80103c9c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103ca2:	e8 d9 10 00 00       	call   80104d80 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ca7:	e8 74 ee ff ff       	call   80102b20 <kalloc>
80103cac:	83 c4 10             	add    $0x10,%esp
80103caf:	89 43 08             	mov    %eax,0x8(%ebx)
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	74 53                	je     80103d09 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cb6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cbc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cbf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cc4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cc7:	c7 40 14 5d 61 10 80 	movl   $0x8010615d,0x14(%eax)
  p->context = (struct context*)sp;
80103cce:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cd1:	6a 14                	push   $0x14
80103cd3:	6a 00                	push   $0x0
80103cd5:	50                   	push   %eax
80103cd6:	e8 c5 11 00 00       	call   80104ea0 <memset>
  p->context->eip = (uint)forkret;
80103cdb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103cde:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ce1:	c7 40 10 20 3d 10 80 	movl   $0x80103d20,0x10(%eax)
}
80103ce8:	89 d8                	mov    %ebx,%eax
80103cea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ced:	c9                   	leave  
80103cee:	c3                   	ret    
80103cef:	90                   	nop
  release(&ptable.lock);
80103cf0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103cf3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103cf5:	68 a0 2d 11 80       	push   $0x80112da0
80103cfa:	e8 81 10 00 00       	call   80104d80 <release>
}
80103cff:	89 d8                	mov    %ebx,%eax
  return 0;
80103d01:	83 c4 10             	add    $0x10,%esp
}
80103d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d07:	c9                   	leave  
80103d08:	c3                   	ret    
    p->state = UNUSED;
80103d09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d10:	31 db                	xor    %ebx,%ebx
}
80103d12:	89 d8                	mov    %ebx,%eax
80103d14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d17:	c9                   	leave  
80103d18:	c3                   	ret    
80103d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103d26:	68 a0 2d 11 80       	push   $0x80112da0
80103d2b:	e8 50 10 00 00       	call   80104d80 <release>

  if (first) {
80103d30:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	85 c0                	test   %eax,%eax
80103d3a:	75 04                	jne    80103d40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103d3c:	c9                   	leave  
80103d3d:	c3                   	ret    
80103d3e:	66 90                	xchg   %ax,%ax
    first = 0;
80103d40:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103d47:	00 00 00 
    iinit(ROOTDEV);
80103d4a:	83 ec 0c             	sub    $0xc,%esp
80103d4d:	6a 01                	push   $0x1
80103d4f:	e8 ac dc ff ff       	call   80101a00 <iinit>
    initlog(ROOTDEV);
80103d54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103d5b:	e8 00 f4 ff ff       	call   80103160 <initlog>
}
80103d60:	83 c4 10             	add    $0x10,%esp
80103d63:	c9                   	leave  
80103d64:	c3                   	ret    
80103d65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d70 <pinit>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103d76:	68 e0 7f 10 80       	push   $0x80107fe0
80103d7b:	68 a0 2d 11 80       	push   $0x80112da0
80103d80:	e8 8b 0e 00 00       	call   80104c10 <initlock>
}
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	c9                   	leave  
80103d89:	c3                   	ret    
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d90 <mycpu>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d95:	9c                   	pushf  
80103d96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d97:	f6 c4 02             	test   $0x2,%ah
80103d9a:	75 46                	jne    80103de2 <mycpu+0x52>
  apicid = lapicid();
80103d9c:	e8 ef ef ff ff       	call   80102d90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103da1:	8b 35 84 27 11 80    	mov    0x80112784,%esi
80103da7:	85 f6                	test   %esi,%esi
80103da9:	7e 2a                	jle    80103dd5 <mycpu+0x45>
80103dab:	31 d2                	xor    %edx,%edx
80103dad:	eb 08                	jmp    80103db7 <mycpu+0x27>
80103daf:	90                   	nop
80103db0:	83 c2 01             	add    $0x1,%edx
80103db3:	39 f2                	cmp    %esi,%edx
80103db5:	74 1e                	je     80103dd5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103db7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103dbd:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103dc4:	39 c3                	cmp    %eax,%ebx
80103dc6:	75 e8                	jne    80103db0 <mycpu+0x20>
}
80103dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103dcb:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103dd1:	5b                   	pop    %ebx
80103dd2:	5e                   	pop    %esi
80103dd3:	5d                   	pop    %ebp
80103dd4:	c3                   	ret    
  panic("unknown apicid\n");
80103dd5:	83 ec 0c             	sub    $0xc,%esp
80103dd8:	68 e7 7f 10 80       	push   $0x80107fe7
80103ddd:	e8 9e c5 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103de2:	83 ec 0c             	sub    $0xc,%esp
80103de5:	68 c4 80 10 80       	push   $0x801080c4
80103dea:	e8 91 c5 ff ff       	call   80100380 <panic>
80103def:	90                   	nop

80103df0 <cpuid>:
cpuid() {
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103df6:	e8 95 ff ff ff       	call   80103d90 <mycpu>
}
80103dfb:	c9                   	leave  
  return mycpu()-cpus;
80103dfc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103e01:	c1 f8 04             	sar    $0x4,%eax
80103e04:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103e0a:	c3                   	ret    
80103e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop

80103e10 <myproc>:
myproc(void) {
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	53                   	push   %ebx
80103e14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103e17:	e8 74 0e 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103e1c:	e8 6f ff ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103e21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e27:	e8 b4 0e 00 00       	call   80104ce0 <popcli>
}
80103e2c:	89 d8                	mov    %ebx,%eax
80103e2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e31:	c9                   	leave  
80103e32:	c3                   	ret    
80103e33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e40 <userinit>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103e47:	e8 04 fe ff ff       	call   80103c50 <allocproc>
80103e4c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103e4e:	a3 d4 4c 11 80       	mov    %eax,0x80114cd4
  if((p->pgdir = setupkvm()) == 0)
80103e53:	e8 f8 38 00 00       	call   80107750 <setupkvm>
80103e58:	89 43 04             	mov    %eax,0x4(%ebx)
80103e5b:	85 c0                	test   %eax,%eax
80103e5d:	0f 84 bd 00 00 00    	je     80103f20 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103e63:	83 ec 04             	sub    $0x4,%esp
80103e66:	68 2c 00 00 00       	push   $0x2c
80103e6b:	68 60 b4 10 80       	push   $0x8010b460
80103e70:	50                   	push   %eax
80103e71:	e8 8a 35 00 00       	call   80107400 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103e76:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103e79:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103e7f:	6a 4c                	push   $0x4c
80103e81:	6a 00                	push   $0x0
80103e83:	ff 73 18             	push   0x18(%ebx)
80103e86:	e8 15 10 00 00       	call   80104ea0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e8b:	8b 43 18             	mov    0x18(%ebx),%eax
80103e8e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103e93:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e96:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103e9b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103e9f:	8b 43 18             	mov    0x18(%ebx),%eax
80103ea2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ea6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ea9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ead:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103eb1:	8b 43 18             	mov    0x18(%ebx),%eax
80103eb4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103eb8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ebc:	8b 43 18             	mov    0x18(%ebx),%eax
80103ebf:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103ec6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ec9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ed0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ed3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103eda:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103edd:	6a 10                	push   $0x10
80103edf:	68 10 80 10 80       	push   $0x80108010
80103ee4:	50                   	push   %eax
80103ee5:	e8 76 11 00 00       	call   80105060 <safestrcpy>
  p->cwd = namei("/");
80103eea:	c7 04 24 19 80 10 80 	movl   $0x80108019,(%esp)
80103ef1:	e8 4a e6 ff ff       	call   80102540 <namei>
80103ef6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ef9:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f00:	e8 db 0e 00 00       	call   80104de0 <acquire>
  p->state = RUNNABLE;
80103f05:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103f0c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103f13:	e8 68 0e 00 00       	call   80104d80 <release>
}
80103f18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f1b:	83 c4 10             	add    $0x10,%esp
80103f1e:	c9                   	leave  
80103f1f:	c3                   	ret    
    panic("userinit: out of memory?");
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	68 f7 7f 10 80       	push   $0x80107ff7
80103f28:	e8 53 c4 ff ff       	call   80100380 <panic>
80103f2d:	8d 76 00             	lea    0x0(%esi),%esi

80103f30 <growproc>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
80103f35:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f38:	e8 53 0d 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103f3d:	e8 4e fe ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103f42:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f48:	e8 93 0d 00 00       	call   80104ce0 <popcli>
  sz = curproc->sz;
80103f4d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f4f:	85 f6                	test   %esi,%esi
80103f51:	7f 1d                	jg     80103f70 <growproc+0x40>
  } else if(n < 0){
80103f53:	75 3b                	jne    80103f90 <growproc+0x60>
  switchuvm(curproc);
80103f55:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f58:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f5a:	53                   	push   %ebx
80103f5b:	e8 90 33 00 00       	call   801072f0 <switchuvm>
  return 0;
80103f60:	83 c4 10             	add    $0x10,%esp
80103f63:	31 c0                	xor    %eax,%eax
}
80103f65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f68:	5b                   	pop    %ebx
80103f69:	5e                   	pop    %esi
80103f6a:	5d                   	pop    %ebp
80103f6b:	c3                   	ret    
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f70:	83 ec 04             	sub    $0x4,%esp
80103f73:	01 c6                	add    %eax,%esi
80103f75:	56                   	push   %esi
80103f76:	50                   	push   %eax
80103f77:	ff 73 04             	push   0x4(%ebx)
80103f7a:	e8 f1 35 00 00       	call   80107570 <allocuvm>
80103f7f:	83 c4 10             	add    $0x10,%esp
80103f82:	85 c0                	test   %eax,%eax
80103f84:	75 cf                	jne    80103f55 <growproc+0x25>
      return -1;
80103f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f8b:	eb d8                	jmp    80103f65 <growproc+0x35>
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f90:	83 ec 04             	sub    $0x4,%esp
80103f93:	01 c6                	add    %eax,%esi
80103f95:	56                   	push   %esi
80103f96:	50                   	push   %eax
80103f97:	ff 73 04             	push   0x4(%ebx)
80103f9a:	e8 01 37 00 00       	call   801076a0 <deallocuvm>
80103f9f:	83 c4 10             	add    $0x10,%esp
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	75 af                	jne    80103f55 <growproc+0x25>
80103fa6:	eb de                	jmp    80103f86 <growproc+0x56>
80103fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103faf:	90                   	nop

80103fb0 <fork>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
80103fb6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103fb9:	e8 d2 0c 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80103fbe:	e8 cd fd ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80103fc3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fc9:	e8 12 0d 00 00       	call   80104ce0 <popcli>
  if((np = allocproc()) == 0){
80103fce:	e8 7d fc ff ff       	call   80103c50 <allocproc>
80103fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103fd6:	85 c0                	test   %eax,%eax
80103fd8:	0f 84 b7 00 00 00    	je     80104095 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103fde:	83 ec 08             	sub    $0x8,%esp
80103fe1:	ff 33                	push   (%ebx)
80103fe3:	89 c7                	mov    %eax,%edi
80103fe5:	ff 73 04             	push   0x4(%ebx)
80103fe8:	e8 53 38 00 00       	call   80107840 <copyuvm>
80103fed:	83 c4 10             	add    $0x10,%esp
80103ff0:	89 47 04             	mov    %eax,0x4(%edi)
80103ff3:	85 c0                	test   %eax,%eax
80103ff5:	0f 84 a1 00 00 00    	je     8010409c <fork+0xec>
  np->sz = curproc->sz;
80103ffb:	8b 03                	mov    (%ebx),%eax
80103ffd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104000:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104002:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104005:	89 c8                	mov    %ecx,%eax
80104007:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010400a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010400f:	8b 73 18             	mov    0x18(%ebx),%esi
80104012:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104014:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104016:	8b 40 18             	mov    0x18(%eax),%eax
80104019:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104020:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104024:	85 c0                	test   %eax,%eax
80104026:	74 13                	je     8010403b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104028:	83 ec 0c             	sub    $0xc,%esp
8010402b:	50                   	push   %eax
8010402c:	e8 0f d3 ff ff       	call   80101340 <filedup>
80104031:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104034:	83 c4 10             	add    $0x10,%esp
80104037:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010403b:	83 c6 01             	add    $0x1,%esi
8010403e:	83 fe 10             	cmp    $0x10,%esi
80104041:	75 dd                	jne    80104020 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104043:	83 ec 0c             	sub    $0xc,%esp
80104046:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104049:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010404c:	e8 9f db ff ff       	call   80101bf0 <idup>
80104051:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104054:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104057:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010405a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010405d:	6a 10                	push   $0x10
8010405f:	53                   	push   %ebx
80104060:	50                   	push   %eax
80104061:	e8 fa 0f 00 00       	call   80105060 <safestrcpy>
  pid = np->pid;
80104066:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104069:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104070:	e8 6b 0d 00 00       	call   80104de0 <acquire>
  np->state = RUNNABLE;
80104075:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010407c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104083:	e8 f8 0c 00 00       	call   80104d80 <release>
  return pid;
80104088:	83 c4 10             	add    $0x10,%esp
}
8010408b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010408e:	89 d8                	mov    %ebx,%eax
80104090:	5b                   	pop    %ebx
80104091:	5e                   	pop    %esi
80104092:	5f                   	pop    %edi
80104093:	5d                   	pop    %ebp
80104094:	c3                   	ret    
    return -1;
80104095:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010409a:	eb ef                	jmp    8010408b <fork+0xdb>
    kfree(np->kstack);
8010409c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010409f:	83 ec 0c             	sub    $0xc,%esp
801040a2:	ff 73 08             	push   0x8(%ebx)
801040a5:	e8 b6 e8 ff ff       	call   80102960 <kfree>
    np->kstack = 0;
801040aa:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801040b1:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801040b4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801040c0:	eb c9                	jmp    8010408b <fork+0xdb>
801040c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040d0 <scheduler>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	57                   	push   %edi
801040d4:	56                   	push   %esi
801040d5:	53                   	push   %ebx
801040d6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801040d9:	e8 b2 fc ff ff       	call   80103d90 <mycpu>
  c->proc = 0;
801040de:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040e5:	00 00 00 
  struct cpu *c = mycpu();
801040e8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801040ea:	8d 78 04             	lea    0x4(%eax),%edi
801040ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801040f0:	fb                   	sti    
    acquire(&ptable.lock);
801040f1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f4:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
    acquire(&ptable.lock);
801040f9:	68 a0 2d 11 80       	push   $0x80112da0
801040fe:	e8 dd 0c 00 00       	call   80104de0 <acquire>
80104103:	83 c4 10             	add    $0x10,%esp
80104106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010410d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80104110:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104114:	75 33                	jne    80104149 <scheduler+0x79>
      switchuvm(p);
80104116:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104119:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010411f:	53                   	push   %ebx
80104120:	e8 cb 31 00 00       	call   801072f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104125:	58                   	pop    %eax
80104126:	5a                   	pop    %edx
80104127:	ff 73 1c             	push   0x1c(%ebx)
8010412a:	57                   	push   %edi
      p->state = RUNNING;
8010412b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104132:	e8 84 0f 00 00       	call   801050bb <swtch>
      switchkvm();
80104137:	e8 a4 31 00 00       	call   801072e0 <switchkvm>
      c->proc = 0;
8010413c:	83 c4 10             	add    $0x10,%esp
8010413f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104146:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104149:	83 c3 7c             	add    $0x7c,%ebx
8010414c:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
80104152:	75 bc                	jne    80104110 <scheduler+0x40>
    release(&ptable.lock);
80104154:	83 ec 0c             	sub    $0xc,%esp
80104157:	68 a0 2d 11 80       	push   $0x80112da0
8010415c:	e8 1f 0c 00 00       	call   80104d80 <release>
    sti();
80104161:	83 c4 10             	add    $0x10,%esp
80104164:	eb 8a                	jmp    801040f0 <scheduler+0x20>
80104166:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010416d:	8d 76 00             	lea    0x0(%esi),%esi

80104170 <sched>:
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
  pushcli();
80104175:	e8 16 0b 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010417a:	e8 11 fc ff ff       	call   80103d90 <mycpu>
  p = c->proc;
8010417f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104185:	e8 56 0b 00 00       	call   80104ce0 <popcli>
  if(!holding(&ptable.lock))
8010418a:	83 ec 0c             	sub    $0xc,%esp
8010418d:	68 a0 2d 11 80       	push   $0x80112da0
80104192:	e8 a9 0b 00 00       	call   80104d40 <holding>
80104197:	83 c4 10             	add    $0x10,%esp
8010419a:	85 c0                	test   %eax,%eax
8010419c:	74 4f                	je     801041ed <sched+0x7d>
  if(mycpu()->ncli != 1)
8010419e:	e8 ed fb ff ff       	call   80103d90 <mycpu>
801041a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801041aa:	75 68                	jne    80104214 <sched+0xa4>
  if(p->state == RUNNING)
801041ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041b0:	74 55                	je     80104207 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041b2:	9c                   	pushf  
801041b3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801041b4:	f6 c4 02             	test   $0x2,%ah
801041b7:	75 41                	jne    801041fa <sched+0x8a>
  intena = mycpu()->intena;
801041b9:	e8 d2 fb ff ff       	call   80103d90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041be:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801041c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041c7:	e8 c4 fb ff ff       	call   80103d90 <mycpu>
801041cc:	83 ec 08             	sub    $0x8,%esp
801041cf:	ff 70 04             	push   0x4(%eax)
801041d2:	53                   	push   %ebx
801041d3:	e8 e3 0e 00 00       	call   801050bb <swtch>
  mycpu()->intena = intena;
801041d8:	e8 b3 fb ff ff       	call   80103d90 <mycpu>
}
801041dd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801041e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041e9:	5b                   	pop    %ebx
801041ea:	5e                   	pop    %esi
801041eb:	5d                   	pop    %ebp
801041ec:	c3                   	ret    
    panic("sched ptable.lock");
801041ed:	83 ec 0c             	sub    $0xc,%esp
801041f0:	68 1b 80 10 80       	push   $0x8010801b
801041f5:	e8 86 c1 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 47 80 10 80       	push   $0x80108047
80104202:	e8 79 c1 ff ff       	call   80100380 <panic>
    panic("sched running");
80104207:	83 ec 0c             	sub    $0xc,%esp
8010420a:	68 39 80 10 80       	push   $0x80108039
8010420f:	e8 6c c1 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	68 2d 80 10 80       	push   $0x8010802d
8010421c:	e8 5f c1 ff ff       	call   80100380 <panic>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010422f:	90                   	nop

80104230 <exit>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	57                   	push   %edi
80104234:	56                   	push   %esi
80104235:	53                   	push   %ebx
80104236:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104239:	e8 d2 fb ff ff       	call   80103e10 <myproc>
  if(curproc == initproc)
8010423e:	39 05 d4 4c 11 80    	cmp    %eax,0x80114cd4
80104244:	0f 84 fd 00 00 00    	je     80104347 <exit+0x117>
8010424a:	89 c3                	mov    %eax,%ebx
8010424c:	8d 70 28             	lea    0x28(%eax),%esi
8010424f:	8d 78 68             	lea    0x68(%eax),%edi
80104252:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104258:	8b 06                	mov    (%esi),%eax
8010425a:	85 c0                	test   %eax,%eax
8010425c:	74 12                	je     80104270 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010425e:	83 ec 0c             	sub    $0xc,%esp
80104261:	50                   	push   %eax
80104262:	e8 29 d1 ff ff       	call   80101390 <fileclose>
      curproc->ofile[fd] = 0;
80104267:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010426d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104270:	83 c6 04             	add    $0x4,%esi
80104273:	39 f7                	cmp    %esi,%edi
80104275:	75 e1                	jne    80104258 <exit+0x28>
  begin_op();
80104277:	e8 84 ef ff ff       	call   80103200 <begin_op>
  iput(curproc->cwd);
8010427c:	83 ec 0c             	sub    $0xc,%esp
8010427f:	ff 73 68             	push   0x68(%ebx)
80104282:	e8 c9 da ff ff       	call   80101d50 <iput>
  end_op();
80104287:	e8 e4 ef ff ff       	call   80103270 <end_op>
  curproc->cwd = 0;
8010428c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104293:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010429a:	e8 41 0b 00 00       	call   80104de0 <acquire>
  wakeup1(curproc->parent);
8010429f:	8b 53 14             	mov    0x14(%ebx),%edx
801042a2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a5:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
801042aa:	eb 0e                	jmp    801042ba <exit+0x8a>
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042b0:	83 c0 7c             	add    $0x7c,%eax
801042b3:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
801042b8:	74 1c                	je     801042d6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
801042ba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042be:	75 f0                	jne    801042b0 <exit+0x80>
801042c0:	3b 50 20             	cmp    0x20(%eax),%edx
801042c3:	75 eb                	jne    801042b0 <exit+0x80>
      p->state = RUNNABLE;
801042c5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042cc:	83 c0 7c             	add    $0x7c,%eax
801042cf:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
801042d4:	75 e4                	jne    801042ba <exit+0x8a>
      p->parent = initproc;
801042d6:	8b 0d d4 4c 11 80    	mov    0x80114cd4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042dc:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
801042e1:	eb 10                	jmp    801042f3 <exit+0xc3>
801042e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042e7:	90                   	nop
801042e8:	83 c2 7c             	add    $0x7c,%edx
801042eb:	81 fa d4 4c 11 80    	cmp    $0x80114cd4,%edx
801042f1:	74 3b                	je     8010432e <exit+0xfe>
    if(p->parent == curproc){
801042f3:	39 5a 14             	cmp    %ebx,0x14(%edx)
801042f6:	75 f0                	jne    801042e8 <exit+0xb8>
      if(p->state == ZOMBIE)
801042f8:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801042fc:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801042ff:	75 e7                	jne    801042e8 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104301:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80104306:	eb 12                	jmp    8010431a <exit+0xea>
80104308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430f:	90                   	nop
80104310:	83 c0 7c             	add    $0x7c,%eax
80104313:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80104318:	74 ce                	je     801042e8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
8010431a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010431e:	75 f0                	jne    80104310 <exit+0xe0>
80104320:	3b 48 20             	cmp    0x20(%eax),%ecx
80104323:	75 eb                	jne    80104310 <exit+0xe0>
      p->state = RUNNABLE;
80104325:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010432c:	eb e2                	jmp    80104310 <exit+0xe0>
  curproc->state = ZOMBIE;
8010432e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104335:	e8 36 fe ff ff       	call   80104170 <sched>
  panic("zombie exit");
8010433a:	83 ec 0c             	sub    $0xc,%esp
8010433d:	68 68 80 10 80       	push   $0x80108068
80104342:	e8 39 c0 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104347:	83 ec 0c             	sub    $0xc,%esp
8010434a:	68 5b 80 10 80       	push   $0x8010805b
8010434f:	e8 2c c0 ff ff       	call   80100380 <panic>
80104354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010435b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010435f:	90                   	nop

80104360 <wait>:
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	56                   	push   %esi
80104364:	53                   	push   %ebx
  pushcli();
80104365:	e8 26 09 00 00       	call   80104c90 <pushcli>
  c = mycpu();
8010436a:	e8 21 fa ff ff       	call   80103d90 <mycpu>
  p = c->proc;
8010436f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104375:	e8 66 09 00 00       	call   80104ce0 <popcli>
  acquire(&ptable.lock);
8010437a:	83 ec 0c             	sub    $0xc,%esp
8010437d:	68 a0 2d 11 80       	push   $0x80112da0
80104382:	e8 59 0a 00 00       	call   80104de0 <acquire>
80104387:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010438a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438c:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80104391:	eb 10                	jmp    801043a3 <wait+0x43>
80104393:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104397:	90                   	nop
80104398:	83 c3 7c             	add    $0x7c,%ebx
8010439b:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
801043a1:	74 1b                	je     801043be <wait+0x5e>
      if(p->parent != curproc)
801043a3:	39 73 14             	cmp    %esi,0x14(%ebx)
801043a6:	75 f0                	jne    80104398 <wait+0x38>
      if(p->state == ZOMBIE){
801043a8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801043ac:	74 62                	je     80104410 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ae:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801043b1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043b6:	81 fb d4 4c 11 80    	cmp    $0x80114cd4,%ebx
801043bc:	75 e5                	jne    801043a3 <wait+0x43>
    if(!havekids || curproc->killed){
801043be:	85 c0                	test   %eax,%eax
801043c0:	0f 84 a0 00 00 00    	je     80104466 <wait+0x106>
801043c6:	8b 46 24             	mov    0x24(%esi),%eax
801043c9:	85 c0                	test   %eax,%eax
801043cb:	0f 85 95 00 00 00    	jne    80104466 <wait+0x106>
  pushcli();
801043d1:	e8 ba 08 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801043d6:	e8 b5 f9 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
801043db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043e1:	e8 fa 08 00 00       	call   80104ce0 <popcli>
  if(p == 0)
801043e6:	85 db                	test   %ebx,%ebx
801043e8:	0f 84 8f 00 00 00    	je     8010447d <wait+0x11d>
  p->chan = chan;
801043ee:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801043f1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043f8:	e8 73 fd ff ff       	call   80104170 <sched>
  p->chan = 0;
801043fd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104404:	eb 84                	jmp    8010438a <wait+0x2a>
80104406:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104410:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104413:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104416:	ff 73 08             	push   0x8(%ebx)
80104419:	e8 42 e5 ff ff       	call   80102960 <kfree>
        p->kstack = 0;
8010441e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104425:	5a                   	pop    %edx
80104426:	ff 73 04             	push   0x4(%ebx)
80104429:	e8 a2 32 00 00       	call   801076d0 <freevm>
        p->pid = 0;
8010442e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104435:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010443c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104440:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104447:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010444e:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104455:	e8 26 09 00 00       	call   80104d80 <release>
        return pid;
8010445a:	83 c4 10             	add    $0x10,%esp
}
8010445d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104460:	89 f0                	mov    %esi,%eax
80104462:	5b                   	pop    %ebx
80104463:	5e                   	pop    %esi
80104464:	5d                   	pop    %ebp
80104465:	c3                   	ret    
      release(&ptable.lock);
80104466:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104469:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010446e:	68 a0 2d 11 80       	push   $0x80112da0
80104473:	e8 08 09 00 00       	call   80104d80 <release>
      return -1;
80104478:	83 c4 10             	add    $0x10,%esp
8010447b:	eb e0                	jmp    8010445d <wait+0xfd>
    panic("sleep");
8010447d:	83 ec 0c             	sub    $0xc,%esp
80104480:	68 74 80 10 80       	push   $0x80108074
80104485:	e8 f6 be ff ff       	call   80100380 <panic>
8010448a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104490 <yield>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104497:	68 a0 2d 11 80       	push   $0x80112da0
8010449c:	e8 3f 09 00 00       	call   80104de0 <acquire>
  pushcli();
801044a1:	e8 ea 07 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801044a6:	e8 e5 f8 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
801044ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044b1:	e8 2a 08 00 00       	call   80104ce0 <popcli>
  myproc()->state = RUNNABLE;
801044b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044bd:	e8 ae fc ff ff       	call   80104170 <sched>
  release(&ptable.lock);
801044c2:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801044c9:	e8 b2 08 00 00       	call   80104d80 <release>
}
801044ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044d1:	83 c4 10             	add    $0x10,%esp
801044d4:	c9                   	leave  
801044d5:	c3                   	ret    
801044d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044dd:	8d 76 00             	lea    0x0(%esi),%esi

801044e0 <sleep>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	56                   	push   %esi
801044e5:	53                   	push   %ebx
801044e6:	83 ec 0c             	sub    $0xc,%esp
801044e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801044ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801044ef:	e8 9c 07 00 00       	call   80104c90 <pushcli>
  c = mycpu();
801044f4:	e8 97 f8 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
801044f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044ff:	e8 dc 07 00 00       	call   80104ce0 <popcli>
  if(p == 0)
80104504:	85 db                	test   %ebx,%ebx
80104506:	0f 84 87 00 00 00    	je     80104593 <sleep+0xb3>
  if(lk == 0)
8010450c:	85 f6                	test   %esi,%esi
8010450e:	74 76                	je     80104586 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104510:	81 fe a0 2d 11 80    	cmp    $0x80112da0,%esi
80104516:	74 50                	je     80104568 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104518:	83 ec 0c             	sub    $0xc,%esp
8010451b:	68 a0 2d 11 80       	push   $0x80112da0
80104520:	e8 bb 08 00 00       	call   80104de0 <acquire>
    release(lk);
80104525:	89 34 24             	mov    %esi,(%esp)
80104528:	e8 53 08 00 00       	call   80104d80 <release>
  p->chan = chan;
8010452d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104530:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104537:	e8 34 fc ff ff       	call   80104170 <sched>
  p->chan = 0;
8010453c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104543:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010454a:	e8 31 08 00 00       	call   80104d80 <release>
    acquire(lk);
8010454f:	89 75 08             	mov    %esi,0x8(%ebp)
80104552:	83 c4 10             	add    $0x10,%esp
}
80104555:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104558:	5b                   	pop    %ebx
80104559:	5e                   	pop    %esi
8010455a:	5f                   	pop    %edi
8010455b:	5d                   	pop    %ebp
    acquire(lk);
8010455c:	e9 7f 08 00 00       	jmp    80104de0 <acquire>
80104561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104568:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010456b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104572:	e8 f9 fb ff ff       	call   80104170 <sched>
  p->chan = 0;
80104577:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010457e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104581:	5b                   	pop    %ebx
80104582:	5e                   	pop    %esi
80104583:	5f                   	pop    %edi
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
    panic("sleep without lk");
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	68 7a 80 10 80       	push   $0x8010807a
8010458e:	e8 ed bd ff ff       	call   80100380 <panic>
    panic("sleep");
80104593:	83 ec 0c             	sub    $0xc,%esp
80104596:	68 74 80 10 80       	push   $0x80108074
8010459b:	e8 e0 bd ff ff       	call   80100380 <panic>

801045a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 10             	sub    $0x10,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801045aa:	68 a0 2d 11 80       	push   $0x80112da0
801045af:	e8 2c 08 00 00       	call   80104de0 <acquire>
801045b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045b7:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
801045bc:	eb 0c                	jmp    801045ca <wakeup+0x2a>
801045be:	66 90                	xchg   %ax,%ax
801045c0:	83 c0 7c             	add    $0x7c,%eax
801045c3:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
801045c8:	74 1c                	je     801045e6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801045ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045ce:	75 f0                	jne    801045c0 <wakeup+0x20>
801045d0:	3b 58 20             	cmp    0x20(%eax),%ebx
801045d3:	75 eb                	jne    801045c0 <wakeup+0x20>
      p->state = RUNNABLE;
801045d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045dc:	83 c0 7c             	add    $0x7c,%eax
801045df:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
801045e4:	75 e4                	jne    801045ca <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
801045e6:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
801045ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f0:	c9                   	leave  
  release(&ptable.lock);
801045f1:	e9 8a 07 00 00       	jmp    80104d80 <release>
801045f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fd:	8d 76 00             	lea    0x0(%esi),%esi

80104600 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 10             	sub    $0x10,%esp
80104607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010460a:	68 a0 2d 11 80       	push   $0x80112da0
8010460f:	e8 cc 07 00 00       	call   80104de0 <acquire>
80104614:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104617:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010461c:	eb 0c                	jmp    8010462a <kill+0x2a>
8010461e:	66 90                	xchg   %ax,%ax
80104620:	83 c0 7c             	add    $0x7c,%eax
80104623:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80104628:	74 36                	je     80104660 <kill+0x60>
    if(p->pid == pid){
8010462a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010462d:	75 f1                	jne    80104620 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010462f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104633:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010463a:	75 07                	jne    80104643 <kill+0x43>
        p->state = RUNNABLE;
8010463c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104643:	83 ec 0c             	sub    $0xc,%esp
80104646:	68 a0 2d 11 80       	push   $0x80112da0
8010464b:	e8 30 07 00 00       	call   80104d80 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104653:	83 c4 10             	add    $0x10,%esp
80104656:	31 c0                	xor    %eax,%eax
}
80104658:	c9                   	leave  
80104659:	c3                   	ret    
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104660:	83 ec 0c             	sub    $0xc,%esp
80104663:	68 a0 2d 11 80       	push   $0x80112da0
80104668:	e8 13 07 00 00       	call   80104d80 <release>
}
8010466d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104670:	83 c4 10             	add    $0x10,%esp
80104673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104678:	c9                   	leave  
80104679:	c3                   	ret    
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	57                   	push   %edi
80104684:	56                   	push   %esi
80104685:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104688:	53                   	push   %ebx
80104689:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
8010468e:	83 ec 3c             	sub    $0x3c,%esp
80104691:	eb 24                	jmp    801046b7 <procdump+0x37>
80104693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104697:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104698:	83 ec 0c             	sub    $0xc,%esp
8010469b:	68 6f 85 10 80       	push   $0x8010856f
801046a0:	e8 4b c0 ff ff       	call   801006f0 <cprintf>
801046a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a8:	83 c3 7c             	add    $0x7c,%ebx
801046ab:	81 fb 40 4d 11 80    	cmp    $0x80114d40,%ebx
801046b1:	0f 84 81 00 00 00    	je     80104738 <procdump+0xb8>
    if(p->state == UNUSED)
801046b7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046ba:	85 c0                	test   %eax,%eax
801046bc:	74 ea                	je     801046a8 <procdump+0x28>
      state = "???";
801046be:	ba 8b 80 10 80       	mov    $0x8010808b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046c3:	83 f8 05             	cmp    $0x5,%eax
801046c6:	77 11                	ja     801046d9 <procdump+0x59>
801046c8:	8b 14 85 ec 80 10 80 	mov    -0x7fef7f14(,%eax,4),%edx
      state = "???";
801046cf:	b8 8b 80 10 80       	mov    $0x8010808b,%eax
801046d4:	85 d2                	test   %edx,%edx
801046d6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046d9:	53                   	push   %ebx
801046da:	52                   	push   %edx
801046db:	ff 73 a4             	push   -0x5c(%ebx)
801046de:	68 8f 80 10 80       	push   $0x8010808f
801046e3:	e8 08 c0 ff ff       	call   801006f0 <cprintf>
    if(p->state == SLEEPING){
801046e8:	83 c4 10             	add    $0x10,%esp
801046eb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046ef:	75 a7                	jne    80104698 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046f1:	83 ec 08             	sub    $0x8,%esp
801046f4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046f7:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046fa:	50                   	push   %eax
801046fb:	8b 43 b0             	mov    -0x50(%ebx),%eax
801046fe:	8b 40 0c             	mov    0xc(%eax),%eax
80104701:	83 c0 08             	add    $0x8,%eax
80104704:	50                   	push   %eax
80104705:	e8 26 05 00 00       	call   80104c30 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010470a:	83 c4 10             	add    $0x10,%esp
8010470d:	8d 76 00             	lea    0x0(%esi),%esi
80104710:	8b 17                	mov    (%edi),%edx
80104712:	85 d2                	test   %edx,%edx
80104714:	74 82                	je     80104698 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104716:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104719:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010471c:	52                   	push   %edx
8010471d:	68 e1 7a 10 80       	push   $0x80107ae1
80104722:	e8 c9 bf ff ff       	call   801006f0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104727:	83 c4 10             	add    $0x10,%esp
8010472a:	39 fe                	cmp    %edi,%esi
8010472c:	75 e2                	jne    80104710 <procdump+0x90>
8010472e:	e9 65 ff ff ff       	jmp    80104698 <procdump+0x18>
80104733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104737:	90                   	nop
  }
}
80104738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010473b:	5b                   	pop    %ebx
8010473c:	5e                   	pop    %esi
8010473d:	5f                   	pop    %edi
8010473e:	5d                   	pop    %ebp
8010473f:	c3                   	ret    

80104740 <find_fibonacci_number>:

// find the nth fibonacci number:
int find_fibonacci_number(int n) {
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	56                   	push   %esi
80104745:	53                   	push   %ebx
80104746:	83 ec 4c             	sub    $0x4c,%esp
80104749:	8b 55 08             	mov    0x8(%ebp),%edx
    if(n > 1 && n < 4) {
8010474c:	8d 42 fe             	lea    -0x2(%edx),%eax
8010474f:	83 f8 01             	cmp    $0x1,%eax
80104752:	0f 86 4f 02 00 00    	jbe    801049a7 <find_fibonacci_number+0x267>
        return 1;
    }
    else if(n == 1) {
80104758:	83 fa 01             	cmp    $0x1,%edx
8010475b:	0f 84 4d 02 00 00    	je     801049ae <find_fibonacci_number+0x26e>
        return 0;
    }
    else if (n < 1) {
80104761:	85 d2                	test   %edx,%edx
80104763:	0f 8e 49 02 00 00    	jle    801049b2 <find_fibonacci_number+0x272>
80104769:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if(n > 1 && n < 4) {
80104770:	83 f8 02             	cmp    $0x2,%eax
80104773:	0f 84 20 02 00 00    	je     80104999 <find_fibonacci_number+0x259>
80104779:	83 e8 02             	sub    $0x2,%eax
8010477c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        return -1;
    }
    else{
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104783:	89 c1                	mov    %eax,%ecx
    if(n > 1 && n < 4) {
80104785:	89 45 c8             	mov    %eax,-0x38(%ebp)
80104788:	83 f9 01             	cmp    $0x1,%ecx
8010478b:	0f 84 98 01 00 00    	je     80104929 <find_fibonacci_number+0x1e9>
80104791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104798:	89 c8                	mov    %ecx,%eax
8010479a:	89 4d bc             	mov    %ecx,-0x44(%ebp)
8010479d:	83 f8 02             	cmp    $0x2,%eax
801047a0:	0f 84 e2 01 00 00    	je     80104988 <find_fibonacci_number+0x248>
801047a6:	83 e8 02             	sub    $0x2,%eax
801047a9:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
801047b0:	89 c1                	mov    %eax,%ecx
    if(n > 1 && n < 4) {
801047b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801047b5:	83 f9 01             	cmp    $0x1,%ecx
801047b8:	0f 84 21 01 00 00    	je     801048df <find_fibonacci_number+0x19f>
801047be:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801047c5:	89 c8                	mov    %ecx,%eax
801047c7:	89 4d b8             	mov    %ecx,-0x48(%ebp)
801047ca:	83 f8 02             	cmp    $0x2,%eax
801047cd:	0f 84 a4 01 00 00    	je     80104977 <find_fibonacci_number+0x237>
801047d3:	83 e8 02             	sub    $0x2,%eax
801047d6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
801047dd:	89 c1                	mov    %eax,%ecx
    if(n > 1 && n < 4) {
801047df:	89 45 c0             	mov    %eax,-0x40(%ebp)
801047e2:	83 f9 01             	cmp    $0x1,%ecx
801047e5:	0f 84 aa 00 00 00    	je     80104895 <find_fibonacci_number+0x155>
801047eb:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
801047f2:	89 cb                	mov    %ecx,%ebx
801047f4:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
801047f7:	83 fb 02             	cmp    $0x2,%ebx
801047fa:	0f 84 5f 01 00 00    	je     8010495f <find_fibonacci_number+0x21f>
80104800:	83 eb 02             	sub    $0x2,%ebx
80104803:	31 ff                	xor    %edi,%edi
80104805:	89 de                	mov    %ebx,%esi
80104807:	89 da                	mov    %ebx,%edx
80104809:	83 fe 01             	cmp    $0x1,%esi
8010480c:	74 46                	je     80104854 <find_fibonacci_number+0x114>
8010480e:	89 f1                	mov    %esi,%ecx
80104810:	31 db                	xor    %ebx,%ebx
80104812:	89 75 b0             	mov    %esi,-0x50(%ebp)
80104815:	89 de                	mov    %ebx,%esi
80104817:	89 cb                	mov    %ecx,%ebx
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104819:	83 ec 0c             	sub    $0xc,%esp
8010481c:	8d 43 01             	lea    0x1(%ebx),%eax
8010481f:	89 55 ac             	mov    %edx,-0x54(%ebp)
    if(n > 1 && n < 4) {
80104822:	83 eb 02             	sub    $0x2,%ebx
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104825:	50                   	push   %eax
80104826:	e8 15 ff ff ff       	call   80104740 <find_fibonacci_number>
8010482b:	83 c4 10             	add    $0x10,%esp
    if(n > 1 && n < 4) {
8010482e:	8b 55 ac             	mov    -0x54(%ebp),%edx
80104831:	01 c6                	add    %eax,%esi
80104833:	83 fb 01             	cmp    $0x1,%ebx
80104836:	77 e1                	ja     80104819 <find_fibonacci_number+0xd9>
80104838:	89 f3                	mov    %esi,%ebx
8010483a:	8b 75 b0             	mov    -0x50(%ebp),%esi
8010483d:	8d 43 01             	lea    0x1(%ebx),%eax
80104840:	01 c7                	add    %eax,%edi
80104842:	8d 46 fe             	lea    -0x2(%esi),%eax
80104845:	83 ee 01             	sub    $0x1,%esi
80104848:	83 fe 01             	cmp    $0x1,%esi
8010484b:	76 19                	jbe    80104866 <find_fibonacci_number+0x126>
8010484d:	89 c6                	mov    %eax,%esi
8010484f:	83 fe 01             	cmp    $0x1,%esi
80104852:	75 ba                	jne    8010480e <find_fibonacci_number+0xce>
80104854:	b8 01 00 00 00       	mov    $0x1,%eax
80104859:	01 c7                	add    %eax,%edi
8010485b:	8d 46 fe             	lea    -0x2(%esi),%eax
8010485e:	83 ee 01             	sub    $0x1,%esi
80104861:	83 fe 01             	cmp    $0x1,%esi
80104864:	77 e7                	ja     8010484d <find_fibonacci_number+0x10d>
80104866:	89 d3                	mov    %edx,%ebx
80104868:	83 c7 01             	add    $0x1,%edi
8010486b:	01 7d cc             	add    %edi,-0x34(%ebp)
8010486e:	83 fb 01             	cmp    $0x1,%ebx
80104871:	77 84                	ja     801047f7 <find_fibonacci_number+0xb7>
80104873:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
80104876:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104879:	83 c0 01             	add    $0x1,%eax
8010487c:	01 45 d0             	add    %eax,-0x30(%ebp)
8010487f:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104882:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104885:	83 f8 01             	cmp    $0x1,%eax
80104888:	76 1e                	jbe    801048a8 <find_fibonacci_number+0x168>
8010488a:	89 d1                	mov    %edx,%ecx
8010488c:	83 f9 01             	cmp    $0x1,%ecx
8010488f:	0f 85 56 ff ff ff    	jne    801047eb <find_fibonacci_number+0xab>
80104895:	b8 01 00 00 00       	mov    $0x1,%eax
8010489a:	01 45 d0             	add    %eax,-0x30(%ebp)
8010489d:	8d 41 ff             	lea    -0x1(%ecx),%eax
801048a0:	8d 51 fe             	lea    -0x2(%ecx),%edx
801048a3:	83 f8 01             	cmp    $0x1,%eax
801048a6:	77 e2                	ja     8010488a <find_fibonacci_number+0x14a>
801048a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
801048ab:	83 c0 01             	add    $0x1,%eax
801048ae:	01 45 d4             	add    %eax,-0x2c(%ebp)
801048b1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801048b4:	83 f8 01             	cmp    $0x1,%eax
801048b7:	0f 87 0d ff ff ff    	ja     801047ca <find_fibonacci_number+0x8a>
801048bd:	8b 4d b8             	mov    -0x48(%ebp),%ecx
801048c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801048c3:	83 c0 01             	add    $0x1,%eax
801048c6:	01 45 d8             	add    %eax,-0x28(%ebp)
801048c9:	8d 41 ff             	lea    -0x1(%ecx),%eax
801048cc:	8d 51 fe             	lea    -0x2(%ecx),%edx
801048cf:	83 f8 01             	cmp    $0x1,%eax
801048d2:	76 1e                	jbe    801048f2 <find_fibonacci_number+0x1b2>
801048d4:	89 d1                	mov    %edx,%ecx
801048d6:	83 f9 01             	cmp    $0x1,%ecx
801048d9:	0f 85 df fe ff ff    	jne    801047be <find_fibonacci_number+0x7e>
801048df:	b8 01 00 00 00       	mov    $0x1,%eax
801048e4:	01 45 d8             	add    %eax,-0x28(%ebp)
801048e7:	8d 41 ff             	lea    -0x1(%ecx),%eax
801048ea:	8d 51 fe             	lea    -0x2(%ecx),%edx
801048ed:	83 f8 01             	cmp    $0x1,%eax
801048f0:	77 e2                	ja     801048d4 <find_fibonacci_number+0x194>
801048f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801048f5:	83 c0 01             	add    $0x1,%eax
801048f8:	01 45 dc             	add    %eax,-0x24(%ebp)
801048fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801048fe:	83 f8 01             	cmp    $0x1,%eax
80104901:	0f 87 96 fe ff ff    	ja     8010479d <find_fibonacci_number+0x5d>
80104907:	8b 4d bc             	mov    -0x44(%ebp),%ecx
8010490a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010490d:	83 c0 01             	add    $0x1,%eax
80104910:	01 45 e0             	add    %eax,-0x20(%ebp)
80104913:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104916:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104919:	83 f8 01             	cmp    $0x1,%eax
8010491c:	76 1e                	jbe    8010493c <find_fibonacci_number+0x1fc>
8010491e:	89 d1                	mov    %edx,%ecx
80104920:	83 f9 01             	cmp    $0x1,%ecx
80104923:	0f 85 68 fe ff ff    	jne    80104791 <find_fibonacci_number+0x51>
80104929:	b8 01 00 00 00       	mov    $0x1,%eax
8010492e:	01 45 e0             	add    %eax,-0x20(%ebp)
80104931:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104934:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104937:	83 f8 01             	cmp    $0x1,%eax
8010493a:	77 e2                	ja     8010491e <find_fibonacci_number+0x1de>
8010493c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010493f:	83 c0 01             	add    $0x1,%eax
80104942:	01 45 e4             	add    %eax,-0x1c(%ebp)
80104945:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104948:	83 f8 01             	cmp    $0x1,%eax
8010494b:	0f 87 1f fe ff ff    	ja     80104770 <find_fibonacci_number+0x30>
80104951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104954:	83 c0 01             	add    $0x1,%eax
    }
}
80104957:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010495a:	5b                   	pop    %ebx
8010495b:	5e                   	pop    %esi
8010495c:	5f                   	pop    %edi
8010495d:	5d                   	pop    %ebp
8010495e:	c3                   	ret    
8010495f:	31 db                	xor    %ebx,%ebx
    if(n > 1 && n < 4) {
80104961:	bf 01 00 00 00       	mov    $0x1,%edi
80104966:	01 7d cc             	add    %edi,-0x34(%ebp)
80104969:	83 fb 01             	cmp    $0x1,%ebx
8010496c:	0f 87 85 fe ff ff    	ja     801047f7 <find_fibonacci_number+0xb7>
80104972:	e9 fc fe ff ff       	jmp    80104873 <find_fibonacci_number+0x133>
80104977:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
8010497e:	b8 01 00 00 00       	mov    $0x1,%eax
80104983:	e9 26 ff ff ff       	jmp    801048ae <find_fibonacci_number+0x16e>
80104988:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
8010498f:	b8 01 00 00 00       	mov    $0x1,%eax
80104994:	e9 5f ff ff ff       	jmp    801048f8 <find_fibonacci_number+0x1b8>
80104999:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
801049a0:	b8 01 00 00 00       	mov    $0x1,%eax
801049a5:	eb 9b                	jmp    80104942 <find_fibonacci_number+0x202>
801049a7:	b8 01 00 00 00       	mov    $0x1,%eax
801049ac:	eb a9                	jmp    80104957 <find_fibonacci_number+0x217>
    else if(n == 1) {
801049ae:	31 c0                	xor    %eax,%eax
801049b0:	eb a5                	jmp    80104957 <find_fibonacci_number+0x217>
    else if (n < 1) {
801049b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b7:	eb 9e                	jmp    80104957 <find_fibonacci_number+0x217>
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049c0 <update_syscalls_count>:

// an array to keep how many times each system call called
int syscalls_count[NUM_OF_SYSCALLS] = {0};

void update_syscalls_count(int num){
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	8b 45 08             	mov    0x8(%ebp),%eax
    syscalls_count[num - 1] = syscalls_count[num - 1] + 1;
}
801049c6:	5d                   	pop    %ebp
    syscalls_count[num - 1] = syscalls_count[num - 1] + 1;
801049c7:	83 04 85 1c 2d 11 80 	addl   $0x1,-0x7feed2e4(,%eax,4)
801049ce:	01 
}
801049cf:	c3                   	ret    

801049d0 <find_most_callee>:

int find_most_callee(void){
801049d0:	55                   	push   %ebp
    int most_used_sys_call = 0;
    int max_called = -1;
    
    for(int i = 0; i < NUM_OF_SYSCALLS; i++){
801049d1:	31 c0                	xor    %eax,%eax
    int max_called = -1;
801049d3:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
int find_most_callee(void){
801049d8:	89 e5                	mov    %esp,%ebp
801049da:	53                   	push   %ebx
    int most_used_sys_call = 0;
801049db:	31 db                	xor    %ebx,%ebx
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
      if(syscalls_count[i] > max_called){
801049e0:	8b 14 85 20 2d 11 80 	mov    -0x7feed2e0(,%eax,4),%edx
        most_used_sys_call = i + 1;
801049e7:	83 c0 01             	add    $0x1,%eax
      if(syscalls_count[i] > max_called){
801049ea:	39 ca                	cmp    %ecx,%edx
801049ec:	7e 04                	jle    801049f2 <find_most_callee+0x22>
801049ee:	89 d1                	mov    %edx,%ecx
        most_used_sys_call = i + 1;
801049f0:	89 c3                	mov    %eax,%ebx
    for(int i = 0; i < NUM_OF_SYSCALLS; i++){
801049f2:	83 f8 1e             	cmp    $0x1e,%eax
801049f5:	75 e9                	jne    801049e0 <find_most_callee+0x10>
        max_called = syscalls_count[i];
      }
    }

    return most_used_sys_call;
}
801049f7:	89 d8                	mov    %ebx,%eax
801049f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049fc:	c9                   	leave  
801049fd:	c3                   	ret    
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <get_children_count>:

// a function to return children count of current process:
int get_children_count(void){
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	56                   	push   %esi
80104a04:	53                   	push   %ebx
  pushcli();
80104a05:	e8 86 02 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104a0a:	e8 81 f3 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80104a0f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a15:	e8 c6 02 00 00       	call   80104ce0 <popcli>
    int pid = myproc()->pid;
    struct proc *p;
    int children_count = 0;
    
    acquire(&ptable.lock);
80104a1a:	83 ec 0c             	sub    $0xc,%esp
    int pid = myproc()->pid;
80104a1d:	8b 73 10             	mov    0x10(%ebx),%esi
    acquire(&ptable.lock);
80104a20:	68 a0 2d 11 80       	push   $0x80112da0
    int children_count = 0;
80104a25:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
80104a27:	e8 b4 03 00 00       	call   80104de0 <acquire>
80104a2c:	83 c4 10             	add    $0x10,%esp

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a2f:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80104a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent->pid == pid){
80104a38:	8b 50 14             	mov    0x14(%eax),%edx
        children_count++;
80104a3b:	39 72 10             	cmp    %esi,0x10(%edx)
80104a3e:	0f 94 c2             	sete   %dl
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a41:	83 c0 7c             	add    $0x7c,%eax
        children_count++;
80104a44:	0f b6 d2             	movzbl %dl,%edx
80104a47:	01 d3                	add    %edx,%ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a49:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80104a4e:	75 e8                	jne    80104a38 <get_children_count+0x38>
      }
    }

    release(&ptable.lock);
80104a50:	83 ec 0c             	sub    $0xc,%esp
80104a53:	68 a0 2d 11 80       	push   $0x80112da0
80104a58:	e8 23 03 00 00       	call   80104d80 <release>

    return children_count;
}
80104a5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a60:	89 d8                	mov    %ebx,%eax
80104a62:	5b                   	pop    %ebx
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <kill_first_child_process>:

// a function to kill the first child of current process:

int kill_first_child_process(void){
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	53                   	push   %ebx
80104a74:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104a77:	e8 14 02 00 00       	call   80104c90 <pushcli>
  c = mycpu();
80104a7c:	e8 0f f3 ff ff       	call   80103d90 <mycpu>
  p = c->proc;
80104a81:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a87:	e8 54 02 00 00       	call   80104ce0 <popcli>
  int pid = myproc()->pid;
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a8c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  int pid = myproc()->pid;
80104a91:	8b 4b 10             	mov    0x10(%ebx),%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a94:	eb 14                	jmp    80104aaa <kill_first_child_process+0x3a>
80104a96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 7c             	add    $0x7c,%eax
80104aa3:	3d d4 4c 11 80       	cmp    $0x80114cd4,%eax
80104aa8:	74 26                	je     80104ad0 <kill_first_child_process+0x60>
    if(p->parent->pid == pid){
80104aaa:	8b 50 14             	mov    0x14(%eax),%edx
80104aad:	39 4a 10             	cmp    %ecx,0x10(%edx)
80104ab0:	75 ee                	jne    80104aa0 <kill_first_child_process+0x30>
      kill(p->pid);
80104ab2:	83 ec 0c             	sub    $0xc,%esp
80104ab5:	ff 70 10             	push   0x10(%eax)
80104ab8:	e8 43 fb ff ff       	call   80104600 <kill>
      return 1;
    }
  }
  // If parent has no child, return -1
  return -1;
}
80104abd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 1;
80104ac0:	83 c4 10             	add    $0x10,%esp
80104ac3:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104ac8:	c9                   	leave  
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ad0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ad8:	c9                   	leave  
80104ad9:	c3                   	ret    
80104ada:	66 90                	xchg   %ax,%ax
80104adc:	66 90                	xchg   %ax,%ax
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104aea:	68 04 81 10 80       	push   $0x80108104
80104aef:	8d 43 04             	lea    0x4(%ebx),%eax
80104af2:	50                   	push   %eax
80104af3:	e8 18 01 00 00       	call   80104c10 <initlock>
  lk->name = name;
80104af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104afb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104b01:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104b04:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104b0b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b11:	c9                   	leave  
80104b12:	c3                   	ret    
80104b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b20 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b28:	8d 73 04             	lea    0x4(%ebx),%esi
80104b2b:	83 ec 0c             	sub    $0xc,%esp
80104b2e:	56                   	push   %esi
80104b2f:	e8 ac 02 00 00       	call   80104de0 <acquire>
  while (lk->locked) {
80104b34:	8b 13                	mov    (%ebx),%edx
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 d2                	test   %edx,%edx
80104b3b:	74 16                	je     80104b53 <acquiresleep+0x33>
80104b3d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104b40:	83 ec 08             	sub    $0x8,%esp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
80104b45:	e8 96 f9 ff ff       	call   801044e0 <sleep>
  while (lk->locked) {
80104b4a:	8b 03                	mov    (%ebx),%eax
80104b4c:	83 c4 10             	add    $0x10,%esp
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	75 ed                	jne    80104b40 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b53:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b59:	e8 b2 f2 ff ff       	call   80103e10 <myproc>
80104b5e:	8b 40 10             	mov    0x10(%eax),%eax
80104b61:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b64:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b67:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b6a:	5b                   	pop    %ebx
80104b6b:	5e                   	pop    %esi
80104b6c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b6d:	e9 0e 02 00 00       	jmp    80104d80 <release>
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b80 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b88:	8d 73 04             	lea    0x4(%ebx),%esi
80104b8b:	83 ec 0c             	sub    $0xc,%esp
80104b8e:	56                   	push   %esi
80104b8f:	e8 4c 02 00 00       	call   80104de0 <acquire>
  lk->locked = 0;
80104b94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b9a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104ba1:	89 1c 24             	mov    %ebx,(%esp)
80104ba4:	e8 f7 f9 ff ff       	call   801045a0 <wakeup>
  release(&lk->lk);
80104ba9:	89 75 08             	mov    %esi,0x8(%ebp)
80104bac:	83 c4 10             	add    $0x10,%esp
}
80104baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5d                   	pop    %ebp
  release(&lk->lk);
80104bb5:	e9 c6 01 00 00       	jmp    80104d80 <release>
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104bc0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	31 ff                	xor    %edi,%edi
80104bc6:	56                   	push   %esi
80104bc7:	53                   	push   %ebx
80104bc8:	83 ec 18             	sub    $0x18,%esp
80104bcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104bce:	8d 73 04             	lea    0x4(%ebx),%esi
80104bd1:	56                   	push   %esi
80104bd2:	e8 09 02 00 00       	call   80104de0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104bd7:	8b 03                	mov    (%ebx),%eax
80104bd9:	83 c4 10             	add    $0x10,%esp
80104bdc:	85 c0                	test   %eax,%eax
80104bde:	75 18                	jne    80104bf8 <holdingsleep+0x38>
  release(&lk->lk);
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	56                   	push   %esi
80104be4:	e8 97 01 00 00       	call   80104d80 <release>
  return r;
}
80104be9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bec:	89 f8                	mov    %edi,%eax
80104bee:	5b                   	pop    %ebx
80104bef:	5e                   	pop    %esi
80104bf0:	5f                   	pop    %edi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret    
80104bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104bf8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bfb:	e8 10 f2 ff ff       	call   80103e10 <myproc>
80104c00:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c03:	0f 94 c0             	sete   %al
80104c06:	0f b6 c0             	movzbl %al,%eax
80104c09:	89 c7                	mov    %eax,%edi
80104c0b:	eb d3                	jmp    80104be0 <holdingsleep+0x20>
80104c0d:	66 90                	xchg   %ax,%ax
80104c0f:	90                   	nop

80104c10 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104c1f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104c22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104c30:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104c31:	31 d2                	xor    %edx,%edx
{
80104c33:	89 e5                	mov    %esp,%ebp
80104c35:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104c36:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104c39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104c3c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104c3f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104c46:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104c4c:	77 1a                	ja     80104c68 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104c4e:	8b 58 04             	mov    0x4(%eax),%ebx
80104c51:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c54:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c57:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c59:	83 fa 0a             	cmp    $0xa,%edx
80104c5c:	75 e2                	jne    80104c40 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c61:	c9                   	leave  
80104c62:	c3                   	ret    
80104c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c67:	90                   	nop
  for(; i < 10; i++)
80104c68:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c6b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c76:	83 c0 04             	add    $0x4,%eax
80104c79:	39 d0                	cmp    %edx,%eax
80104c7b:	75 f3                	jne    80104c70 <getcallerpcs+0x40>
}
80104c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c80:	c9                   	leave  
80104c81:	c3                   	ret    
80104c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c90 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	53                   	push   %ebx
80104c94:	83 ec 04             	sub    $0x4,%esp
80104c97:	9c                   	pushf  
80104c98:	5b                   	pop    %ebx
  asm volatile("cli");
80104c99:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c9a:	e8 f1 f0 ff ff       	call   80103d90 <mycpu>
80104c9f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	74 17                	je     80104cc0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104ca9:	e8 e2 f0 ff ff       	call   80103d90 <mycpu>
80104cae:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104cb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb8:	c9                   	leave  
80104cb9:	c3                   	ret    
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104cc0:	e8 cb f0 ff ff       	call   80103d90 <mycpu>
80104cc5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104ccb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104cd1:	eb d6                	jmp    80104ca9 <pushcli+0x19>
80104cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <popcli>:

void
popcli(void)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ce6:	9c                   	pushf  
80104ce7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104ce8:	f6 c4 02             	test   $0x2,%ah
80104ceb:	75 35                	jne    80104d22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ced:	e8 9e f0 ff ff       	call   80103d90 <mycpu>
80104cf2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104cf9:	78 34                	js     80104d2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cfb:	e8 90 f0 ff ff       	call   80103d90 <mycpu>
80104d00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104d06:	85 d2                	test   %edx,%edx
80104d08:	74 06                	je     80104d10 <popcli+0x30>
    sti();
}
80104d0a:	c9                   	leave  
80104d0b:	c3                   	ret    
80104d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d10:	e8 7b f0 ff ff       	call   80103d90 <mycpu>
80104d15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	74 eb                	je     80104d0a <popcli+0x2a>
  asm volatile("sti");
80104d1f:	fb                   	sti    
}
80104d20:	c9                   	leave  
80104d21:	c3                   	ret    
    panic("popcli - interruptible");
80104d22:	83 ec 0c             	sub    $0xc,%esp
80104d25:	68 0f 81 10 80       	push   $0x8010810f
80104d2a:	e8 51 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104d2f:	83 ec 0c             	sub    $0xc,%esp
80104d32:	68 26 81 10 80       	push   $0x80108126
80104d37:	e8 44 b6 ff ff       	call   80100380 <panic>
80104d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d40 <holding>:
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 75 08             	mov    0x8(%ebp),%esi
80104d48:	31 db                	xor    %ebx,%ebx
  pushcli();
80104d4a:	e8 41 ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d4f:	8b 06                	mov    (%esi),%eax
80104d51:	85 c0                	test   %eax,%eax
80104d53:	75 0b                	jne    80104d60 <holding+0x20>
  popcli();
80104d55:	e8 86 ff ff ff       	call   80104ce0 <popcli>
}
80104d5a:	89 d8                	mov    %ebx,%eax
80104d5c:	5b                   	pop    %ebx
80104d5d:	5e                   	pop    %esi
80104d5e:	5d                   	pop    %ebp
80104d5f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d60:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d63:	e8 28 f0 ff ff       	call   80103d90 <mycpu>
80104d68:	39 c3                	cmp    %eax,%ebx
80104d6a:	0f 94 c3             	sete   %bl
  popcli();
80104d6d:	e8 6e ff ff ff       	call   80104ce0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d72:	0f b6 db             	movzbl %bl,%ebx
}
80104d75:	89 d8                	mov    %ebx,%eax
80104d77:	5b                   	pop    %ebx
80104d78:	5e                   	pop    %esi
80104d79:	5d                   	pop    %ebp
80104d7a:	c3                   	ret    
80104d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d7f:	90                   	nop

80104d80 <release>:
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d88:	e8 03 ff ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d8d:	8b 03                	mov    (%ebx),%eax
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	75 15                	jne    80104da8 <release+0x28>
  popcli();
80104d93:	e8 48 ff ff ff       	call   80104ce0 <popcli>
    panic("release");
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	68 2d 81 10 80       	push   $0x8010812d
80104da0:	e8 db b5 ff ff       	call   80100380 <panic>
80104da5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104da8:	8b 73 08             	mov    0x8(%ebx),%esi
80104dab:	e8 e0 ef ff ff       	call   80103d90 <mycpu>
80104db0:	39 c6                	cmp    %eax,%esi
80104db2:	75 df                	jne    80104d93 <release+0x13>
  popcli();
80104db4:	e8 27 ff ff ff       	call   80104ce0 <popcli>
  lk->pcs[0] = 0;
80104db9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104dc0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104dc7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104dcc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104dd2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
  popcli();
80104dd8:	e9 03 ff ff ff       	jmp    80104ce0 <popcli>
80104ddd:	8d 76 00             	lea    0x0(%esi),%esi

80104de0 <acquire>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104de7:	e8 a4 fe ff ff       	call   80104c90 <pushcli>
  if(holding(lk))
80104dec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104def:	e8 9c fe ff ff       	call   80104c90 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104df4:	8b 03                	mov    (%ebx),%eax
80104df6:	85 c0                	test   %eax,%eax
80104df8:	75 7e                	jne    80104e78 <acquire+0x98>
  popcli();
80104dfa:	e8 e1 fe ff ff       	call   80104ce0 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104dff:	b9 01 00 00 00       	mov    $0x1,%ecx
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104e08:	8b 55 08             	mov    0x8(%ebp),%edx
80104e0b:	89 c8                	mov    %ecx,%eax
80104e0d:	f0 87 02             	lock xchg %eax,(%edx)
80104e10:	85 c0                	test   %eax,%eax
80104e12:	75 f4                	jne    80104e08 <acquire+0x28>
  __sync_synchronize();
80104e14:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e1c:	e8 6f ef ff ff       	call   80103d90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104e21:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104e24:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104e26:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104e29:	31 c0                	xor    %eax,%eax
80104e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e30:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104e36:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104e3c:	77 1a                	ja     80104e58 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104e3e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104e41:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104e45:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104e48:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104e4a:	83 f8 0a             	cmp    $0xa,%eax
80104e4d:	75 e1                	jne    80104e30 <acquire+0x50>
}
80104e4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e52:	c9                   	leave  
80104e53:	c3                   	ret    
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e58:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104e5c:	8d 51 34             	lea    0x34(%ecx),%edx
80104e5f:	90                   	nop
    pcs[i] = 0;
80104e60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e66:	83 c0 04             	add    $0x4,%eax
80104e69:	39 c2                	cmp    %eax,%edx
80104e6b:	75 f3                	jne    80104e60 <acquire+0x80>
}
80104e6d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e70:	c9                   	leave  
80104e71:	c3                   	ret    
80104e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e78:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104e7b:	e8 10 ef ff ff       	call   80103d90 <mycpu>
80104e80:	39 c3                	cmp    %eax,%ebx
80104e82:	0f 85 72 ff ff ff    	jne    80104dfa <acquire+0x1a>
  popcli();
80104e88:	e8 53 fe ff ff       	call   80104ce0 <popcli>
    panic("acquire");
80104e8d:	83 ec 0c             	sub    $0xc,%esp
80104e90:	68 35 81 10 80       	push   $0x80108135
80104e95:	e8 e6 b4 ff ff       	call   80100380 <panic>
80104e9a:	66 90                	xchg   %ax,%ax
80104e9c:	66 90                	xchg   %ax,%ax
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ea7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eaa:	53                   	push   %ebx
80104eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104eae:	89 d7                	mov    %edx,%edi
80104eb0:	09 cf                	or     %ecx,%edi
80104eb2:	83 e7 03             	and    $0x3,%edi
80104eb5:	75 29                	jne    80104ee0 <memset+0x40>
    c &= 0xFF;
80104eb7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104eba:	c1 e0 18             	shl    $0x18,%eax
80104ebd:	89 fb                	mov    %edi,%ebx
80104ebf:	c1 e9 02             	shr    $0x2,%ecx
80104ec2:	c1 e3 10             	shl    $0x10,%ebx
80104ec5:	09 d8                	or     %ebx,%eax
80104ec7:	09 f8                	or     %edi,%eax
80104ec9:	c1 e7 08             	shl    $0x8,%edi
80104ecc:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104ece:	89 d7                	mov    %edx,%edi
80104ed0:	fc                   	cld    
80104ed1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104ed3:	5b                   	pop    %ebx
80104ed4:	89 d0                	mov    %edx,%eax
80104ed6:	5f                   	pop    %edi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104ee0:	89 d7                	mov    %edx,%edi
80104ee2:	fc                   	cld    
80104ee3:	f3 aa                	rep stos %al,%es:(%edi)
80104ee5:	5b                   	pop    %ebx
80104ee6:	89 d0                	mov    %edx,%eax
80104ee8:	5f                   	pop    %edi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ef7:	8b 55 08             	mov    0x8(%ebp),%edx
80104efa:	53                   	push   %ebx
80104efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104efe:	85 f6                	test   %esi,%esi
80104f00:	74 2e                	je     80104f30 <memcmp+0x40>
80104f02:	01 c6                	add    %eax,%esi
80104f04:	eb 14                	jmp    80104f1a <memcmp+0x2a>
80104f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104f10:	83 c0 01             	add    $0x1,%eax
80104f13:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104f16:	39 f0                	cmp    %esi,%eax
80104f18:	74 16                	je     80104f30 <memcmp+0x40>
    if(*s1 != *s2)
80104f1a:	0f b6 0a             	movzbl (%edx),%ecx
80104f1d:	0f b6 18             	movzbl (%eax),%ebx
80104f20:	38 d9                	cmp    %bl,%cl
80104f22:	74 ec                	je     80104f10 <memcmp+0x20>
      return *s1 - *s2;
80104f24:	0f b6 c1             	movzbl %cl,%eax
80104f27:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5d                   	pop    %ebp
80104f2c:	c3                   	ret    
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
80104f30:	5b                   	pop    %ebx
  return 0;
80104f31:	31 c0                	xor    %eax,%eax
}
80104f33:	5e                   	pop    %esi
80104f34:	5d                   	pop    %ebp
80104f35:	c3                   	ret    
80104f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi

80104f40 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	57                   	push   %edi
80104f44:	8b 55 08             	mov    0x8(%ebp),%edx
80104f47:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f4a:	56                   	push   %esi
80104f4b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104f4e:	39 d6                	cmp    %edx,%esi
80104f50:	73 26                	jae    80104f78 <memmove+0x38>
80104f52:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f55:	39 fa                	cmp    %edi,%edx
80104f57:	73 1f                	jae    80104f78 <memmove+0x38>
80104f59:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f5c:	85 c9                	test   %ecx,%ecx
80104f5e:	74 0c                	je     80104f6c <memmove+0x2c>
      *--d = *--s;
80104f60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f64:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f67:	83 e8 01             	sub    $0x1,%eax
80104f6a:	73 f4                	jae    80104f60 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f6c:	5e                   	pop    %esi
80104f6d:	89 d0                	mov    %edx,%eax
80104f6f:	5f                   	pop    %edi
80104f70:	5d                   	pop    %ebp
80104f71:	c3                   	ret    
80104f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f78:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f7b:	89 d7                	mov    %edx,%edi
80104f7d:	85 c9                	test   %ecx,%ecx
80104f7f:	74 eb                	je     80104f6c <memmove+0x2c>
80104f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f88:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f89:	39 c6                	cmp    %eax,%esi
80104f8b:	75 fb                	jne    80104f88 <memmove+0x48>
}
80104f8d:	5e                   	pop    %esi
80104f8e:	89 d0                	mov    %edx,%eax
80104f90:	5f                   	pop    %edi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104fa0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104fa0:	eb 9e                	jmp    80104f40 <memmove>
80104fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	56                   	push   %esi
80104fb4:	8b 75 10             	mov    0x10(%ebp),%esi
80104fb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104fba:	53                   	push   %ebx
80104fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104fbe:	85 f6                	test   %esi,%esi
80104fc0:	74 2e                	je     80104ff0 <strncmp+0x40>
80104fc2:	01 d6                	add    %edx,%esi
80104fc4:	eb 18                	jmp    80104fde <strncmp+0x2e>
80104fc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
80104fd0:	38 d8                	cmp    %bl,%al
80104fd2:	75 14                	jne    80104fe8 <strncmp+0x38>
    n--, p++, q++;
80104fd4:	83 c2 01             	add    $0x1,%edx
80104fd7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104fda:	39 f2                	cmp    %esi,%edx
80104fdc:	74 12                	je     80104ff0 <strncmp+0x40>
80104fde:	0f b6 01             	movzbl (%ecx),%eax
80104fe1:	0f b6 1a             	movzbl (%edx),%ebx
80104fe4:	84 c0                	test   %al,%al
80104fe6:	75 e8                	jne    80104fd0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fe8:	29 d8                	sub    %ebx,%eax
}
80104fea:	5b                   	pop    %ebx
80104feb:	5e                   	pop    %esi
80104fec:	5d                   	pop    %ebp
80104fed:	c3                   	ret    
80104fee:	66 90                	xchg   %ax,%ax
80104ff0:	5b                   	pop    %ebx
    return 0;
80104ff1:	31 c0                	xor    %eax,%eax
}
80104ff3:	5e                   	pop    %esi
80104ff4:	5d                   	pop    %ebp
80104ff5:	c3                   	ret    
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	8b 75 08             	mov    0x8(%ebp),%esi
80105008:	53                   	push   %ebx
80105009:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010500c:	89 f0                	mov    %esi,%eax
8010500e:	eb 15                	jmp    80105025 <strncpy+0x25>
80105010:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105014:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105017:	83 c0 01             	add    $0x1,%eax
8010501a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
8010501e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105021:	84 d2                	test   %dl,%dl
80105023:	74 09                	je     8010502e <strncpy+0x2e>
80105025:	89 cb                	mov    %ecx,%ebx
80105027:	83 e9 01             	sub    $0x1,%ecx
8010502a:	85 db                	test   %ebx,%ebx
8010502c:	7f e2                	jg     80105010 <strncpy+0x10>
    ;
  while(n-- > 0)
8010502e:	89 c2                	mov    %eax,%edx
80105030:	85 c9                	test   %ecx,%ecx
80105032:	7e 17                	jle    8010504b <strncpy+0x4b>
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105038:	83 c2 01             	add    $0x1,%edx
8010503b:	89 c1                	mov    %eax,%ecx
8010503d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105041:	29 d1                	sub    %edx,%ecx
80105043:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105047:	85 c9                	test   %ecx,%ecx
80105049:	7f ed                	jg     80105038 <strncpy+0x38>
  return os;
}
8010504b:	5b                   	pop    %ebx
8010504c:	89 f0                	mov    %esi,%eax
8010504e:	5e                   	pop    %esi
8010504f:	5f                   	pop    %edi
80105050:	5d                   	pop    %ebp
80105051:	c3                   	ret    
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105060 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	8b 55 10             	mov    0x10(%ebp),%edx
80105067:	8b 75 08             	mov    0x8(%ebp),%esi
8010506a:	53                   	push   %ebx
8010506b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010506e:	85 d2                	test   %edx,%edx
80105070:	7e 25                	jle    80105097 <safestrcpy+0x37>
80105072:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105076:	89 f2                	mov    %esi,%edx
80105078:	eb 16                	jmp    80105090 <safestrcpy+0x30>
8010507a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105080:	0f b6 08             	movzbl (%eax),%ecx
80105083:	83 c0 01             	add    $0x1,%eax
80105086:	83 c2 01             	add    $0x1,%edx
80105089:	88 4a ff             	mov    %cl,-0x1(%edx)
8010508c:	84 c9                	test   %cl,%cl
8010508e:	74 04                	je     80105094 <safestrcpy+0x34>
80105090:	39 d8                	cmp    %ebx,%eax
80105092:	75 ec                	jne    80105080 <safestrcpy+0x20>
    ;
  *s = 0;
80105094:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105097:	89 f0                	mov    %esi,%eax
80105099:	5b                   	pop    %ebx
8010509a:	5e                   	pop    %esi
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi

801050a0 <strlen>:

int
strlen(const char *s)
{
801050a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801050a1:	31 c0                	xor    %eax,%eax
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801050a8:	80 3a 00             	cmpb   $0x0,(%edx)
801050ab:	74 0c                	je     801050b9 <strlen+0x19>
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
801050b0:	83 c0 01             	add    $0x1,%eax
801050b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801050b7:	75 f7                	jne    801050b0 <strlen+0x10>
    ;
  return n;
}
801050b9:	5d                   	pop    %ebp
801050ba:	c3                   	ret    

801050bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801050c3:	55                   	push   %ebp
  pushl %ebx
801050c4:	53                   	push   %ebx
  pushl %esi
801050c5:	56                   	push   %esi
  pushl %edi
801050c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801050cb:	5f                   	pop    %edi
  popl %esi
801050cc:	5e                   	pop    %esi
  popl %ebx
801050cd:	5b                   	pop    %ebx
  popl %ebp
801050ce:	5d                   	pop    %ebp
  ret
801050cf:	c3                   	ret    

801050d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	53                   	push   %ebx
801050d4:	83 ec 04             	sub    $0x4,%esp
801050d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050da:	e8 31 ed ff ff       	call   80103e10 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050df:	8b 00                	mov    (%eax),%eax
801050e1:	39 d8                	cmp    %ebx,%eax
801050e3:	76 1b                	jbe    80105100 <fetchint+0x30>
801050e5:	8d 53 04             	lea    0x4(%ebx),%edx
801050e8:	39 d0                	cmp    %edx,%eax
801050ea:	72 14                	jb     80105100 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ef:	8b 13                	mov    (%ebx),%edx
801050f1:	89 10                	mov    %edx,(%eax)
  return 0;
801050f3:	31 c0                	xor    %eax,%eax
}
801050f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f8:	c9                   	leave  
801050f9:	c3                   	ret    
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105105:	eb ee                	jmp    801050f5 <fetchint+0x25>
80105107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010510e:	66 90                	xchg   %ax,%ax

80105110 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 04             	sub    $0x4,%esp
80105117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010511a:	e8 f1 ec ff ff       	call   80103e10 <myproc>

  if(addr >= curproc->sz)
8010511f:	39 18                	cmp    %ebx,(%eax)
80105121:	76 2d                	jbe    80105150 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105123:	8b 55 0c             	mov    0xc(%ebp),%edx
80105126:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105128:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010512a:	39 d3                	cmp    %edx,%ebx
8010512c:	73 22                	jae    80105150 <fetchstr+0x40>
8010512e:	89 d8                	mov    %ebx,%eax
80105130:	eb 0d                	jmp    8010513f <fetchstr+0x2f>
80105132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105138:	83 c0 01             	add    $0x1,%eax
8010513b:	39 c2                	cmp    %eax,%edx
8010513d:	76 11                	jbe    80105150 <fetchstr+0x40>
    if(*s == 0)
8010513f:	80 38 00             	cmpb   $0x0,(%eax)
80105142:	75 f4                	jne    80105138 <fetchstr+0x28>
      return s - *pp;
80105144:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105146:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105149:	c9                   	leave  
8010514a:	c3                   	ret    
8010514b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010514f:	90                   	nop
80105150:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105153:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105158:	c9                   	leave  
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105160 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105165:	e8 a6 ec ff ff       	call   80103e10 <myproc>
8010516a:	8b 55 08             	mov    0x8(%ebp),%edx
8010516d:	8b 40 18             	mov    0x18(%eax),%eax
80105170:	8b 40 44             	mov    0x44(%eax),%eax
80105173:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105176:	e8 95 ec ff ff       	call   80103e10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010517b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010517e:	8b 00                	mov    (%eax),%eax
80105180:	39 c6                	cmp    %eax,%esi
80105182:	73 1c                	jae    801051a0 <argint+0x40>
80105184:	8d 53 08             	lea    0x8(%ebx),%edx
80105187:	39 d0                	cmp    %edx,%eax
80105189:	72 15                	jb     801051a0 <argint+0x40>
  *ip = *(int*)(addr);
8010518b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010518e:	8b 53 04             	mov    0x4(%ebx),%edx
80105191:	89 10                	mov    %edx,(%eax)
  return 0;
80105193:	31 c0                	xor    %eax,%eax
}
80105195:	5b                   	pop    %ebx
80105196:	5e                   	pop    %esi
80105197:	5d                   	pop    %ebp
80105198:	c3                   	ret    
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801051a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051a5:	eb ee                	jmp    80105195 <argint+0x35>
801051a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ae:	66 90                	xchg   %ax,%ax

801051b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051b0:	55                   	push   %ebp
801051b1:	89 e5                	mov    %esp,%ebp
801051b3:	57                   	push   %edi
801051b4:	56                   	push   %esi
801051b5:	53                   	push   %ebx
801051b6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
801051b9:	e8 52 ec ff ff       	call   80103e10 <myproc>
801051be:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051c0:	e8 4b ec ff ff       	call   80103e10 <myproc>
801051c5:	8b 55 08             	mov    0x8(%ebp),%edx
801051c8:	8b 40 18             	mov    0x18(%eax),%eax
801051cb:	8b 40 44             	mov    0x44(%eax),%eax
801051ce:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051d1:	e8 3a ec ff ff       	call   80103e10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051d9:	8b 00                	mov    (%eax),%eax
801051db:	39 c7                	cmp    %eax,%edi
801051dd:	73 31                	jae    80105210 <argptr+0x60>
801051df:	8d 4b 08             	lea    0x8(%ebx),%ecx
801051e2:	39 c8                	cmp    %ecx,%eax
801051e4:	72 2a                	jb     80105210 <argptr+0x60>

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051e6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
801051e9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801051ec:	85 d2                	test   %edx,%edx
801051ee:	78 20                	js     80105210 <argptr+0x60>
801051f0:	8b 16                	mov    (%esi),%edx
801051f2:	39 c2                	cmp    %eax,%edx
801051f4:	76 1a                	jbe    80105210 <argptr+0x60>
801051f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801051f9:	01 c3                	add    %eax,%ebx
801051fb:	39 da                	cmp    %ebx,%edx
801051fd:	72 11                	jb     80105210 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801051ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80105202:	89 02                	mov    %eax,(%edx)
  return 0;
80105204:	31 c0                	xor    %eax,%eax
}
80105206:	83 c4 0c             	add    $0xc,%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5f                   	pop    %edi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105215:	eb ef                	jmp    80105206 <argptr+0x56>
80105217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521e:	66 90                	xchg   %ax,%ax

80105220 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105225:	e8 e6 eb ff ff       	call   80103e10 <myproc>
8010522a:	8b 55 08             	mov    0x8(%ebp),%edx
8010522d:	8b 40 18             	mov    0x18(%eax),%eax
80105230:	8b 40 44             	mov    0x44(%eax),%eax
80105233:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105236:	e8 d5 eb ff ff       	call   80103e10 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010523b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010523e:	8b 00                	mov    (%eax),%eax
80105240:	39 c6                	cmp    %eax,%esi
80105242:	73 44                	jae    80105288 <argstr+0x68>
80105244:	8d 53 08             	lea    0x8(%ebx),%edx
80105247:	39 d0                	cmp    %edx,%eax
80105249:	72 3d                	jb     80105288 <argstr+0x68>
  *ip = *(int*)(addr);
8010524b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
8010524e:	e8 bd eb ff ff       	call   80103e10 <myproc>
  if(addr >= curproc->sz)
80105253:	3b 18                	cmp    (%eax),%ebx
80105255:	73 31                	jae    80105288 <argstr+0x68>
  *pp = (char*)addr;
80105257:	8b 55 0c             	mov    0xc(%ebp),%edx
8010525a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010525c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010525e:	39 d3                	cmp    %edx,%ebx
80105260:	73 26                	jae    80105288 <argstr+0x68>
80105262:	89 d8                	mov    %ebx,%eax
80105264:	eb 11                	jmp    80105277 <argstr+0x57>
80105266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	83 c0 01             	add    $0x1,%eax
80105273:	39 c2                	cmp    %eax,%edx
80105275:	76 11                	jbe    80105288 <argstr+0x68>
    if(*s == 0)
80105277:	80 38 00             	cmpb   $0x0,(%eax)
8010527a:	75 f4                	jne    80105270 <argstr+0x50>
      return s - *pp;
8010527c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010527e:	5b                   	pop    %ebx
8010527f:	5e                   	pop    %esi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105288:	5b                   	pop    %ebx
    return -1;
80105289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010528e:	5e                   	pop    %esi
8010528f:	5d                   	pop    %ebp
80105290:	c3                   	ret    
80105291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop

801052a0 <syscall>:
};


void
syscall(void)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	56                   	push   %esi
801052a4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
801052a5:	e8 66 eb ff ff       	call   80103e10 <myproc>
801052aa:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801052ac:	8b 40 18             	mov    0x18(%eax),%eax
801052af:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801052b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801052b5:	83 fa 18             	cmp    $0x18,%edx
801052b8:	77 2e                	ja     801052e8 <syscall+0x48>
801052ba:	8b 34 85 60 81 10 80 	mov    -0x7fef7ea0(,%eax,4),%esi
801052c1:	85 f6                	test   %esi,%esi
801052c3:	74 23                	je     801052e8 <syscall+0x48>
    // increase the count of how many times a system call, has been called by one.
    update_syscalls_count(num);
801052c5:	83 ec 0c             	sub    $0xc,%esp
801052c8:	50                   	push   %eax
801052c9:	e8 f2 f6 ff ff       	call   801049c0 <update_syscalls_count>
    curproc->tf->eax = syscalls[num]();
801052ce:	ff d6                	call   *%esi
801052d0:	83 c4 10             	add    $0x10,%esp
801052d3:	89 c2                	mov    %eax,%edx
801052d5:	8b 43 18             	mov    0x18(%ebx),%eax
801052d8:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052db:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052de:	5b                   	pop    %ebx
801052df:	5e                   	pop    %esi
801052e0:	5d                   	pop    %ebp
801052e1:	c3                   	ret    
801052e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
801052e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801052ec:	50                   	push   %eax
801052ed:	ff 73 10             	push   0x10(%ebx)
801052f0:	68 3d 81 10 80       	push   $0x8010813d
801052f5:	e8 f6 b3 ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
801052fa:	8b 43 18             	mov    0x18(%ebx),%eax
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105307:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010530a:	5b                   	pop    %ebx
8010530b:	5e                   	pop    %esi
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    
8010530e:	66 90                	xchg   %ax,%ax

80105310 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105315:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105318:	53                   	push   %ebx
80105319:	83 ec 34             	sub    $0x34,%esp
8010531c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010531f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105322:	57                   	push   %edi
80105323:	50                   	push   %eax
{
80105324:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105327:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010532a:	e8 31 d2 ff ff       	call   80102560 <nameiparent>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	85 c0                	test   %eax,%eax
80105334:	0f 84 46 01 00 00    	je     80105480 <create+0x170>
    return 0;
  ilock(dp);
8010533a:	83 ec 0c             	sub    $0xc,%esp
8010533d:	89 c3                	mov    %eax,%ebx
8010533f:	50                   	push   %eax
80105340:	e8 db c8 ff ff       	call   80101c20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105345:	83 c4 0c             	add    $0xc,%esp
80105348:	6a 00                	push   $0x0
8010534a:	57                   	push   %edi
8010534b:	53                   	push   %ebx
8010534c:	e8 2f ce ff ff       	call   80102180 <dirlookup>
80105351:	83 c4 10             	add    $0x10,%esp
80105354:	89 c6                	mov    %eax,%esi
80105356:	85 c0                	test   %eax,%eax
80105358:	74 56                	je     801053b0 <create+0xa0>
    iunlockput(dp);
8010535a:	83 ec 0c             	sub    $0xc,%esp
8010535d:	53                   	push   %ebx
8010535e:	e8 4d cb ff ff       	call   80101eb0 <iunlockput>
    ilock(ip);
80105363:	89 34 24             	mov    %esi,(%esp)
80105366:	e8 b5 c8 ff ff       	call   80101c20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010536b:	83 c4 10             	add    $0x10,%esp
8010536e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105373:	75 1b                	jne    80105390 <create+0x80>
80105375:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010537a:	75 14                	jne    80105390 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010537c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537f:	89 f0                	mov    %esi,%eax
80105381:	5b                   	pop    %ebx
80105382:	5e                   	pop    %esi
80105383:	5f                   	pop    %edi
80105384:	5d                   	pop    %ebp
80105385:	c3                   	ret    
80105386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	56                   	push   %esi
    return 0;
80105394:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105396:	e8 15 cb ff ff       	call   80101eb0 <iunlockput>
    return 0;
8010539b:	83 c4 10             	add    $0x10,%esp
}
8010539e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053a1:	89 f0                	mov    %esi,%eax
801053a3:	5b                   	pop    %ebx
801053a4:	5e                   	pop    %esi
801053a5:	5f                   	pop    %edi
801053a6:	5d                   	pop    %ebp
801053a7:	c3                   	ret    
801053a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053af:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801053b0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801053b4:	83 ec 08             	sub    $0x8,%esp
801053b7:	50                   	push   %eax
801053b8:	ff 33                	push   (%ebx)
801053ba:	e8 f1 c6 ff ff       	call   80101ab0 <ialloc>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	89 c6                	mov    %eax,%esi
801053c4:	85 c0                	test   %eax,%eax
801053c6:	0f 84 cd 00 00 00    	je     80105499 <create+0x189>
  ilock(ip);
801053cc:	83 ec 0c             	sub    $0xc,%esp
801053cf:	50                   	push   %eax
801053d0:	e8 4b c8 ff ff       	call   80101c20 <ilock>
  ip->major = major;
801053d5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801053d9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801053dd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801053e1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801053e5:	b8 01 00 00 00       	mov    $0x1,%eax
801053ea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801053ee:	89 34 24             	mov    %esi,(%esp)
801053f1:	e8 7a c7 ff ff       	call   80101b70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053fe:	74 30                	je     80105430 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105400:	83 ec 04             	sub    $0x4,%esp
80105403:	ff 76 04             	push   0x4(%esi)
80105406:	57                   	push   %edi
80105407:	53                   	push   %ebx
80105408:	e8 73 d0 ff ff       	call   80102480 <dirlink>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 78                	js     8010548c <create+0x17c>
  iunlockput(dp);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	53                   	push   %ebx
80105418:	e8 93 ca ff ff       	call   80101eb0 <iunlockput>
  return ip;
8010541d:	83 c4 10             	add    $0x10,%esp
}
80105420:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105423:	89 f0                	mov    %esi,%eax
80105425:	5b                   	pop    %ebx
80105426:	5e                   	pop    %esi
80105427:	5f                   	pop    %edi
80105428:	5d                   	pop    %ebp
80105429:	c3                   	ret    
8010542a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105433:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105438:	53                   	push   %ebx
80105439:	e8 32 c7 ff ff       	call   80101b70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010543e:	83 c4 0c             	add    $0xc,%esp
80105441:	ff 76 04             	push   0x4(%esi)
80105444:	68 e4 81 10 80       	push   $0x801081e4
80105449:	56                   	push   %esi
8010544a:	e8 31 d0 ff ff       	call   80102480 <dirlink>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	85 c0                	test   %eax,%eax
80105454:	78 18                	js     8010546e <create+0x15e>
80105456:	83 ec 04             	sub    $0x4,%esp
80105459:	ff 73 04             	push   0x4(%ebx)
8010545c:	68 e3 81 10 80       	push   $0x801081e3
80105461:	56                   	push   %esi
80105462:	e8 19 d0 ff ff       	call   80102480 <dirlink>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	85 c0                	test   %eax,%eax
8010546c:	79 92                	jns    80105400 <create+0xf0>
      panic("create dots");
8010546e:	83 ec 0c             	sub    $0xc,%esp
80105471:	68 d7 81 10 80       	push   $0x801081d7
80105476:	e8 05 af ff ff       	call   80100380 <panic>
8010547b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010547f:	90                   	nop
}
80105480:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105483:	31 f6                	xor    %esi,%esi
}
80105485:	5b                   	pop    %ebx
80105486:	89 f0                	mov    %esi,%eax
80105488:	5e                   	pop    %esi
80105489:	5f                   	pop    %edi
8010548a:	5d                   	pop    %ebp
8010548b:	c3                   	ret    
    panic("create: dirlink");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 e6 81 10 80       	push   $0x801081e6
80105494:	e8 e7 ae ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105499:	83 ec 0c             	sub    $0xc,%esp
8010549c:	68 c8 81 10 80       	push   $0x801081c8
801054a1:	e8 da ae ff ff       	call   80100380 <panic>
801054a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ad:	8d 76 00             	lea    0x0(%esi),%esi

801054b0 <sys_dup>:
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801054b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054bb:	50                   	push   %eax
801054bc:	6a 00                	push   $0x0
801054be:	e8 9d fc ff ff       	call   80105160 <argint>
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	78 36                	js     80105500 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054ce:	77 30                	ja     80105500 <sys_dup+0x50>
801054d0:	e8 3b e9 ff ff       	call   80103e10 <myproc>
801054d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801054dc:	85 f6                	test   %esi,%esi
801054de:	74 20                	je     80105500 <sys_dup+0x50>
  struct proc *curproc = myproc();
801054e0:	e8 2b e9 ff ff       	call   80103e10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054e5:	31 db                	xor    %ebx,%ebx
801054e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054f4:	85 d2                	test   %edx,%edx
801054f6:	74 18                	je     80105510 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	83 fb 10             	cmp    $0x10,%ebx
801054fe:	75 f0                	jne    801054f0 <sys_dup+0x40>
}
80105500:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105503:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105508:	89 d8                	mov    %ebx,%eax
8010550a:	5b                   	pop    %ebx
8010550b:	5e                   	pop    %esi
8010550c:	5d                   	pop    %ebp
8010550d:	c3                   	ret    
8010550e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105510:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105513:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105517:	56                   	push   %esi
80105518:	e8 23 be ff ff       	call   80101340 <filedup>
  return fd;
8010551d:	83 c4 10             	add    $0x10,%esp
}
80105520:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105523:	89 d8                	mov    %ebx,%eax
80105525:	5b                   	pop    %ebx
80105526:	5e                   	pop    %esi
80105527:	5d                   	pop    %ebp
80105528:	c3                   	ret    
80105529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105530 <sys_read>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105535:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105538:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010553b:	53                   	push   %ebx
8010553c:	6a 00                	push   $0x0
8010553e:	e8 1d fc ff ff       	call   80105160 <argint>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	78 5e                	js     801055a8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010554a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010554e:	77 58                	ja     801055a8 <sys_read+0x78>
80105550:	e8 bb e8 ff ff       	call   80103e10 <myproc>
80105555:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105558:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010555c:	85 f6                	test   %esi,%esi
8010555e:	74 48                	je     801055a8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105566:	50                   	push   %eax
80105567:	6a 02                	push   $0x2
80105569:	e8 f2 fb ff ff       	call   80105160 <argint>
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
80105573:	78 33                	js     801055a8 <sys_read+0x78>
80105575:	83 ec 04             	sub    $0x4,%esp
80105578:	ff 75 f0             	push   -0x10(%ebp)
8010557b:	53                   	push   %ebx
8010557c:	6a 01                	push   $0x1
8010557e:	e8 2d fc ff ff       	call   801051b0 <argptr>
80105583:	83 c4 10             	add    $0x10,%esp
80105586:	85 c0                	test   %eax,%eax
80105588:	78 1e                	js     801055a8 <sys_read+0x78>
  return fileread(f, p, n);
8010558a:	83 ec 04             	sub    $0x4,%esp
8010558d:	ff 75 f0             	push   -0x10(%ebp)
80105590:	ff 75 f4             	push   -0xc(%ebp)
80105593:	56                   	push   %esi
80105594:	e8 27 bf ff ff       	call   801014c0 <fileread>
80105599:	83 c4 10             	add    $0x10,%esp
}
8010559c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010559f:	5b                   	pop    %ebx
801055a0:	5e                   	pop    %esi
801055a1:	5d                   	pop    %ebp
801055a2:	c3                   	ret    
801055a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055a7:	90                   	nop
    return -1;
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	eb ed                	jmp    8010559c <sys_read+0x6c>
801055af:	90                   	nop

801055b0 <sys_write>:
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	56                   	push   %esi
801055b4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055b5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801055b8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055bb:	53                   	push   %ebx
801055bc:	6a 00                	push   $0x0
801055be:	e8 9d fb ff ff       	call   80105160 <argint>
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	78 5e                	js     80105628 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055ca:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055ce:	77 58                	ja     80105628 <sys_write+0x78>
801055d0:	e8 3b e8 ff ff       	call   80103e10 <myproc>
801055d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801055dc:	85 f6                	test   %esi,%esi
801055de:	74 48                	je     80105628 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055e0:	83 ec 08             	sub    $0x8,%esp
801055e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055e6:	50                   	push   %eax
801055e7:	6a 02                	push   $0x2
801055e9:	e8 72 fb ff ff       	call   80105160 <argint>
801055ee:	83 c4 10             	add    $0x10,%esp
801055f1:	85 c0                	test   %eax,%eax
801055f3:	78 33                	js     80105628 <sys_write+0x78>
801055f5:	83 ec 04             	sub    $0x4,%esp
801055f8:	ff 75 f0             	push   -0x10(%ebp)
801055fb:	53                   	push   %ebx
801055fc:	6a 01                	push   $0x1
801055fe:	e8 ad fb ff ff       	call   801051b0 <argptr>
80105603:	83 c4 10             	add    $0x10,%esp
80105606:	85 c0                	test   %eax,%eax
80105608:	78 1e                	js     80105628 <sys_write+0x78>
  return filewrite(f, p, n);
8010560a:	83 ec 04             	sub    $0x4,%esp
8010560d:	ff 75 f0             	push   -0x10(%ebp)
80105610:	ff 75 f4             	push   -0xc(%ebp)
80105613:	56                   	push   %esi
80105614:	e8 37 bf ff ff       	call   80101550 <filewrite>
80105619:	83 c4 10             	add    $0x10,%esp
}
8010561c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010561f:	5b                   	pop    %ebx
80105620:	5e                   	pop    %esi
80105621:	5d                   	pop    %ebp
80105622:	c3                   	ret    
80105623:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105627:	90                   	nop
    return -1;
80105628:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562d:	eb ed                	jmp    8010561c <sys_write+0x6c>
8010562f:	90                   	nop

80105630 <sys_close>:
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105635:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105638:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010563b:	50                   	push   %eax
8010563c:	6a 00                	push   $0x0
8010563e:	e8 1d fb ff ff       	call   80105160 <argint>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 3e                	js     80105688 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010564a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010564e:	77 38                	ja     80105688 <sys_close+0x58>
80105650:	e8 bb e7 ff ff       	call   80103e10 <myproc>
80105655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105658:	8d 5a 08             	lea    0x8(%edx),%ebx
8010565b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010565f:	85 f6                	test   %esi,%esi
80105661:	74 25                	je     80105688 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105663:	e8 a8 e7 ff ff       	call   80103e10 <myproc>
  fileclose(f);
80105668:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010566b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105672:	00 
  fileclose(f);
80105673:	56                   	push   %esi
80105674:	e8 17 bd ff ff       	call   80101390 <fileclose>
  return 0;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	31 c0                	xor    %eax,%eax
}
8010567e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105681:	5b                   	pop    %ebx
80105682:	5e                   	pop    %esi
80105683:	5d                   	pop    %ebp
80105684:	c3                   	ret    
80105685:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb ef                	jmp    8010567e <sys_close+0x4e>
8010568f:	90                   	nop

80105690 <sys_fstat>:
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105695:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105698:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010569b:	53                   	push   %ebx
8010569c:	6a 00                	push   $0x0
8010569e:	e8 bd fa ff ff       	call   80105160 <argint>
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	85 c0                	test   %eax,%eax
801056a8:	78 46                	js     801056f0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801056aa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801056ae:	77 40                	ja     801056f0 <sys_fstat+0x60>
801056b0:	e8 5b e7 ff ff       	call   80103e10 <myproc>
801056b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056b8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801056bc:	85 f6                	test   %esi,%esi
801056be:	74 30                	je     801056f0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801056c0:	83 ec 04             	sub    $0x4,%esp
801056c3:	6a 14                	push   $0x14
801056c5:	53                   	push   %ebx
801056c6:	6a 01                	push   $0x1
801056c8:	e8 e3 fa ff ff       	call   801051b0 <argptr>
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	85 c0                	test   %eax,%eax
801056d2:	78 1c                	js     801056f0 <sys_fstat+0x60>
  return filestat(f, st);
801056d4:	83 ec 08             	sub    $0x8,%esp
801056d7:	ff 75 f4             	push   -0xc(%ebp)
801056da:	56                   	push   %esi
801056db:	e8 90 bd ff ff       	call   80101470 <filestat>
801056e0:	83 c4 10             	add    $0x10,%esp
}
801056e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056e6:	5b                   	pop    %ebx
801056e7:	5e                   	pop    %esi
801056e8:	5d                   	pop    %ebp
801056e9:	c3                   	ret    
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f5:	eb ec                	jmp    801056e3 <sys_fstat+0x53>
801056f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fe:	66 90                	xchg   %ax,%ax

80105700 <sys_link>:
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105705:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105708:	53                   	push   %ebx
80105709:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 0c fb ff ff       	call   80105220 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 fb 00 00 00    	js     8010581a <sys_link+0x11a>
8010571f:	83 ec 08             	sub    $0x8,%esp
80105722:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105725:	50                   	push   %eax
80105726:	6a 01                	push   $0x1
80105728:	e8 f3 fa ff ff       	call   80105220 <argstr>
8010572d:	83 c4 10             	add    $0x10,%esp
80105730:	85 c0                	test   %eax,%eax
80105732:	0f 88 e2 00 00 00    	js     8010581a <sys_link+0x11a>
  begin_op();
80105738:	e8 c3 da ff ff       	call   80103200 <begin_op>
  if((ip = namei(old)) == 0){
8010573d:	83 ec 0c             	sub    $0xc,%esp
80105740:	ff 75 d4             	push   -0x2c(%ebp)
80105743:	e8 f8 cd ff ff       	call   80102540 <namei>
80105748:	83 c4 10             	add    $0x10,%esp
8010574b:	89 c3                	mov    %eax,%ebx
8010574d:	85 c0                	test   %eax,%eax
8010574f:	0f 84 e4 00 00 00    	je     80105839 <sys_link+0x139>
  ilock(ip);
80105755:	83 ec 0c             	sub    $0xc,%esp
80105758:	50                   	push   %eax
80105759:	e8 c2 c4 ff ff       	call   80101c20 <ilock>
  if(ip->type == T_DIR){
8010575e:	83 c4 10             	add    $0x10,%esp
80105761:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105766:	0f 84 b5 00 00 00    	je     80105821 <sys_link+0x121>
  iupdate(ip);
8010576c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010576f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105774:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105777:	53                   	push   %ebx
80105778:	e8 f3 c3 ff ff       	call   80101b70 <iupdate>
  iunlock(ip);
8010577d:	89 1c 24             	mov    %ebx,(%esp)
80105780:	e8 7b c5 ff ff       	call   80101d00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105785:	58                   	pop    %eax
80105786:	5a                   	pop    %edx
80105787:	57                   	push   %edi
80105788:	ff 75 d0             	push   -0x30(%ebp)
8010578b:	e8 d0 cd ff ff       	call   80102560 <nameiparent>
80105790:	83 c4 10             	add    $0x10,%esp
80105793:	89 c6                	mov    %eax,%esi
80105795:	85 c0                	test   %eax,%eax
80105797:	74 5b                	je     801057f4 <sys_link+0xf4>
  ilock(dp);
80105799:	83 ec 0c             	sub    $0xc,%esp
8010579c:	50                   	push   %eax
8010579d:	e8 7e c4 ff ff       	call   80101c20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801057a2:	8b 03                	mov    (%ebx),%eax
801057a4:	83 c4 10             	add    $0x10,%esp
801057a7:	39 06                	cmp    %eax,(%esi)
801057a9:	75 3d                	jne    801057e8 <sys_link+0xe8>
801057ab:	83 ec 04             	sub    $0x4,%esp
801057ae:	ff 73 04             	push   0x4(%ebx)
801057b1:	57                   	push   %edi
801057b2:	56                   	push   %esi
801057b3:	e8 c8 cc ff ff       	call   80102480 <dirlink>
801057b8:	83 c4 10             	add    $0x10,%esp
801057bb:	85 c0                	test   %eax,%eax
801057bd:	78 29                	js     801057e8 <sys_link+0xe8>
  iunlockput(dp);
801057bf:	83 ec 0c             	sub    $0xc,%esp
801057c2:	56                   	push   %esi
801057c3:	e8 e8 c6 ff ff       	call   80101eb0 <iunlockput>
  iput(ip);
801057c8:	89 1c 24             	mov    %ebx,(%esp)
801057cb:	e8 80 c5 ff ff       	call   80101d50 <iput>
  end_op();
801057d0:	e8 9b da ff ff       	call   80103270 <end_op>
  return 0;
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	31 c0                	xor    %eax,%eax
}
801057da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057dd:	5b                   	pop    %ebx
801057de:	5e                   	pop    %esi
801057df:	5f                   	pop    %edi
801057e0:	5d                   	pop    %ebp
801057e1:	c3                   	ret    
801057e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801057e8:	83 ec 0c             	sub    $0xc,%esp
801057eb:	56                   	push   %esi
801057ec:	e8 bf c6 ff ff       	call   80101eb0 <iunlockput>
    goto bad;
801057f1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	53                   	push   %ebx
801057f8:	e8 23 c4 ff ff       	call   80101c20 <ilock>
  ip->nlink--;
801057fd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105802:	89 1c 24             	mov    %ebx,(%esp)
80105805:	e8 66 c3 ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
8010580a:	89 1c 24             	mov    %ebx,(%esp)
8010580d:	e8 9e c6 ff ff       	call   80101eb0 <iunlockput>
  end_op();
80105812:	e8 59 da ff ff       	call   80103270 <end_op>
  return -1;
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581f:	eb b9                	jmp    801057da <sys_link+0xda>
    iunlockput(ip);
80105821:	83 ec 0c             	sub    $0xc,%esp
80105824:	53                   	push   %ebx
80105825:	e8 86 c6 ff ff       	call   80101eb0 <iunlockput>
    end_op();
8010582a:	e8 41 da ff ff       	call   80103270 <end_op>
    return -1;
8010582f:	83 c4 10             	add    $0x10,%esp
80105832:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105837:	eb a1                	jmp    801057da <sys_link+0xda>
    end_op();
80105839:	e8 32 da ff ff       	call   80103270 <end_op>
    return -1;
8010583e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105843:	eb 95                	jmp    801057da <sys_link+0xda>
80105845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_unlink>:
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105855:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105858:	53                   	push   %ebx
80105859:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010585c:	50                   	push   %eax
8010585d:	6a 00                	push   $0x0
8010585f:	e8 bc f9 ff ff       	call   80105220 <argstr>
80105864:	83 c4 10             	add    $0x10,%esp
80105867:	85 c0                	test   %eax,%eax
80105869:	0f 88 7a 01 00 00    	js     801059e9 <sys_unlink+0x199>
  begin_op();
8010586f:	e8 8c d9 ff ff       	call   80103200 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105874:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	53                   	push   %ebx
8010587b:	ff 75 c0             	push   -0x40(%ebp)
8010587e:	e8 dd cc ff ff       	call   80102560 <nameiparent>
80105883:	83 c4 10             	add    $0x10,%esp
80105886:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105889:	85 c0                	test   %eax,%eax
8010588b:	0f 84 62 01 00 00    	je     801059f3 <sys_unlink+0x1a3>
  ilock(dp);
80105891:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105894:	83 ec 0c             	sub    $0xc,%esp
80105897:	57                   	push   %edi
80105898:	e8 83 c3 ff ff       	call   80101c20 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010589d:	58                   	pop    %eax
8010589e:	5a                   	pop    %edx
8010589f:	68 e4 81 10 80       	push   $0x801081e4
801058a4:	53                   	push   %ebx
801058a5:	e8 b6 c8 ff ff       	call   80102160 <namecmp>
801058aa:	83 c4 10             	add    $0x10,%esp
801058ad:	85 c0                	test   %eax,%eax
801058af:	0f 84 fb 00 00 00    	je     801059b0 <sys_unlink+0x160>
801058b5:	83 ec 08             	sub    $0x8,%esp
801058b8:	68 e3 81 10 80       	push   $0x801081e3
801058bd:	53                   	push   %ebx
801058be:	e8 9d c8 ff ff       	call   80102160 <namecmp>
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	0f 84 e2 00 00 00    	je     801059b0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801058ce:	83 ec 04             	sub    $0x4,%esp
801058d1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801058d4:	50                   	push   %eax
801058d5:	53                   	push   %ebx
801058d6:	57                   	push   %edi
801058d7:	e8 a4 c8 ff ff       	call   80102180 <dirlookup>
801058dc:	83 c4 10             	add    $0x10,%esp
801058df:	89 c3                	mov    %eax,%ebx
801058e1:	85 c0                	test   %eax,%eax
801058e3:	0f 84 c7 00 00 00    	je     801059b0 <sys_unlink+0x160>
  ilock(ip);
801058e9:	83 ec 0c             	sub    $0xc,%esp
801058ec:	50                   	push   %eax
801058ed:	e8 2e c3 ff ff       	call   80101c20 <ilock>
  if(ip->nlink < 1)
801058f2:	83 c4 10             	add    $0x10,%esp
801058f5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058fa:	0f 8e 1c 01 00 00    	jle    80105a1c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105900:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105905:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105908:	74 66                	je     80105970 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010590a:	83 ec 04             	sub    $0x4,%esp
8010590d:	6a 10                	push   $0x10
8010590f:	6a 00                	push   $0x0
80105911:	57                   	push   %edi
80105912:	e8 89 f5 ff ff       	call   80104ea0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105917:	6a 10                	push   $0x10
80105919:	ff 75 c4             	push   -0x3c(%ebp)
8010591c:	57                   	push   %edi
8010591d:	ff 75 b4             	push   -0x4c(%ebp)
80105920:	e8 0b c7 ff ff       	call   80102030 <writei>
80105925:	83 c4 20             	add    $0x20,%esp
80105928:	83 f8 10             	cmp    $0x10,%eax
8010592b:	0f 85 de 00 00 00    	jne    80105a0f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105931:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105936:	0f 84 94 00 00 00    	je     801059d0 <sys_unlink+0x180>
  iunlockput(dp);
8010593c:	83 ec 0c             	sub    $0xc,%esp
8010593f:	ff 75 b4             	push   -0x4c(%ebp)
80105942:	e8 69 c5 ff ff       	call   80101eb0 <iunlockput>
  ip->nlink--;
80105947:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010594c:	89 1c 24             	mov    %ebx,(%esp)
8010594f:	e8 1c c2 ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
80105954:	89 1c 24             	mov    %ebx,(%esp)
80105957:	e8 54 c5 ff ff       	call   80101eb0 <iunlockput>
  end_op();
8010595c:	e8 0f d9 ff ff       	call   80103270 <end_op>
  return 0;
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	31 c0                	xor    %eax,%eax
}
80105966:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105969:	5b                   	pop    %ebx
8010596a:	5e                   	pop    %esi
8010596b:	5f                   	pop    %edi
8010596c:	5d                   	pop    %ebp
8010596d:	c3                   	ret    
8010596e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105970:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105974:	76 94                	jbe    8010590a <sys_unlink+0xba>
80105976:	be 20 00 00 00       	mov    $0x20,%esi
8010597b:	eb 0b                	jmp    80105988 <sys_unlink+0x138>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
80105980:	83 c6 10             	add    $0x10,%esi
80105983:	3b 73 58             	cmp    0x58(%ebx),%esi
80105986:	73 82                	jae    8010590a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105988:	6a 10                	push   $0x10
8010598a:	56                   	push   %esi
8010598b:	57                   	push   %edi
8010598c:	53                   	push   %ebx
8010598d:	e8 9e c5 ff ff       	call   80101f30 <readi>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	83 f8 10             	cmp    $0x10,%eax
80105998:	75 68                	jne    80105a02 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010599a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010599f:	74 df                	je     80105980 <sys_unlink+0x130>
    iunlockput(ip);
801059a1:	83 ec 0c             	sub    $0xc,%esp
801059a4:	53                   	push   %ebx
801059a5:	e8 06 c5 ff ff       	call   80101eb0 <iunlockput>
    goto bad;
801059aa:	83 c4 10             	add    $0x10,%esp
801059ad:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801059b0:	83 ec 0c             	sub    $0xc,%esp
801059b3:	ff 75 b4             	push   -0x4c(%ebp)
801059b6:	e8 f5 c4 ff ff       	call   80101eb0 <iunlockput>
  end_op();
801059bb:	e8 b0 d8 ff ff       	call   80103270 <end_op>
  return -1;
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c8:	eb 9c                	jmp    80105966 <sys_unlink+0x116>
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
801059d0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
801059d3:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801059d6:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801059db:	50                   	push   %eax
801059dc:	e8 8f c1 ff ff       	call   80101b70 <iupdate>
801059e1:	83 c4 10             	add    $0x10,%esp
801059e4:	e9 53 ff ff ff       	jmp    8010593c <sys_unlink+0xec>
    return -1;
801059e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ee:	e9 73 ff ff ff       	jmp    80105966 <sys_unlink+0x116>
    end_op();
801059f3:	e8 78 d8 ff ff       	call   80103270 <end_op>
    return -1;
801059f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059fd:	e9 64 ff ff ff       	jmp    80105966 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105a02:	83 ec 0c             	sub    $0xc,%esp
80105a05:	68 08 82 10 80       	push   $0x80108208
80105a0a:	e8 71 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
80105a0f:	83 ec 0c             	sub    $0xc,%esp
80105a12:	68 1a 82 10 80       	push   $0x8010821a
80105a17:	e8 64 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	68 f6 81 10 80       	push   $0x801081f6
80105a24:	e8 57 a9 ff ff       	call   80100380 <panic>
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_open>:

int
sys_open(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a35:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105a38:	53                   	push   %ebx
80105a39:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a3c:	50                   	push   %eax
80105a3d:	6a 00                	push   $0x0
80105a3f:	e8 dc f7 ff ff       	call   80105220 <argstr>
80105a44:	83 c4 10             	add    $0x10,%esp
80105a47:	85 c0                	test   %eax,%eax
80105a49:	0f 88 8e 00 00 00    	js     80105add <sys_open+0xad>
80105a4f:	83 ec 08             	sub    $0x8,%esp
80105a52:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a55:	50                   	push   %eax
80105a56:	6a 01                	push   $0x1
80105a58:	e8 03 f7 ff ff       	call   80105160 <argint>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	85 c0                	test   %eax,%eax
80105a62:	78 79                	js     80105add <sys_open+0xad>
    return -1;

  begin_op();
80105a64:	e8 97 d7 ff ff       	call   80103200 <begin_op>

  if(omode & O_CREATE){
80105a69:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a6d:	75 79                	jne    80105ae8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a6f:	83 ec 0c             	sub    $0xc,%esp
80105a72:	ff 75 e0             	push   -0x20(%ebp)
80105a75:	e8 c6 ca ff ff       	call   80102540 <namei>
80105a7a:	83 c4 10             	add    $0x10,%esp
80105a7d:	89 c6                	mov    %eax,%esi
80105a7f:	85 c0                	test   %eax,%eax
80105a81:	0f 84 7e 00 00 00    	je     80105b05 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a87:	83 ec 0c             	sub    $0xc,%esp
80105a8a:	50                   	push   %eax
80105a8b:	e8 90 c1 ff ff       	call   80101c20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a90:	83 c4 10             	add    $0x10,%esp
80105a93:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a98:	0f 84 c2 00 00 00    	je     80105b60 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a9e:	e8 2d b8 ff ff       	call   801012d0 <filealloc>
80105aa3:	89 c7                	mov    %eax,%edi
80105aa5:	85 c0                	test   %eax,%eax
80105aa7:	74 23                	je     80105acc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105aa9:	e8 62 e3 ff ff       	call   80103e10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105aae:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ab0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ab4:	85 d2                	test   %edx,%edx
80105ab6:	74 60                	je     80105b18 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ab8:	83 c3 01             	add    $0x1,%ebx
80105abb:	83 fb 10             	cmp    $0x10,%ebx
80105abe:	75 f0                	jne    80105ab0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	57                   	push   %edi
80105ac4:	e8 c7 b8 ff ff       	call   80101390 <fileclose>
80105ac9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105acc:	83 ec 0c             	sub    $0xc,%esp
80105acf:	56                   	push   %esi
80105ad0:	e8 db c3 ff ff       	call   80101eb0 <iunlockput>
    end_op();
80105ad5:	e8 96 d7 ff ff       	call   80103270 <end_op>
    return -1;
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ae2:	eb 6d                	jmp    80105b51 <sys_open+0x121>
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105aee:	31 c9                	xor    %ecx,%ecx
80105af0:	ba 02 00 00 00       	mov    $0x2,%edx
80105af5:	6a 00                	push   $0x0
80105af7:	e8 14 f8 ff ff       	call   80105310 <create>
    if(ip == 0){
80105afc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105aff:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b01:	85 c0                	test   %eax,%eax
80105b03:	75 99                	jne    80105a9e <sys_open+0x6e>
      end_op();
80105b05:	e8 66 d7 ff ff       	call   80103270 <end_op>
      return -1;
80105b0a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b0f:	eb 40                	jmp    80105b51 <sys_open+0x121>
80105b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b18:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b1b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b1f:	56                   	push   %esi
80105b20:	e8 db c1 ff ff       	call   80101d00 <iunlock>
  end_op();
80105b25:	e8 46 d7 ff ff       	call   80103270 <end_op>

  f->type = FD_INODE;
80105b2a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b33:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105b36:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105b39:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105b3b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b42:	f7 d0                	not    %eax
80105b44:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b47:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105b4a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b4d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b54:	89 d8                	mov    %ebx,%eax
80105b56:	5b                   	pop    %ebx
80105b57:	5e                   	pop    %esi
80105b58:	5f                   	pop    %edi
80105b59:	5d                   	pop    %ebp
80105b5a:	c3                   	ret    
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b63:	85 c9                	test   %ecx,%ecx
80105b65:	0f 84 33 ff ff ff    	je     80105a9e <sys_open+0x6e>
80105b6b:	e9 5c ff ff ff       	jmp    80105acc <sys_open+0x9c>

80105b70 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b76:	e8 85 d6 ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b7b:	83 ec 08             	sub    $0x8,%esp
80105b7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b81:	50                   	push   %eax
80105b82:	6a 00                	push   $0x0
80105b84:	e8 97 f6 ff ff       	call   80105220 <argstr>
80105b89:	83 c4 10             	add    $0x10,%esp
80105b8c:	85 c0                	test   %eax,%eax
80105b8e:	78 30                	js     80105bc0 <sys_mkdir+0x50>
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b96:	31 c9                	xor    %ecx,%ecx
80105b98:	ba 01 00 00 00       	mov    $0x1,%edx
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 6c f7 ff ff       	call   80105310 <create>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	74 15                	je     80105bc0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bab:	83 ec 0c             	sub    $0xc,%esp
80105bae:	50                   	push   %eax
80105baf:	e8 fc c2 ff ff       	call   80101eb0 <iunlockput>
  end_op();
80105bb4:	e8 b7 d6 ff ff       	call   80103270 <end_op>
  return 0;
80105bb9:	83 c4 10             	add    $0x10,%esp
80105bbc:	31 c0                	xor    %eax,%eax
}
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    
    end_op();
80105bc0:	e8 ab d6 ff ff       	call   80103270 <end_op>
    return -1;
80105bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bca:	c9                   	leave  
80105bcb:	c3                   	ret    
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <sys_mknod>:

int
sys_mknod(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bd6:	e8 25 d6 ff ff       	call   80103200 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bdb:	83 ec 08             	sub    $0x8,%esp
80105bde:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105be1:	50                   	push   %eax
80105be2:	6a 00                	push   $0x0
80105be4:	e8 37 f6 ff ff       	call   80105220 <argstr>
80105be9:	83 c4 10             	add    $0x10,%esp
80105bec:	85 c0                	test   %eax,%eax
80105bee:	78 60                	js     80105c50 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bf6:	50                   	push   %eax
80105bf7:	6a 01                	push   $0x1
80105bf9:	e8 62 f5 ff ff       	call   80105160 <argint>
  if((argstr(0, &path)) < 0 ||
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	85 c0                	test   %eax,%eax
80105c03:	78 4b                	js     80105c50 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c05:	83 ec 08             	sub    $0x8,%esp
80105c08:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c0b:	50                   	push   %eax
80105c0c:	6a 02                	push   $0x2
80105c0e:	e8 4d f5 ff ff       	call   80105160 <argint>
     argint(1, &major) < 0 ||
80105c13:	83 c4 10             	add    $0x10,%esp
80105c16:	85 c0                	test   %eax,%eax
80105c18:	78 36                	js     80105c50 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105c1a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105c25:	ba 03 00 00 00       	mov    $0x3,%edx
80105c2a:	50                   	push   %eax
80105c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105c2e:	e8 dd f6 ff ff       	call   80105310 <create>
     argint(2, &minor) < 0 ||
80105c33:	83 c4 10             	add    $0x10,%esp
80105c36:	85 c0                	test   %eax,%eax
80105c38:	74 16                	je     80105c50 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c3a:	83 ec 0c             	sub    $0xc,%esp
80105c3d:	50                   	push   %eax
80105c3e:	e8 6d c2 ff ff       	call   80101eb0 <iunlockput>
  end_op();
80105c43:	e8 28 d6 ff ff       	call   80103270 <end_op>
  return 0;
80105c48:	83 c4 10             	add    $0x10,%esp
80105c4b:	31 c0                	xor    %eax,%eax
}
80105c4d:	c9                   	leave  
80105c4e:	c3                   	ret    
80105c4f:	90                   	nop
    end_op();
80105c50:	e8 1b d6 ff ff       	call   80103270 <end_op>
    return -1;
80105c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5a:	c9                   	leave  
80105c5b:	c3                   	ret    
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_chdir>:

int
sys_chdir(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	56                   	push   %esi
80105c64:	53                   	push   %ebx
80105c65:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c68:	e8 a3 e1 ff ff       	call   80103e10 <myproc>
80105c6d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c6f:	e8 8c d5 ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 9e f5 ff ff       	call   80105220 <argstr>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	78 77                	js     80105d00 <sys_chdir+0xa0>
80105c89:	83 ec 0c             	sub    $0xc,%esp
80105c8c:	ff 75 f4             	push   -0xc(%ebp)
80105c8f:	e8 ac c8 ff ff       	call   80102540 <namei>
80105c94:	83 c4 10             	add    $0x10,%esp
80105c97:	89 c3                	mov    %eax,%ebx
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 63                	je     80105d00 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c9d:	83 ec 0c             	sub    $0xc,%esp
80105ca0:	50                   	push   %eax
80105ca1:	e8 7a bf ff ff       	call   80101c20 <ilock>
  if(ip->type != T_DIR){
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cae:	75 30                	jne    80105ce0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	53                   	push   %ebx
80105cb4:	e8 47 c0 ff ff       	call   80101d00 <iunlock>
  iput(curproc->cwd);
80105cb9:	58                   	pop    %eax
80105cba:	ff 76 68             	push   0x68(%esi)
80105cbd:	e8 8e c0 ff ff       	call   80101d50 <iput>
  end_op();
80105cc2:	e8 a9 d5 ff ff       	call   80103270 <end_op>
  curproc->cwd = ip;
80105cc7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	31 c0                	xor    %eax,%eax
}
80105ccf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cd2:	5b                   	pop    %ebx
80105cd3:	5e                   	pop    %esi
80105cd4:	5d                   	pop    %ebp
80105cd5:	c3                   	ret    
80105cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	53                   	push   %ebx
80105ce4:	e8 c7 c1 ff ff       	call   80101eb0 <iunlockput>
    end_op();
80105ce9:	e8 82 d5 ff ff       	call   80103270 <end_op>
    return -1;
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf6:	eb d7                	jmp    80105ccf <sys_chdir+0x6f>
80105cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop
    end_op();
80105d00:	e8 6b d5 ff ff       	call   80103270 <end_op>
    return -1;
80105d05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d0a:	eb c3                	jmp    80105ccf <sys_chdir+0x6f>
80105d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d10 <sys_exec>:

int
sys_exec(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	57                   	push   %edi
80105d14:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d15:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105d1b:	53                   	push   %ebx
80105d1c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d22:	50                   	push   %eax
80105d23:	6a 00                	push   $0x0
80105d25:	e8 f6 f4 ff ff       	call   80105220 <argstr>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	0f 88 87 00 00 00    	js     80105dbc <sys_exec+0xac>
80105d35:	83 ec 08             	sub    $0x8,%esp
80105d38:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d3e:	50                   	push   %eax
80105d3f:	6a 01                	push   $0x1
80105d41:	e8 1a f4 ff ff       	call   80105160 <argint>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	78 6f                	js     80105dbc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d4d:	83 ec 04             	sub    $0x4,%esp
80105d50:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105d56:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d58:	68 80 00 00 00       	push   $0x80
80105d5d:	6a 00                	push   $0x0
80105d5f:	56                   	push   %esi
80105d60:	e8 3b f1 ff ff       	call   80104ea0 <memset>
80105d65:	83 c4 10             	add    $0x10,%esp
80105d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d79:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105d80:	50                   	push   %eax
80105d81:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d87:	01 f8                	add    %edi,%eax
80105d89:	50                   	push   %eax
80105d8a:	e8 41 f3 ff ff       	call   801050d0 <fetchint>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	85 c0                	test   %eax,%eax
80105d94:	78 26                	js     80105dbc <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d96:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d9c:	85 c0                	test   %eax,%eax
80105d9e:	74 30                	je     80105dd0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105da0:	83 ec 08             	sub    $0x8,%esp
80105da3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105da6:	52                   	push   %edx
80105da7:	50                   	push   %eax
80105da8:	e8 63 f3 ff ff       	call   80105110 <fetchstr>
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	85 c0                	test   %eax,%eax
80105db2:	78 08                	js     80105dbc <sys_exec+0xac>
  for(i=0;; i++){
80105db4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105db7:	83 fb 20             	cmp    $0x20,%ebx
80105dba:	75 b4                	jne    80105d70 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105dbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dc4:	5b                   	pop    %ebx
80105dc5:	5e                   	pop    %esi
80105dc6:	5f                   	pop    %edi
80105dc7:	5d                   	pop    %ebp
80105dc8:	c3                   	ret    
80105dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105dd0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105dd7:	00 00 00 00 
  return exec(path, argv);
80105ddb:	83 ec 08             	sub    $0x8,%esp
80105dde:	56                   	push   %esi
80105ddf:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105de5:	e8 66 b1 ff ff       	call   80100f50 <exec>
80105dea:	83 c4 10             	add    $0x10,%esp
}
80105ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df0:	5b                   	pop    %ebx
80105df1:	5e                   	pop    %esi
80105df2:	5f                   	pop    %edi
80105df3:	5d                   	pop    %ebp
80105df4:	c3                   	ret    
80105df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e00 <sys_pipe>:

int
sys_pipe(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	57                   	push   %edi
80105e04:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e05:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105e08:	53                   	push   %ebx
80105e09:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e0c:	6a 08                	push   $0x8
80105e0e:	50                   	push   %eax
80105e0f:	6a 00                	push   $0x0
80105e11:	e8 9a f3 ff ff       	call   801051b0 <argptr>
80105e16:	83 c4 10             	add    $0x10,%esp
80105e19:	85 c0                	test   %eax,%eax
80105e1b:	78 4a                	js     80105e67 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e1d:	83 ec 08             	sub    $0x8,%esp
80105e20:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e23:	50                   	push   %eax
80105e24:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e27:	50                   	push   %eax
80105e28:	e8 a3 da ff ff       	call   801038d0 <pipealloc>
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	85 c0                	test   %eax,%eax
80105e32:	78 33                	js     80105e67 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e34:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105e37:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105e39:	e8 d2 df ff ff       	call   80103e10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e3e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105e40:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e44:	85 f6                	test   %esi,%esi
80105e46:	74 28                	je     80105e70 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105e48:	83 c3 01             	add    $0x1,%ebx
80105e4b:	83 fb 10             	cmp    $0x10,%ebx
80105e4e:	75 f0                	jne    80105e40 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e50:	83 ec 0c             	sub    $0xc,%esp
80105e53:	ff 75 e0             	push   -0x20(%ebp)
80105e56:	e8 35 b5 ff ff       	call   80101390 <fileclose>
    fileclose(wf);
80105e5b:	58                   	pop    %eax
80105e5c:	ff 75 e4             	push   -0x1c(%ebp)
80105e5f:	e8 2c b5 ff ff       	call   80101390 <fileclose>
    return -1;
80105e64:	83 c4 10             	add    $0x10,%esp
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6c:	eb 53                	jmp    80105ec1 <sys_pipe+0xc1>
80105e6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e70:	8d 73 08             	lea    0x8(%ebx),%esi
80105e73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e7a:	e8 91 df ff ff       	call   80103e10 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e7f:	31 d2                	xor    %edx,%edx
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e88:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e8c:	85 c9                	test   %ecx,%ecx
80105e8e:	74 20                	je     80105eb0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e90:	83 c2 01             	add    $0x1,%edx
80105e93:	83 fa 10             	cmp    $0x10,%edx
80105e96:	75 f0                	jne    80105e88 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e98:	e8 73 df ff ff       	call   80103e10 <myproc>
80105e9d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ea4:	00 
80105ea5:	eb a9                	jmp    80105e50 <sys_pipe+0x50>
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105eb0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105eb4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105eb7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105eb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ebc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ebf:	31 c0                	xor    %eax,%eax
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	66 90                	xchg   %ax,%ax
80105ecb:	66 90                	xchg   %ax,%ax
80105ecd:	66 90                	xchg   %ax,%ax
80105ecf:	90                   	nop

80105ed0 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105ed0:	e9 db e0 ff ff       	jmp    80103fb0 <fork>
80105ed5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <sys_exit>:
}

int
sys_exit(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ee6:	e8 45 e3 ff ff       	call   80104230 <exit>
  return 0;  // not reached
}
80105eeb:	31 c0                	xor    %eax,%eax
80105eed:	c9                   	leave  
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ef0:	e9 6b e4 ff ff       	jmp    80104360 <wait>
80105ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_kill>:
}

int
sys_kill(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f09:	50                   	push   %eax
80105f0a:	6a 00                	push   $0x0
80105f0c:	e8 4f f2 ff ff       	call   80105160 <argint>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	78 18                	js     80105f30 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f18:	83 ec 0c             	sub    $0xc,%esp
80105f1b:	ff 75 f4             	push   -0xc(%ebp)
80105f1e:	e8 dd e6 ff ff       	call   80104600 <kill>
80105f23:	83 c4 10             	add    $0x10,%esp
}
80105f26:	c9                   	leave  
80105f27:	c3                   	ret    
80105f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop
80105f30:	c9                   	leave  
    return -1;
80105f31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f36:	c3                   	ret    
80105f37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <sys_getpid>:

int
sys_getpid(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f46:	e8 c5 de ff ff       	call   80103e10 <myproc>
80105f4b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f4e:	c9                   	leave  
80105f4f:	c3                   	ret    

80105f50 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f5a:	50                   	push   %eax
80105f5b:	6a 00                	push   $0x0
80105f5d:	e8 fe f1 ff ff       	call   80105160 <argint>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	85 c0                	test   %eax,%eax
80105f67:	78 27                	js     80105f90 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f69:	e8 a2 de ff ff       	call   80103e10 <myproc>
  if(growproc(n) < 0)
80105f6e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f71:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f73:	ff 75 f4             	push   -0xc(%ebp)
80105f76:	e8 b5 df ff ff       	call   80103f30 <growproc>
80105f7b:	83 c4 10             	add    $0x10,%esp
80105f7e:	85 c0                	test   %eax,%eax
80105f80:	78 0e                	js     80105f90 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f82:	89 d8                	mov    %ebx,%eax
80105f84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f87:	c9                   	leave  
80105f88:	c3                   	ret    
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f95:	eb eb                	jmp    80105f82 <sys_sbrk+0x32>
80105f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9e:	66 90                	xchg   %ax,%ax

80105fa0 <sys_sleep>:

int
sys_sleep(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105fa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105faa:	50                   	push   %eax
80105fab:	6a 00                	push   $0x0
80105fad:	e8 ae f1 ff ff       	call   80105160 <argint>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	0f 88 8a 00 00 00    	js     80106047 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
80105fc0:	68 00 4d 11 80       	push   $0x80114d00
80105fc5:	e8 16 ee ff ff       	call   80104de0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105fcd:	8b 1d e0 4c 11 80    	mov    0x80114ce0,%ebx
  while(ticks - ticks0 < n){
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 d2                	test   %edx,%edx
80105fd8:	75 27                	jne    80106001 <sys_sleep+0x61>
80105fda:	eb 54                	jmp    80106030 <sys_sleep+0x90>
80105fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fe0:	83 ec 08             	sub    $0x8,%esp
80105fe3:	68 00 4d 11 80       	push   $0x80114d00
80105fe8:	68 e0 4c 11 80       	push   $0x80114ce0
80105fed:	e8 ee e4 ff ff       	call   801044e0 <sleep>
  while(ticks - ticks0 < n){
80105ff2:	a1 e0 4c 11 80       	mov    0x80114ce0,%eax
80105ff7:	83 c4 10             	add    $0x10,%esp
80105ffa:	29 d8                	sub    %ebx,%eax
80105ffc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fff:	73 2f                	jae    80106030 <sys_sleep+0x90>
    if(myproc()->killed){
80106001:	e8 0a de ff ff       	call   80103e10 <myproc>
80106006:	8b 40 24             	mov    0x24(%eax),%eax
80106009:	85 c0                	test   %eax,%eax
8010600b:	74 d3                	je     80105fe0 <sys_sleep+0x40>
      release(&tickslock);
8010600d:	83 ec 0c             	sub    $0xc,%esp
80106010:	68 00 4d 11 80       	push   $0x80114d00
80106015:	e8 66 ed ff ff       	call   80104d80 <release>
  }
  release(&tickslock);
  return 0;
}
8010601a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010601d:	83 c4 10             	add    $0x10,%esp
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106025:	c9                   	leave  
80106026:	c3                   	ret    
80106027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	68 00 4d 11 80       	push   $0x80114d00
80106038:	e8 43 ed ff ff       	call   80104d80 <release>
  return 0;
8010603d:	83 c4 10             	add    $0x10,%esp
80106040:	31 c0                	xor    %eax,%eax
}
80106042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106045:	c9                   	leave  
80106046:	c3                   	ret    
    return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604c:	eb f4                	jmp    80106042 <sys_sleep+0xa2>
8010604e:	66 90                	xchg   %ax,%ax

80106050 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106050:	55                   	push   %ebp
80106051:	89 e5                	mov    %esp,%ebp
80106053:	53                   	push   %ebx
80106054:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106057:	68 00 4d 11 80       	push   $0x80114d00
8010605c:	e8 7f ed ff ff       	call   80104de0 <acquire>
  xticks = ticks;
80106061:	8b 1d e0 4c 11 80    	mov    0x80114ce0,%ebx
  release(&tickslock);
80106067:	c7 04 24 00 4d 11 80 	movl   $0x80114d00,(%esp)
8010606e:	e8 0d ed ff ff       	call   80104d80 <release>
  return xticks;
}
80106073:	89 d8                	mov    %ebx,%eax
80106075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106078:	c9                   	leave  
80106079:	c3                   	ret    
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106080 <sys_find_fibonacci_number>:

// system call to find the nth fibonacci number:

int sys_find_fibonacci_number(void){
80106080:	55                   	push   %ebp
80106081:	89 e5                	mov    %esp,%ebp
80106083:	53                   	push   %ebx
80106084:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
80106087:	e8 84 dd ff ff       	call   80103e10 <myproc>
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
8010608c:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
8010608f:	8b 40 18             	mov    0x18(%eax),%eax
80106092:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
80106095:	53                   	push   %ebx
80106096:	68 2c 82 10 80       	push   $0x8010822c
8010609b:	e8 50 a6 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling find_fibonacci_number(%d)\n", n);
801060a0:	58                   	pop    %eax
801060a1:	5a                   	pop    %edx
801060a2:	53                   	push   %ebx
801060a3:	68 60 82 10 80       	push   $0x80108260
801060a8:	e8 43 a6 ff ff       	call   801006f0 <cprintf>
  return find_fibonacci_number(n);
801060ad:	89 1c 24             	mov    %ebx,(%esp)
801060b0:	e8 8b e6 ff ff       	call   80104740 <find_fibonacci_number>
}
801060b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060b8:	c9                   	leave  
801060b9:	c3                   	ret    
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060c0 <sys_find_most_callee>:

// system call to find the most used system call:

int sys_find_most_callee(void){
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_find_most_callee is called\n");
801060c6:	68 90 82 10 80       	push   $0x80108290
801060cb:	e8 20 a6 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling find_most_callee\n");
801060d0:	c7 04 24 b8 82 10 80 	movl   $0x801082b8,(%esp)
801060d7:	e8 14 a6 ff ff       	call   801006f0 <cprintf>
  return find_most_callee();
801060dc:	83 c4 10             	add    $0x10,%esp
}
801060df:	c9                   	leave  
  return find_most_callee();
801060e0:	e9 eb e8 ff ff       	jmp    801049d0 <find_most_callee>
801060e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_get_children_count>:

// system call to get children count of current process:

int sys_get_children_count(void){
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_get_children_count is called\n");
801060f6:	68 e0 82 10 80       	push   $0x801082e0
801060fb:	e8 f0 a5 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling get_children_count\n");
80106100:	c7 04 24 0c 83 10 80 	movl   $0x8010830c,(%esp)
80106107:	e8 e4 a5 ff ff       	call   801006f0 <cprintf>
  return get_children_count();
8010610c:	83 c4 10             	add    $0x10,%esp
}
8010610f:	c9                   	leave  
  return get_children_count();
80106110:	e9 eb e8 ff ff       	jmp    80104a00 <get_children_count>
80106115:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106120 <sys_kill_first_child_process>:

// system call to kill the first child of a process:

int sys_kill_first_child_process(void){
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_kill_first_child_process is called\n");
80106126:	68 34 83 10 80       	push   $0x80108334
8010612b:	e8 c0 a5 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling kill_first_child_process\n");
80106130:	c7 04 24 64 83 10 80 	movl   $0x80108364,(%esp)
80106137:	e8 b4 a5 ff ff       	call   801006f0 <cprintf>
  return kill_first_child_process();
8010613c:	83 c4 10             	add    $0x10,%esp
}
8010613f:	c9                   	leave  
  return kill_first_child_process();
80106140:	e9 2b e9 ff ff       	jmp    80104a70 <kill_first_child_process>

80106145 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106145:	1e                   	push   %ds
  pushl %es
80106146:	06                   	push   %es
  pushl %fs
80106147:	0f a0                	push   %fs
  pushl %gs
80106149:	0f a8                	push   %gs
  pushal
8010614b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010614c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106150:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106152:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106154:	54                   	push   %esp
  call trap
80106155:	e8 c6 00 00 00       	call   80106220 <trap>
  addl $4, %esp
8010615a:	83 c4 04             	add    $0x4,%esp

8010615d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010615d:	61                   	popa   
  popl %gs
8010615e:	0f a9                	pop    %gs
  popl %fs
80106160:	0f a1                	pop    %fs
  popl %es
80106162:	07                   	pop    %es
  popl %ds
80106163:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106164:	83 c4 08             	add    $0x8,%esp
  iret
80106167:	cf                   	iret   
80106168:	66 90                	xchg   %ax,%ax
8010616a:	66 90                	xchg   %ax,%ax
8010616c:	66 90                	xchg   %ax,%ax
8010616e:	66 90                	xchg   %ax,%ax

80106170 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106170:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106171:	31 c0                	xor    %eax,%eax
{
80106173:	89 e5                	mov    %esp,%ebp
80106175:	83 ec 08             	sub    $0x8,%esp
80106178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106180:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106187:	c7 04 c5 42 4d 11 80 	movl   $0x8e000008,-0x7feeb2be(,%eax,8)
8010618e:	08 00 00 8e 
80106192:	66 89 14 c5 40 4d 11 	mov    %dx,-0x7feeb2c0(,%eax,8)
80106199:	80 
8010619a:	c1 ea 10             	shr    $0x10,%edx
8010619d:	66 89 14 c5 46 4d 11 	mov    %dx,-0x7feeb2ba(,%eax,8)
801061a4:	80 
  for(i = 0; i < 256; i++)
801061a5:	83 c0 01             	add    $0x1,%eax
801061a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061ad:	75 d1                	jne    80106180 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061af:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061b2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801061b7:	c7 05 42 4f 11 80 08 	movl   $0xef000008,0x80114f42
801061be:	00 00 ef 
  initlock(&tickslock, "time");
801061c1:	68 92 83 10 80       	push   $0x80108392
801061c6:	68 00 4d 11 80       	push   $0x80114d00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061cb:	66 a3 40 4f 11 80    	mov    %ax,0x80114f40
801061d1:	c1 e8 10             	shr    $0x10,%eax
801061d4:	66 a3 46 4f 11 80    	mov    %ax,0x80114f46
  initlock(&tickslock, "time");
801061da:	e8 31 ea ff ff       	call   80104c10 <initlock>
}
801061df:	83 c4 10             	add    $0x10,%esp
801061e2:	c9                   	leave  
801061e3:	c3                   	ret    
801061e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ef:	90                   	nop

801061f0 <idtinit>:

void
idtinit(void)
{
801061f0:	55                   	push   %ebp
  pd[0] = size-1;
801061f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061f6:	89 e5                	mov    %esp,%ebp
801061f8:	83 ec 10             	sub    $0x10,%esp
801061fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061ff:	b8 40 4d 11 80       	mov    $0x80114d40,%eax
80106204:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106208:	c1 e8 10             	shr    $0x10,%eax
8010620b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010620f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106212:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106215:	c9                   	leave  
80106216:	c3                   	ret    
80106217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621e:	66 90                	xchg   %ax,%ax

80106220 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106220:	55                   	push   %ebp
80106221:	89 e5                	mov    %esp,%ebp
80106223:	57                   	push   %edi
80106224:	56                   	push   %esi
80106225:	53                   	push   %ebx
80106226:	83 ec 1c             	sub    $0x1c,%esp
80106229:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010622c:	8b 43 30             	mov    0x30(%ebx),%eax
8010622f:	83 f8 40             	cmp    $0x40,%eax
80106232:	0f 84 68 01 00 00    	je     801063a0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106238:	83 e8 20             	sub    $0x20,%eax
8010623b:	83 f8 1f             	cmp    $0x1f,%eax
8010623e:	0f 87 8c 00 00 00    	ja     801062d0 <trap+0xb0>
80106244:	ff 24 85 38 84 10 80 	jmp    *-0x7fef7bc8(,%eax,4)
8010624b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010624f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106250:	e8 8b c4 ff ff       	call   801026e0 <ideintr>
    lapiceoi();
80106255:	e8 56 cb ff ff       	call   80102db0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010625a:	e8 b1 db ff ff       	call   80103e10 <myproc>
8010625f:	85 c0                	test   %eax,%eax
80106261:	74 1d                	je     80106280 <trap+0x60>
80106263:	e8 a8 db ff ff       	call   80103e10 <myproc>
80106268:	8b 50 24             	mov    0x24(%eax),%edx
8010626b:	85 d2                	test   %edx,%edx
8010626d:	74 11                	je     80106280 <trap+0x60>
8010626f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106273:	83 e0 03             	and    $0x3,%eax
80106276:	66 83 f8 03          	cmp    $0x3,%ax
8010627a:	0f 84 e8 01 00 00    	je     80106468 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106280:	e8 8b db ff ff       	call   80103e10 <myproc>
80106285:	85 c0                	test   %eax,%eax
80106287:	74 0f                	je     80106298 <trap+0x78>
80106289:	e8 82 db ff ff       	call   80103e10 <myproc>
8010628e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106292:	0f 84 b8 00 00 00    	je     80106350 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106298:	e8 73 db ff ff       	call   80103e10 <myproc>
8010629d:	85 c0                	test   %eax,%eax
8010629f:	74 1d                	je     801062be <trap+0x9e>
801062a1:	e8 6a db ff ff       	call   80103e10 <myproc>
801062a6:	8b 40 24             	mov    0x24(%eax),%eax
801062a9:	85 c0                	test   %eax,%eax
801062ab:	74 11                	je     801062be <trap+0x9e>
801062ad:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062b1:	83 e0 03             	and    $0x3,%eax
801062b4:	66 83 f8 03          	cmp    $0x3,%ax
801062b8:	0f 84 0f 01 00 00    	je     801063cd <trap+0x1ad>
    exit();
}
801062be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c1:	5b                   	pop    %ebx
801062c2:	5e                   	pop    %esi
801062c3:	5f                   	pop    %edi
801062c4:	5d                   	pop    %ebp
801062c5:	c3                   	ret    
801062c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801062d0:	e8 3b db ff ff       	call   80103e10 <myproc>
801062d5:	8b 7b 38             	mov    0x38(%ebx),%edi
801062d8:	85 c0                	test   %eax,%eax
801062da:	0f 84 a2 01 00 00    	je     80106482 <trap+0x262>
801062e0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801062e4:	0f 84 98 01 00 00    	je     80106482 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062ea:	0f 20 d1             	mov    %cr2,%ecx
801062ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062f0:	e8 fb da ff ff       	call   80103df0 <cpuid>
801062f5:	8b 73 30             	mov    0x30(%ebx),%esi
801062f8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801062fb:	8b 43 34             	mov    0x34(%ebx),%eax
801062fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106301:	e8 0a db ff ff       	call   80103e10 <myproc>
80106306:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106309:	e8 02 db ff ff       	call   80103e10 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010630e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106311:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106314:	51                   	push   %ecx
80106315:	57                   	push   %edi
80106316:	52                   	push   %edx
80106317:	ff 75 e4             	push   -0x1c(%ebp)
8010631a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010631b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010631e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106321:	56                   	push   %esi
80106322:	ff 70 10             	push   0x10(%eax)
80106325:	68 f4 83 10 80       	push   $0x801083f4
8010632a:	e8 c1 a3 ff ff       	call   801006f0 <cprintf>
    myproc()->killed = 1;
8010632f:	83 c4 20             	add    $0x20,%esp
80106332:	e8 d9 da ff ff       	call   80103e10 <myproc>
80106337:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010633e:	e8 cd da ff ff       	call   80103e10 <myproc>
80106343:	85 c0                	test   %eax,%eax
80106345:	0f 85 18 ff ff ff    	jne    80106263 <trap+0x43>
8010634b:	e9 30 ff ff ff       	jmp    80106280 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106350:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106354:	0f 85 3e ff ff ff    	jne    80106298 <trap+0x78>
    yield();
8010635a:	e8 31 e1 ff ff       	call   80104490 <yield>
8010635f:	e9 34 ff ff ff       	jmp    80106298 <trap+0x78>
80106364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106368:	8b 7b 38             	mov    0x38(%ebx),%edi
8010636b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010636f:	e8 7c da ff ff       	call   80103df0 <cpuid>
80106374:	57                   	push   %edi
80106375:	56                   	push   %esi
80106376:	50                   	push   %eax
80106377:	68 9c 83 10 80       	push   $0x8010839c
8010637c:	e8 6f a3 ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106381:	e8 2a ca ff ff       	call   80102db0 <lapiceoi>
    break;
80106386:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106389:	e8 82 da ff ff       	call   80103e10 <myproc>
8010638e:	85 c0                	test   %eax,%eax
80106390:	0f 85 cd fe ff ff    	jne    80106263 <trap+0x43>
80106396:	e9 e5 fe ff ff       	jmp    80106280 <trap+0x60>
8010639b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010639f:	90                   	nop
    if(myproc()->killed)
801063a0:	e8 6b da ff ff       	call   80103e10 <myproc>
801063a5:	8b 70 24             	mov    0x24(%eax),%esi
801063a8:	85 f6                	test   %esi,%esi
801063aa:	0f 85 c8 00 00 00    	jne    80106478 <trap+0x258>
    myproc()->tf = tf;
801063b0:	e8 5b da ff ff       	call   80103e10 <myproc>
801063b5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063b8:	e8 e3 ee ff ff       	call   801052a0 <syscall>
    if(myproc()->killed)
801063bd:	e8 4e da ff ff       	call   80103e10 <myproc>
801063c2:	8b 48 24             	mov    0x24(%eax),%ecx
801063c5:	85 c9                	test   %ecx,%ecx
801063c7:	0f 84 f1 fe ff ff    	je     801062be <trap+0x9e>
}
801063cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063d0:	5b                   	pop    %ebx
801063d1:	5e                   	pop    %esi
801063d2:	5f                   	pop    %edi
801063d3:	5d                   	pop    %ebp
      exit();
801063d4:	e9 57 de ff ff       	jmp    80104230 <exit>
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801063e0:	e8 3b 02 00 00       	call   80106620 <uartintr>
    lapiceoi();
801063e5:	e8 c6 c9 ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ea:	e8 21 da ff ff       	call   80103e10 <myproc>
801063ef:	85 c0                	test   %eax,%eax
801063f1:	0f 85 6c fe ff ff    	jne    80106263 <trap+0x43>
801063f7:	e9 84 fe ff ff       	jmp    80106280 <trap+0x60>
801063fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106400:	e8 6b c8 ff ff       	call   80102c70 <kbdintr>
    lapiceoi();
80106405:	e8 a6 c9 ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010640a:	e8 01 da ff ff       	call   80103e10 <myproc>
8010640f:	85 c0                	test   %eax,%eax
80106411:	0f 85 4c fe ff ff    	jne    80106263 <trap+0x43>
80106417:	e9 64 fe ff ff       	jmp    80106280 <trap+0x60>
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106420:	e8 cb d9 ff ff       	call   80103df0 <cpuid>
80106425:	85 c0                	test   %eax,%eax
80106427:	0f 85 28 fe ff ff    	jne    80106255 <trap+0x35>
      acquire(&tickslock);
8010642d:	83 ec 0c             	sub    $0xc,%esp
80106430:	68 00 4d 11 80       	push   $0x80114d00
80106435:	e8 a6 e9 ff ff       	call   80104de0 <acquire>
      wakeup(&ticks);
8010643a:	c7 04 24 e0 4c 11 80 	movl   $0x80114ce0,(%esp)
      ticks++;
80106441:	83 05 e0 4c 11 80 01 	addl   $0x1,0x80114ce0
      wakeup(&ticks);
80106448:	e8 53 e1 ff ff       	call   801045a0 <wakeup>
      release(&tickslock);
8010644d:	c7 04 24 00 4d 11 80 	movl   $0x80114d00,(%esp)
80106454:	e8 27 e9 ff ff       	call   80104d80 <release>
80106459:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010645c:	e9 f4 fd ff ff       	jmp    80106255 <trap+0x35>
80106461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106468:	e8 c3 dd ff ff       	call   80104230 <exit>
8010646d:	e9 0e fe ff ff       	jmp    80106280 <trap+0x60>
80106472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106478:	e8 b3 dd ff ff       	call   80104230 <exit>
8010647d:	e9 2e ff ff ff       	jmp    801063b0 <trap+0x190>
80106482:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106485:	e8 66 d9 ff ff       	call   80103df0 <cpuid>
8010648a:	83 ec 0c             	sub    $0xc,%esp
8010648d:	56                   	push   %esi
8010648e:	57                   	push   %edi
8010648f:	50                   	push   %eax
80106490:	ff 73 30             	push   0x30(%ebx)
80106493:	68 c0 83 10 80       	push   $0x801083c0
80106498:	e8 53 a2 ff ff       	call   801006f0 <cprintf>
      panic("trap");
8010649d:	83 c4 14             	add    $0x14,%esp
801064a0:	68 97 83 10 80       	push   $0x80108397
801064a5:	e8 d6 9e ff ff       	call   80100380 <panic>
801064aa:	66 90                	xchg   %ax,%ax
801064ac:	66 90                	xchg   %ax,%ax
801064ae:	66 90                	xchg   %ax,%ax

801064b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064b0:	a1 40 55 11 80       	mov    0x80115540,%eax
801064b5:	85 c0                	test   %eax,%eax
801064b7:	74 17                	je     801064d0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064b9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064be:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064bf:	a8 01                	test   $0x1,%al
801064c1:	74 0d                	je     801064d0 <uartgetc+0x20>
801064c3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064c8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064c9:	0f b6 c0             	movzbl %al,%eax
801064cc:	c3                   	ret    
801064cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064d5:	c3                   	ret    
801064d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064dd:	8d 76 00             	lea    0x0(%esi),%esi

801064e0 <uartinit>:
{
801064e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064e1:	31 c9                	xor    %ecx,%ecx
801064e3:	89 c8                	mov    %ecx,%eax
801064e5:	89 e5                	mov    %esp,%ebp
801064e7:	57                   	push   %edi
801064e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801064ed:	56                   	push   %esi
801064ee:	89 fa                	mov    %edi,%edx
801064f0:	53                   	push   %ebx
801064f1:	83 ec 1c             	sub    $0x1c,%esp
801064f4:	ee                   	out    %al,(%dx)
801064f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801064fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064ff:	89 f2                	mov    %esi,%edx
80106501:	ee                   	out    %al,(%dx)
80106502:	b8 0c 00 00 00       	mov    $0xc,%eax
80106507:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010650c:	ee                   	out    %al,(%dx)
8010650d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106512:	89 c8                	mov    %ecx,%eax
80106514:	89 da                	mov    %ebx,%edx
80106516:	ee                   	out    %al,(%dx)
80106517:	b8 03 00 00 00       	mov    $0x3,%eax
8010651c:	89 f2                	mov    %esi,%edx
8010651e:	ee                   	out    %al,(%dx)
8010651f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106524:	89 c8                	mov    %ecx,%eax
80106526:	ee                   	out    %al,(%dx)
80106527:	b8 01 00 00 00       	mov    $0x1,%eax
8010652c:	89 da                	mov    %ebx,%edx
8010652e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010652f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106534:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106535:	3c ff                	cmp    $0xff,%al
80106537:	74 78                	je     801065b1 <uartinit+0xd1>
  uart = 1;
80106539:	c7 05 40 55 11 80 01 	movl   $0x1,0x80115540
80106540:	00 00 00 
80106543:	89 fa                	mov    %edi,%edx
80106545:	ec                   	in     (%dx),%al
80106546:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010654b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010654c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010654f:	bf b8 84 10 80       	mov    $0x801084b8,%edi
80106554:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106559:	6a 00                	push   $0x0
8010655b:	6a 04                	push   $0x4
8010655d:	e8 be c3 ff ff       	call   80102920 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106562:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106566:	83 c4 10             	add    $0x10,%esp
80106569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106570:	a1 40 55 11 80       	mov    0x80115540,%eax
80106575:	bb 80 00 00 00       	mov    $0x80,%ebx
8010657a:	85 c0                	test   %eax,%eax
8010657c:	75 14                	jne    80106592 <uartinit+0xb2>
8010657e:	eb 23                	jmp    801065a3 <uartinit+0xc3>
    microdelay(10);
80106580:	83 ec 0c             	sub    $0xc,%esp
80106583:	6a 0a                	push   $0xa
80106585:	e8 46 c8 ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010658a:	83 c4 10             	add    $0x10,%esp
8010658d:	83 eb 01             	sub    $0x1,%ebx
80106590:	74 07                	je     80106599 <uartinit+0xb9>
80106592:	89 f2                	mov    %esi,%edx
80106594:	ec                   	in     (%dx),%al
80106595:	a8 20                	test   $0x20,%al
80106597:	74 e7                	je     80106580 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106599:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010659d:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065a2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801065a3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801065a7:	83 c7 01             	add    $0x1,%edi
801065aa:	88 45 e7             	mov    %al,-0x19(%ebp)
801065ad:	84 c0                	test   %al,%al
801065af:	75 bf                	jne    80106570 <uartinit+0x90>
}
801065b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b4:	5b                   	pop    %ebx
801065b5:	5e                   	pop    %esi
801065b6:	5f                   	pop    %edi
801065b7:	5d                   	pop    %ebp
801065b8:	c3                   	ret    
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065c0 <uartputc>:
  if(!uart)
801065c0:	a1 40 55 11 80       	mov    0x80115540,%eax
801065c5:	85 c0                	test   %eax,%eax
801065c7:	74 47                	je     80106610 <uartputc+0x50>
{
801065c9:	55                   	push   %ebp
801065ca:	89 e5                	mov    %esp,%ebp
801065cc:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801065d2:	53                   	push   %ebx
801065d3:	bb 80 00 00 00       	mov    $0x80,%ebx
801065d8:	eb 18                	jmp    801065f2 <uartputc+0x32>
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	6a 0a                	push   $0xa
801065e5:	e8 e6 c7 ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ea:	83 c4 10             	add    $0x10,%esp
801065ed:	83 eb 01             	sub    $0x1,%ebx
801065f0:	74 07                	je     801065f9 <uartputc+0x39>
801065f2:	89 f2                	mov    %esi,%edx
801065f4:	ec                   	in     (%dx),%al
801065f5:	a8 20                	test   $0x20,%al
801065f7:	74 e7                	je     801065e0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065f9:	8b 45 08             	mov    0x8(%ebp),%eax
801065fc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106601:	ee                   	out    %al,(%dx)
}
80106602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106605:	5b                   	pop    %ebx
80106606:	5e                   	pop    %esi
80106607:	5d                   	pop    %ebp
80106608:	c3                   	ret    
80106609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106610:	c3                   	ret    
80106611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010661f:	90                   	nop

80106620 <uartintr>:

void
uartintr(void)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106626:	68 b0 64 10 80       	push   $0x801064b0
8010662b:	e8 00 a6 ff ff       	call   80100c30 <consoleintr>
}
80106630:	83 c4 10             	add    $0x10,%esp
80106633:	c9                   	leave  
80106634:	c3                   	ret    

80106635 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $0
80106637:	6a 00                	push   $0x0
  jmp alltraps
80106639:	e9 07 fb ff ff       	jmp    80106145 <alltraps>

8010663e <vector1>:
.globl vector1
vector1:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $1
80106640:	6a 01                	push   $0x1
  jmp alltraps
80106642:	e9 fe fa ff ff       	jmp    80106145 <alltraps>

80106647 <vector2>:
.globl vector2
vector2:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $2
80106649:	6a 02                	push   $0x2
  jmp alltraps
8010664b:	e9 f5 fa ff ff       	jmp    80106145 <alltraps>

80106650 <vector3>:
.globl vector3
vector3:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $3
80106652:	6a 03                	push   $0x3
  jmp alltraps
80106654:	e9 ec fa ff ff       	jmp    80106145 <alltraps>

80106659 <vector4>:
.globl vector4
vector4:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $4
8010665b:	6a 04                	push   $0x4
  jmp alltraps
8010665d:	e9 e3 fa ff ff       	jmp    80106145 <alltraps>

80106662 <vector5>:
.globl vector5
vector5:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $5
80106664:	6a 05                	push   $0x5
  jmp alltraps
80106666:	e9 da fa ff ff       	jmp    80106145 <alltraps>

8010666b <vector6>:
.globl vector6
vector6:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $6
8010666d:	6a 06                	push   $0x6
  jmp alltraps
8010666f:	e9 d1 fa ff ff       	jmp    80106145 <alltraps>

80106674 <vector7>:
.globl vector7
vector7:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $7
80106676:	6a 07                	push   $0x7
  jmp alltraps
80106678:	e9 c8 fa ff ff       	jmp    80106145 <alltraps>

8010667d <vector8>:
.globl vector8
vector8:
  pushl $8
8010667d:	6a 08                	push   $0x8
  jmp alltraps
8010667f:	e9 c1 fa ff ff       	jmp    80106145 <alltraps>

80106684 <vector9>:
.globl vector9
vector9:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $9
80106686:	6a 09                	push   $0x9
  jmp alltraps
80106688:	e9 b8 fa ff ff       	jmp    80106145 <alltraps>

8010668d <vector10>:
.globl vector10
vector10:
  pushl $10
8010668d:	6a 0a                	push   $0xa
  jmp alltraps
8010668f:	e9 b1 fa ff ff       	jmp    80106145 <alltraps>

80106694 <vector11>:
.globl vector11
vector11:
  pushl $11
80106694:	6a 0b                	push   $0xb
  jmp alltraps
80106696:	e9 aa fa ff ff       	jmp    80106145 <alltraps>

8010669b <vector12>:
.globl vector12
vector12:
  pushl $12
8010669b:	6a 0c                	push   $0xc
  jmp alltraps
8010669d:	e9 a3 fa ff ff       	jmp    80106145 <alltraps>

801066a2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066a2:	6a 0d                	push   $0xd
  jmp alltraps
801066a4:	e9 9c fa ff ff       	jmp    80106145 <alltraps>

801066a9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066a9:	6a 0e                	push   $0xe
  jmp alltraps
801066ab:	e9 95 fa ff ff       	jmp    80106145 <alltraps>

801066b0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $15
801066b2:	6a 0f                	push   $0xf
  jmp alltraps
801066b4:	e9 8c fa ff ff       	jmp    80106145 <alltraps>

801066b9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $16
801066bb:	6a 10                	push   $0x10
  jmp alltraps
801066bd:	e9 83 fa ff ff       	jmp    80106145 <alltraps>

801066c2 <vector17>:
.globl vector17
vector17:
  pushl $17
801066c2:	6a 11                	push   $0x11
  jmp alltraps
801066c4:	e9 7c fa ff ff       	jmp    80106145 <alltraps>

801066c9 <vector18>:
.globl vector18
vector18:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $18
801066cb:	6a 12                	push   $0x12
  jmp alltraps
801066cd:	e9 73 fa ff ff       	jmp    80106145 <alltraps>

801066d2 <vector19>:
.globl vector19
vector19:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $19
801066d4:	6a 13                	push   $0x13
  jmp alltraps
801066d6:	e9 6a fa ff ff       	jmp    80106145 <alltraps>

801066db <vector20>:
.globl vector20
vector20:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $20
801066dd:	6a 14                	push   $0x14
  jmp alltraps
801066df:	e9 61 fa ff ff       	jmp    80106145 <alltraps>

801066e4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $21
801066e6:	6a 15                	push   $0x15
  jmp alltraps
801066e8:	e9 58 fa ff ff       	jmp    80106145 <alltraps>

801066ed <vector22>:
.globl vector22
vector22:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $22
801066ef:	6a 16                	push   $0x16
  jmp alltraps
801066f1:	e9 4f fa ff ff       	jmp    80106145 <alltraps>

801066f6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $23
801066f8:	6a 17                	push   $0x17
  jmp alltraps
801066fa:	e9 46 fa ff ff       	jmp    80106145 <alltraps>

801066ff <vector24>:
.globl vector24
vector24:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $24
80106701:	6a 18                	push   $0x18
  jmp alltraps
80106703:	e9 3d fa ff ff       	jmp    80106145 <alltraps>

80106708 <vector25>:
.globl vector25
vector25:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $25
8010670a:	6a 19                	push   $0x19
  jmp alltraps
8010670c:	e9 34 fa ff ff       	jmp    80106145 <alltraps>

80106711 <vector26>:
.globl vector26
vector26:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $26
80106713:	6a 1a                	push   $0x1a
  jmp alltraps
80106715:	e9 2b fa ff ff       	jmp    80106145 <alltraps>

8010671a <vector27>:
.globl vector27
vector27:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $27
8010671c:	6a 1b                	push   $0x1b
  jmp alltraps
8010671e:	e9 22 fa ff ff       	jmp    80106145 <alltraps>

80106723 <vector28>:
.globl vector28
vector28:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $28
80106725:	6a 1c                	push   $0x1c
  jmp alltraps
80106727:	e9 19 fa ff ff       	jmp    80106145 <alltraps>

8010672c <vector29>:
.globl vector29
vector29:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $29
8010672e:	6a 1d                	push   $0x1d
  jmp alltraps
80106730:	e9 10 fa ff ff       	jmp    80106145 <alltraps>

80106735 <vector30>:
.globl vector30
vector30:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $30
80106737:	6a 1e                	push   $0x1e
  jmp alltraps
80106739:	e9 07 fa ff ff       	jmp    80106145 <alltraps>

8010673e <vector31>:
.globl vector31
vector31:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $31
80106740:	6a 1f                	push   $0x1f
  jmp alltraps
80106742:	e9 fe f9 ff ff       	jmp    80106145 <alltraps>

80106747 <vector32>:
.globl vector32
vector32:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $32
80106749:	6a 20                	push   $0x20
  jmp alltraps
8010674b:	e9 f5 f9 ff ff       	jmp    80106145 <alltraps>

80106750 <vector33>:
.globl vector33
vector33:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $33
80106752:	6a 21                	push   $0x21
  jmp alltraps
80106754:	e9 ec f9 ff ff       	jmp    80106145 <alltraps>

80106759 <vector34>:
.globl vector34
vector34:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $34
8010675b:	6a 22                	push   $0x22
  jmp alltraps
8010675d:	e9 e3 f9 ff ff       	jmp    80106145 <alltraps>

80106762 <vector35>:
.globl vector35
vector35:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $35
80106764:	6a 23                	push   $0x23
  jmp alltraps
80106766:	e9 da f9 ff ff       	jmp    80106145 <alltraps>

8010676b <vector36>:
.globl vector36
vector36:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $36
8010676d:	6a 24                	push   $0x24
  jmp alltraps
8010676f:	e9 d1 f9 ff ff       	jmp    80106145 <alltraps>

80106774 <vector37>:
.globl vector37
vector37:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $37
80106776:	6a 25                	push   $0x25
  jmp alltraps
80106778:	e9 c8 f9 ff ff       	jmp    80106145 <alltraps>

8010677d <vector38>:
.globl vector38
vector38:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $38
8010677f:	6a 26                	push   $0x26
  jmp alltraps
80106781:	e9 bf f9 ff ff       	jmp    80106145 <alltraps>

80106786 <vector39>:
.globl vector39
vector39:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $39
80106788:	6a 27                	push   $0x27
  jmp alltraps
8010678a:	e9 b6 f9 ff ff       	jmp    80106145 <alltraps>

8010678f <vector40>:
.globl vector40
vector40:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $40
80106791:	6a 28                	push   $0x28
  jmp alltraps
80106793:	e9 ad f9 ff ff       	jmp    80106145 <alltraps>

80106798 <vector41>:
.globl vector41
vector41:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $41
8010679a:	6a 29                	push   $0x29
  jmp alltraps
8010679c:	e9 a4 f9 ff ff       	jmp    80106145 <alltraps>

801067a1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $42
801067a3:	6a 2a                	push   $0x2a
  jmp alltraps
801067a5:	e9 9b f9 ff ff       	jmp    80106145 <alltraps>

801067aa <vector43>:
.globl vector43
vector43:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $43
801067ac:	6a 2b                	push   $0x2b
  jmp alltraps
801067ae:	e9 92 f9 ff ff       	jmp    80106145 <alltraps>

801067b3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $44
801067b5:	6a 2c                	push   $0x2c
  jmp alltraps
801067b7:	e9 89 f9 ff ff       	jmp    80106145 <alltraps>

801067bc <vector45>:
.globl vector45
vector45:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $45
801067be:	6a 2d                	push   $0x2d
  jmp alltraps
801067c0:	e9 80 f9 ff ff       	jmp    80106145 <alltraps>

801067c5 <vector46>:
.globl vector46
vector46:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $46
801067c7:	6a 2e                	push   $0x2e
  jmp alltraps
801067c9:	e9 77 f9 ff ff       	jmp    80106145 <alltraps>

801067ce <vector47>:
.globl vector47
vector47:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $47
801067d0:	6a 2f                	push   $0x2f
  jmp alltraps
801067d2:	e9 6e f9 ff ff       	jmp    80106145 <alltraps>

801067d7 <vector48>:
.globl vector48
vector48:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $48
801067d9:	6a 30                	push   $0x30
  jmp alltraps
801067db:	e9 65 f9 ff ff       	jmp    80106145 <alltraps>

801067e0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $49
801067e2:	6a 31                	push   $0x31
  jmp alltraps
801067e4:	e9 5c f9 ff ff       	jmp    80106145 <alltraps>

801067e9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $50
801067eb:	6a 32                	push   $0x32
  jmp alltraps
801067ed:	e9 53 f9 ff ff       	jmp    80106145 <alltraps>

801067f2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $51
801067f4:	6a 33                	push   $0x33
  jmp alltraps
801067f6:	e9 4a f9 ff ff       	jmp    80106145 <alltraps>

801067fb <vector52>:
.globl vector52
vector52:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $52
801067fd:	6a 34                	push   $0x34
  jmp alltraps
801067ff:	e9 41 f9 ff ff       	jmp    80106145 <alltraps>

80106804 <vector53>:
.globl vector53
vector53:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $53
80106806:	6a 35                	push   $0x35
  jmp alltraps
80106808:	e9 38 f9 ff ff       	jmp    80106145 <alltraps>

8010680d <vector54>:
.globl vector54
vector54:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $54
8010680f:	6a 36                	push   $0x36
  jmp alltraps
80106811:	e9 2f f9 ff ff       	jmp    80106145 <alltraps>

80106816 <vector55>:
.globl vector55
vector55:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $55
80106818:	6a 37                	push   $0x37
  jmp alltraps
8010681a:	e9 26 f9 ff ff       	jmp    80106145 <alltraps>

8010681f <vector56>:
.globl vector56
vector56:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $56
80106821:	6a 38                	push   $0x38
  jmp alltraps
80106823:	e9 1d f9 ff ff       	jmp    80106145 <alltraps>

80106828 <vector57>:
.globl vector57
vector57:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $57
8010682a:	6a 39                	push   $0x39
  jmp alltraps
8010682c:	e9 14 f9 ff ff       	jmp    80106145 <alltraps>

80106831 <vector58>:
.globl vector58
vector58:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $58
80106833:	6a 3a                	push   $0x3a
  jmp alltraps
80106835:	e9 0b f9 ff ff       	jmp    80106145 <alltraps>

8010683a <vector59>:
.globl vector59
vector59:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $59
8010683c:	6a 3b                	push   $0x3b
  jmp alltraps
8010683e:	e9 02 f9 ff ff       	jmp    80106145 <alltraps>

80106843 <vector60>:
.globl vector60
vector60:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $60
80106845:	6a 3c                	push   $0x3c
  jmp alltraps
80106847:	e9 f9 f8 ff ff       	jmp    80106145 <alltraps>

8010684c <vector61>:
.globl vector61
vector61:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $61
8010684e:	6a 3d                	push   $0x3d
  jmp alltraps
80106850:	e9 f0 f8 ff ff       	jmp    80106145 <alltraps>

80106855 <vector62>:
.globl vector62
vector62:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $62
80106857:	6a 3e                	push   $0x3e
  jmp alltraps
80106859:	e9 e7 f8 ff ff       	jmp    80106145 <alltraps>

8010685e <vector63>:
.globl vector63
vector63:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $63
80106860:	6a 3f                	push   $0x3f
  jmp alltraps
80106862:	e9 de f8 ff ff       	jmp    80106145 <alltraps>

80106867 <vector64>:
.globl vector64
vector64:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $64
80106869:	6a 40                	push   $0x40
  jmp alltraps
8010686b:	e9 d5 f8 ff ff       	jmp    80106145 <alltraps>

80106870 <vector65>:
.globl vector65
vector65:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $65
80106872:	6a 41                	push   $0x41
  jmp alltraps
80106874:	e9 cc f8 ff ff       	jmp    80106145 <alltraps>

80106879 <vector66>:
.globl vector66
vector66:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $66
8010687b:	6a 42                	push   $0x42
  jmp alltraps
8010687d:	e9 c3 f8 ff ff       	jmp    80106145 <alltraps>

80106882 <vector67>:
.globl vector67
vector67:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $67
80106884:	6a 43                	push   $0x43
  jmp alltraps
80106886:	e9 ba f8 ff ff       	jmp    80106145 <alltraps>

8010688b <vector68>:
.globl vector68
vector68:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $68
8010688d:	6a 44                	push   $0x44
  jmp alltraps
8010688f:	e9 b1 f8 ff ff       	jmp    80106145 <alltraps>

80106894 <vector69>:
.globl vector69
vector69:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $69
80106896:	6a 45                	push   $0x45
  jmp alltraps
80106898:	e9 a8 f8 ff ff       	jmp    80106145 <alltraps>

8010689d <vector70>:
.globl vector70
vector70:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $70
8010689f:	6a 46                	push   $0x46
  jmp alltraps
801068a1:	e9 9f f8 ff ff       	jmp    80106145 <alltraps>

801068a6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $71
801068a8:	6a 47                	push   $0x47
  jmp alltraps
801068aa:	e9 96 f8 ff ff       	jmp    80106145 <alltraps>

801068af <vector72>:
.globl vector72
vector72:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $72
801068b1:	6a 48                	push   $0x48
  jmp alltraps
801068b3:	e9 8d f8 ff ff       	jmp    80106145 <alltraps>

801068b8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $73
801068ba:	6a 49                	push   $0x49
  jmp alltraps
801068bc:	e9 84 f8 ff ff       	jmp    80106145 <alltraps>

801068c1 <vector74>:
.globl vector74
vector74:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $74
801068c3:	6a 4a                	push   $0x4a
  jmp alltraps
801068c5:	e9 7b f8 ff ff       	jmp    80106145 <alltraps>

801068ca <vector75>:
.globl vector75
vector75:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $75
801068cc:	6a 4b                	push   $0x4b
  jmp alltraps
801068ce:	e9 72 f8 ff ff       	jmp    80106145 <alltraps>

801068d3 <vector76>:
.globl vector76
vector76:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $76
801068d5:	6a 4c                	push   $0x4c
  jmp alltraps
801068d7:	e9 69 f8 ff ff       	jmp    80106145 <alltraps>

801068dc <vector77>:
.globl vector77
vector77:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $77
801068de:	6a 4d                	push   $0x4d
  jmp alltraps
801068e0:	e9 60 f8 ff ff       	jmp    80106145 <alltraps>

801068e5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $78
801068e7:	6a 4e                	push   $0x4e
  jmp alltraps
801068e9:	e9 57 f8 ff ff       	jmp    80106145 <alltraps>

801068ee <vector79>:
.globl vector79
vector79:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $79
801068f0:	6a 4f                	push   $0x4f
  jmp alltraps
801068f2:	e9 4e f8 ff ff       	jmp    80106145 <alltraps>

801068f7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $80
801068f9:	6a 50                	push   $0x50
  jmp alltraps
801068fb:	e9 45 f8 ff ff       	jmp    80106145 <alltraps>

80106900 <vector81>:
.globl vector81
vector81:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $81
80106902:	6a 51                	push   $0x51
  jmp alltraps
80106904:	e9 3c f8 ff ff       	jmp    80106145 <alltraps>

80106909 <vector82>:
.globl vector82
vector82:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $82
8010690b:	6a 52                	push   $0x52
  jmp alltraps
8010690d:	e9 33 f8 ff ff       	jmp    80106145 <alltraps>

80106912 <vector83>:
.globl vector83
vector83:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $83
80106914:	6a 53                	push   $0x53
  jmp alltraps
80106916:	e9 2a f8 ff ff       	jmp    80106145 <alltraps>

8010691b <vector84>:
.globl vector84
vector84:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $84
8010691d:	6a 54                	push   $0x54
  jmp alltraps
8010691f:	e9 21 f8 ff ff       	jmp    80106145 <alltraps>

80106924 <vector85>:
.globl vector85
vector85:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $85
80106926:	6a 55                	push   $0x55
  jmp alltraps
80106928:	e9 18 f8 ff ff       	jmp    80106145 <alltraps>

8010692d <vector86>:
.globl vector86
vector86:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $86
8010692f:	6a 56                	push   $0x56
  jmp alltraps
80106931:	e9 0f f8 ff ff       	jmp    80106145 <alltraps>

80106936 <vector87>:
.globl vector87
vector87:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $87
80106938:	6a 57                	push   $0x57
  jmp alltraps
8010693a:	e9 06 f8 ff ff       	jmp    80106145 <alltraps>

8010693f <vector88>:
.globl vector88
vector88:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $88
80106941:	6a 58                	push   $0x58
  jmp alltraps
80106943:	e9 fd f7 ff ff       	jmp    80106145 <alltraps>

80106948 <vector89>:
.globl vector89
vector89:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $89
8010694a:	6a 59                	push   $0x59
  jmp alltraps
8010694c:	e9 f4 f7 ff ff       	jmp    80106145 <alltraps>

80106951 <vector90>:
.globl vector90
vector90:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $90
80106953:	6a 5a                	push   $0x5a
  jmp alltraps
80106955:	e9 eb f7 ff ff       	jmp    80106145 <alltraps>

8010695a <vector91>:
.globl vector91
vector91:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $91
8010695c:	6a 5b                	push   $0x5b
  jmp alltraps
8010695e:	e9 e2 f7 ff ff       	jmp    80106145 <alltraps>

80106963 <vector92>:
.globl vector92
vector92:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $92
80106965:	6a 5c                	push   $0x5c
  jmp alltraps
80106967:	e9 d9 f7 ff ff       	jmp    80106145 <alltraps>

8010696c <vector93>:
.globl vector93
vector93:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $93
8010696e:	6a 5d                	push   $0x5d
  jmp alltraps
80106970:	e9 d0 f7 ff ff       	jmp    80106145 <alltraps>

80106975 <vector94>:
.globl vector94
vector94:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $94
80106977:	6a 5e                	push   $0x5e
  jmp alltraps
80106979:	e9 c7 f7 ff ff       	jmp    80106145 <alltraps>

8010697e <vector95>:
.globl vector95
vector95:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $95
80106980:	6a 5f                	push   $0x5f
  jmp alltraps
80106982:	e9 be f7 ff ff       	jmp    80106145 <alltraps>

80106987 <vector96>:
.globl vector96
vector96:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $96
80106989:	6a 60                	push   $0x60
  jmp alltraps
8010698b:	e9 b5 f7 ff ff       	jmp    80106145 <alltraps>

80106990 <vector97>:
.globl vector97
vector97:
  pushl $0
80106990:	6a 00                	push   $0x0
  pushl $97
80106992:	6a 61                	push   $0x61
  jmp alltraps
80106994:	e9 ac f7 ff ff       	jmp    80106145 <alltraps>

80106999 <vector98>:
.globl vector98
vector98:
  pushl $0
80106999:	6a 00                	push   $0x0
  pushl $98
8010699b:	6a 62                	push   $0x62
  jmp alltraps
8010699d:	e9 a3 f7 ff ff       	jmp    80106145 <alltraps>

801069a2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069a2:	6a 00                	push   $0x0
  pushl $99
801069a4:	6a 63                	push   $0x63
  jmp alltraps
801069a6:	e9 9a f7 ff ff       	jmp    80106145 <alltraps>

801069ab <vector100>:
.globl vector100
vector100:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $100
801069ad:	6a 64                	push   $0x64
  jmp alltraps
801069af:	e9 91 f7 ff ff       	jmp    80106145 <alltraps>

801069b4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069b4:	6a 00                	push   $0x0
  pushl $101
801069b6:	6a 65                	push   $0x65
  jmp alltraps
801069b8:	e9 88 f7 ff ff       	jmp    80106145 <alltraps>

801069bd <vector102>:
.globl vector102
vector102:
  pushl $0
801069bd:	6a 00                	push   $0x0
  pushl $102
801069bf:	6a 66                	push   $0x66
  jmp alltraps
801069c1:	e9 7f f7 ff ff       	jmp    80106145 <alltraps>

801069c6 <vector103>:
.globl vector103
vector103:
  pushl $0
801069c6:	6a 00                	push   $0x0
  pushl $103
801069c8:	6a 67                	push   $0x67
  jmp alltraps
801069ca:	e9 76 f7 ff ff       	jmp    80106145 <alltraps>

801069cf <vector104>:
.globl vector104
vector104:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $104
801069d1:	6a 68                	push   $0x68
  jmp alltraps
801069d3:	e9 6d f7 ff ff       	jmp    80106145 <alltraps>

801069d8 <vector105>:
.globl vector105
vector105:
  pushl $0
801069d8:	6a 00                	push   $0x0
  pushl $105
801069da:	6a 69                	push   $0x69
  jmp alltraps
801069dc:	e9 64 f7 ff ff       	jmp    80106145 <alltraps>

801069e1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069e1:	6a 00                	push   $0x0
  pushl $106
801069e3:	6a 6a                	push   $0x6a
  jmp alltraps
801069e5:	e9 5b f7 ff ff       	jmp    80106145 <alltraps>

801069ea <vector107>:
.globl vector107
vector107:
  pushl $0
801069ea:	6a 00                	push   $0x0
  pushl $107
801069ec:	6a 6b                	push   $0x6b
  jmp alltraps
801069ee:	e9 52 f7 ff ff       	jmp    80106145 <alltraps>

801069f3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $108
801069f5:	6a 6c                	push   $0x6c
  jmp alltraps
801069f7:	e9 49 f7 ff ff       	jmp    80106145 <alltraps>

801069fc <vector109>:
.globl vector109
vector109:
  pushl $0
801069fc:	6a 00                	push   $0x0
  pushl $109
801069fe:	6a 6d                	push   $0x6d
  jmp alltraps
80106a00:	e9 40 f7 ff ff       	jmp    80106145 <alltraps>

80106a05 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a05:	6a 00                	push   $0x0
  pushl $110
80106a07:	6a 6e                	push   $0x6e
  jmp alltraps
80106a09:	e9 37 f7 ff ff       	jmp    80106145 <alltraps>

80106a0e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a0e:	6a 00                	push   $0x0
  pushl $111
80106a10:	6a 6f                	push   $0x6f
  jmp alltraps
80106a12:	e9 2e f7 ff ff       	jmp    80106145 <alltraps>

80106a17 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $112
80106a19:	6a 70                	push   $0x70
  jmp alltraps
80106a1b:	e9 25 f7 ff ff       	jmp    80106145 <alltraps>

80106a20 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a20:	6a 00                	push   $0x0
  pushl $113
80106a22:	6a 71                	push   $0x71
  jmp alltraps
80106a24:	e9 1c f7 ff ff       	jmp    80106145 <alltraps>

80106a29 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a29:	6a 00                	push   $0x0
  pushl $114
80106a2b:	6a 72                	push   $0x72
  jmp alltraps
80106a2d:	e9 13 f7 ff ff       	jmp    80106145 <alltraps>

80106a32 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a32:	6a 00                	push   $0x0
  pushl $115
80106a34:	6a 73                	push   $0x73
  jmp alltraps
80106a36:	e9 0a f7 ff ff       	jmp    80106145 <alltraps>

80106a3b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $116
80106a3d:	6a 74                	push   $0x74
  jmp alltraps
80106a3f:	e9 01 f7 ff ff       	jmp    80106145 <alltraps>

80106a44 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a44:	6a 00                	push   $0x0
  pushl $117
80106a46:	6a 75                	push   $0x75
  jmp alltraps
80106a48:	e9 f8 f6 ff ff       	jmp    80106145 <alltraps>

80106a4d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a4d:	6a 00                	push   $0x0
  pushl $118
80106a4f:	6a 76                	push   $0x76
  jmp alltraps
80106a51:	e9 ef f6 ff ff       	jmp    80106145 <alltraps>

80106a56 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a56:	6a 00                	push   $0x0
  pushl $119
80106a58:	6a 77                	push   $0x77
  jmp alltraps
80106a5a:	e9 e6 f6 ff ff       	jmp    80106145 <alltraps>

80106a5f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $120
80106a61:	6a 78                	push   $0x78
  jmp alltraps
80106a63:	e9 dd f6 ff ff       	jmp    80106145 <alltraps>

80106a68 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a68:	6a 00                	push   $0x0
  pushl $121
80106a6a:	6a 79                	push   $0x79
  jmp alltraps
80106a6c:	e9 d4 f6 ff ff       	jmp    80106145 <alltraps>

80106a71 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a71:	6a 00                	push   $0x0
  pushl $122
80106a73:	6a 7a                	push   $0x7a
  jmp alltraps
80106a75:	e9 cb f6 ff ff       	jmp    80106145 <alltraps>

80106a7a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a7a:	6a 00                	push   $0x0
  pushl $123
80106a7c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a7e:	e9 c2 f6 ff ff       	jmp    80106145 <alltraps>

80106a83 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $124
80106a85:	6a 7c                	push   $0x7c
  jmp alltraps
80106a87:	e9 b9 f6 ff ff       	jmp    80106145 <alltraps>

80106a8c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a8c:	6a 00                	push   $0x0
  pushl $125
80106a8e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a90:	e9 b0 f6 ff ff       	jmp    80106145 <alltraps>

80106a95 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $126
80106a97:	6a 7e                	push   $0x7e
  jmp alltraps
80106a99:	e9 a7 f6 ff ff       	jmp    80106145 <alltraps>

80106a9e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $127
80106aa0:	6a 7f                	push   $0x7f
  jmp alltraps
80106aa2:	e9 9e f6 ff ff       	jmp    80106145 <alltraps>

80106aa7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $128
80106aa9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106aae:	e9 92 f6 ff ff       	jmp    80106145 <alltraps>

80106ab3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $129
80106ab5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106aba:	e9 86 f6 ff ff       	jmp    80106145 <alltraps>

80106abf <vector130>:
.globl vector130
vector130:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $130
80106ac1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ac6:	e9 7a f6 ff ff       	jmp    80106145 <alltraps>

80106acb <vector131>:
.globl vector131
vector131:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $131
80106acd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ad2:	e9 6e f6 ff ff       	jmp    80106145 <alltraps>

80106ad7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $132
80106ad9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ade:	e9 62 f6 ff ff       	jmp    80106145 <alltraps>

80106ae3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $133
80106ae5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106aea:	e9 56 f6 ff ff       	jmp    80106145 <alltraps>

80106aef <vector134>:
.globl vector134
vector134:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $134
80106af1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106af6:	e9 4a f6 ff ff       	jmp    80106145 <alltraps>

80106afb <vector135>:
.globl vector135
vector135:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $135
80106afd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b02:	e9 3e f6 ff ff       	jmp    80106145 <alltraps>

80106b07 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $136
80106b09:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b0e:	e9 32 f6 ff ff       	jmp    80106145 <alltraps>

80106b13 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $137
80106b15:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b1a:	e9 26 f6 ff ff       	jmp    80106145 <alltraps>

80106b1f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $138
80106b21:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b26:	e9 1a f6 ff ff       	jmp    80106145 <alltraps>

80106b2b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $139
80106b2d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b32:	e9 0e f6 ff ff       	jmp    80106145 <alltraps>

80106b37 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $140
80106b39:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b3e:	e9 02 f6 ff ff       	jmp    80106145 <alltraps>

80106b43 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $141
80106b45:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b4a:	e9 f6 f5 ff ff       	jmp    80106145 <alltraps>

80106b4f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $142
80106b51:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b56:	e9 ea f5 ff ff       	jmp    80106145 <alltraps>

80106b5b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $143
80106b5d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b62:	e9 de f5 ff ff       	jmp    80106145 <alltraps>

80106b67 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $144
80106b69:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b6e:	e9 d2 f5 ff ff       	jmp    80106145 <alltraps>

80106b73 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $145
80106b75:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b7a:	e9 c6 f5 ff ff       	jmp    80106145 <alltraps>

80106b7f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $146
80106b81:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b86:	e9 ba f5 ff ff       	jmp    80106145 <alltraps>

80106b8b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $147
80106b8d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b92:	e9 ae f5 ff ff       	jmp    80106145 <alltraps>

80106b97 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $148
80106b99:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b9e:	e9 a2 f5 ff ff       	jmp    80106145 <alltraps>

80106ba3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $149
80106ba5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106baa:	e9 96 f5 ff ff       	jmp    80106145 <alltraps>

80106baf <vector150>:
.globl vector150
vector150:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $150
80106bb1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106bb6:	e9 8a f5 ff ff       	jmp    80106145 <alltraps>

80106bbb <vector151>:
.globl vector151
vector151:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $151
80106bbd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106bc2:	e9 7e f5 ff ff       	jmp    80106145 <alltraps>

80106bc7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $152
80106bc9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106bce:	e9 72 f5 ff ff       	jmp    80106145 <alltraps>

80106bd3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $153
80106bd5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bda:	e9 66 f5 ff ff       	jmp    80106145 <alltraps>

80106bdf <vector154>:
.globl vector154
vector154:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $154
80106be1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106be6:	e9 5a f5 ff ff       	jmp    80106145 <alltraps>

80106beb <vector155>:
.globl vector155
vector155:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $155
80106bed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bf2:	e9 4e f5 ff ff       	jmp    80106145 <alltraps>

80106bf7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $156
80106bf9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bfe:	e9 42 f5 ff ff       	jmp    80106145 <alltraps>

80106c03 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $157
80106c05:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c0a:	e9 36 f5 ff ff       	jmp    80106145 <alltraps>

80106c0f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $158
80106c11:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c16:	e9 2a f5 ff ff       	jmp    80106145 <alltraps>

80106c1b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $159
80106c1d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c22:	e9 1e f5 ff ff       	jmp    80106145 <alltraps>

80106c27 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $160
80106c29:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c2e:	e9 12 f5 ff ff       	jmp    80106145 <alltraps>

80106c33 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $161
80106c35:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c3a:	e9 06 f5 ff ff       	jmp    80106145 <alltraps>

80106c3f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $162
80106c41:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c46:	e9 fa f4 ff ff       	jmp    80106145 <alltraps>

80106c4b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $163
80106c4d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c52:	e9 ee f4 ff ff       	jmp    80106145 <alltraps>

80106c57 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $164
80106c59:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c5e:	e9 e2 f4 ff ff       	jmp    80106145 <alltraps>

80106c63 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $165
80106c65:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c6a:	e9 d6 f4 ff ff       	jmp    80106145 <alltraps>

80106c6f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $166
80106c71:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c76:	e9 ca f4 ff ff       	jmp    80106145 <alltraps>

80106c7b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $167
80106c7d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c82:	e9 be f4 ff ff       	jmp    80106145 <alltraps>

80106c87 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $168
80106c89:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c8e:	e9 b2 f4 ff ff       	jmp    80106145 <alltraps>

80106c93 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $169
80106c95:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c9a:	e9 a6 f4 ff ff       	jmp    80106145 <alltraps>

80106c9f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $170
80106ca1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ca6:	e9 9a f4 ff ff       	jmp    80106145 <alltraps>

80106cab <vector171>:
.globl vector171
vector171:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $171
80106cad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106cb2:	e9 8e f4 ff ff       	jmp    80106145 <alltraps>

80106cb7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $172
80106cb9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cbe:	e9 82 f4 ff ff       	jmp    80106145 <alltraps>

80106cc3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $173
80106cc5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106cca:	e9 76 f4 ff ff       	jmp    80106145 <alltraps>

80106ccf <vector174>:
.globl vector174
vector174:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $174
80106cd1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106cd6:	e9 6a f4 ff ff       	jmp    80106145 <alltraps>

80106cdb <vector175>:
.globl vector175
vector175:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $175
80106cdd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ce2:	e9 5e f4 ff ff       	jmp    80106145 <alltraps>

80106ce7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $176
80106ce9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cee:	e9 52 f4 ff ff       	jmp    80106145 <alltraps>

80106cf3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $177
80106cf5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cfa:	e9 46 f4 ff ff       	jmp    80106145 <alltraps>

80106cff <vector178>:
.globl vector178
vector178:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $178
80106d01:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d06:	e9 3a f4 ff ff       	jmp    80106145 <alltraps>

80106d0b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $179
80106d0d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d12:	e9 2e f4 ff ff       	jmp    80106145 <alltraps>

80106d17 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $180
80106d19:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d1e:	e9 22 f4 ff ff       	jmp    80106145 <alltraps>

80106d23 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $181
80106d25:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d2a:	e9 16 f4 ff ff       	jmp    80106145 <alltraps>

80106d2f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $182
80106d31:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d36:	e9 0a f4 ff ff       	jmp    80106145 <alltraps>

80106d3b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $183
80106d3d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d42:	e9 fe f3 ff ff       	jmp    80106145 <alltraps>

80106d47 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $184
80106d49:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d4e:	e9 f2 f3 ff ff       	jmp    80106145 <alltraps>

80106d53 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $185
80106d55:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d5a:	e9 e6 f3 ff ff       	jmp    80106145 <alltraps>

80106d5f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $186
80106d61:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d66:	e9 da f3 ff ff       	jmp    80106145 <alltraps>

80106d6b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $187
80106d6d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d72:	e9 ce f3 ff ff       	jmp    80106145 <alltraps>

80106d77 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $188
80106d79:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d7e:	e9 c2 f3 ff ff       	jmp    80106145 <alltraps>

80106d83 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $189
80106d85:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d8a:	e9 b6 f3 ff ff       	jmp    80106145 <alltraps>

80106d8f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $190
80106d91:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d96:	e9 aa f3 ff ff       	jmp    80106145 <alltraps>

80106d9b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $191
80106d9d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106da2:	e9 9e f3 ff ff       	jmp    80106145 <alltraps>

80106da7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $192
80106da9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dae:	e9 92 f3 ff ff       	jmp    80106145 <alltraps>

80106db3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $193
80106db5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dba:	e9 86 f3 ff ff       	jmp    80106145 <alltraps>

80106dbf <vector194>:
.globl vector194
vector194:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $194
80106dc1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106dc6:	e9 7a f3 ff ff       	jmp    80106145 <alltraps>

80106dcb <vector195>:
.globl vector195
vector195:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $195
80106dcd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106dd2:	e9 6e f3 ff ff       	jmp    80106145 <alltraps>

80106dd7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $196
80106dd9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106dde:	e9 62 f3 ff ff       	jmp    80106145 <alltraps>

80106de3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $197
80106de5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dea:	e9 56 f3 ff ff       	jmp    80106145 <alltraps>

80106def <vector198>:
.globl vector198
vector198:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $198
80106df1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106df6:	e9 4a f3 ff ff       	jmp    80106145 <alltraps>

80106dfb <vector199>:
.globl vector199
vector199:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $199
80106dfd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e02:	e9 3e f3 ff ff       	jmp    80106145 <alltraps>

80106e07 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $200
80106e09:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e0e:	e9 32 f3 ff ff       	jmp    80106145 <alltraps>

80106e13 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $201
80106e15:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e1a:	e9 26 f3 ff ff       	jmp    80106145 <alltraps>

80106e1f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $202
80106e21:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e26:	e9 1a f3 ff ff       	jmp    80106145 <alltraps>

80106e2b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $203
80106e2d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e32:	e9 0e f3 ff ff       	jmp    80106145 <alltraps>

80106e37 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $204
80106e39:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e3e:	e9 02 f3 ff ff       	jmp    80106145 <alltraps>

80106e43 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $205
80106e45:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e4a:	e9 f6 f2 ff ff       	jmp    80106145 <alltraps>

80106e4f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $206
80106e51:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e56:	e9 ea f2 ff ff       	jmp    80106145 <alltraps>

80106e5b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $207
80106e5d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e62:	e9 de f2 ff ff       	jmp    80106145 <alltraps>

80106e67 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $208
80106e69:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e6e:	e9 d2 f2 ff ff       	jmp    80106145 <alltraps>

80106e73 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $209
80106e75:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e7a:	e9 c6 f2 ff ff       	jmp    80106145 <alltraps>

80106e7f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $210
80106e81:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e86:	e9 ba f2 ff ff       	jmp    80106145 <alltraps>

80106e8b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $211
80106e8d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e92:	e9 ae f2 ff ff       	jmp    80106145 <alltraps>

80106e97 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $212
80106e99:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e9e:	e9 a2 f2 ff ff       	jmp    80106145 <alltraps>

80106ea3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $213
80106ea5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eaa:	e9 96 f2 ff ff       	jmp    80106145 <alltraps>

80106eaf <vector214>:
.globl vector214
vector214:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $214
80106eb1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106eb6:	e9 8a f2 ff ff       	jmp    80106145 <alltraps>

80106ebb <vector215>:
.globl vector215
vector215:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $215
80106ebd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106ec2:	e9 7e f2 ff ff       	jmp    80106145 <alltraps>

80106ec7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $216
80106ec9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ece:	e9 72 f2 ff ff       	jmp    80106145 <alltraps>

80106ed3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $217
80106ed5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eda:	e9 66 f2 ff ff       	jmp    80106145 <alltraps>

80106edf <vector218>:
.globl vector218
vector218:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $218
80106ee1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ee6:	e9 5a f2 ff ff       	jmp    80106145 <alltraps>

80106eeb <vector219>:
.globl vector219
vector219:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $219
80106eed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ef2:	e9 4e f2 ff ff       	jmp    80106145 <alltraps>

80106ef7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $220
80106ef9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106efe:	e9 42 f2 ff ff       	jmp    80106145 <alltraps>

80106f03 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $221
80106f05:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f0a:	e9 36 f2 ff ff       	jmp    80106145 <alltraps>

80106f0f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $222
80106f11:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f16:	e9 2a f2 ff ff       	jmp    80106145 <alltraps>

80106f1b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $223
80106f1d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f22:	e9 1e f2 ff ff       	jmp    80106145 <alltraps>

80106f27 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $224
80106f29:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f2e:	e9 12 f2 ff ff       	jmp    80106145 <alltraps>

80106f33 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $225
80106f35:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f3a:	e9 06 f2 ff ff       	jmp    80106145 <alltraps>

80106f3f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $226
80106f41:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f46:	e9 fa f1 ff ff       	jmp    80106145 <alltraps>

80106f4b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $227
80106f4d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f52:	e9 ee f1 ff ff       	jmp    80106145 <alltraps>

80106f57 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $228
80106f59:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f5e:	e9 e2 f1 ff ff       	jmp    80106145 <alltraps>

80106f63 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $229
80106f65:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f6a:	e9 d6 f1 ff ff       	jmp    80106145 <alltraps>

80106f6f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $230
80106f71:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f76:	e9 ca f1 ff ff       	jmp    80106145 <alltraps>

80106f7b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $231
80106f7d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f82:	e9 be f1 ff ff       	jmp    80106145 <alltraps>

80106f87 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $232
80106f89:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f8e:	e9 b2 f1 ff ff       	jmp    80106145 <alltraps>

80106f93 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $233
80106f95:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f9a:	e9 a6 f1 ff ff       	jmp    80106145 <alltraps>

80106f9f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $234
80106fa1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fa6:	e9 9a f1 ff ff       	jmp    80106145 <alltraps>

80106fab <vector235>:
.globl vector235
vector235:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $235
80106fad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106fb2:	e9 8e f1 ff ff       	jmp    80106145 <alltraps>

80106fb7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $236
80106fb9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106fbe:	e9 82 f1 ff ff       	jmp    80106145 <alltraps>

80106fc3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $237
80106fc5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106fca:	e9 76 f1 ff ff       	jmp    80106145 <alltraps>

80106fcf <vector238>:
.globl vector238
vector238:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $238
80106fd1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106fd6:	e9 6a f1 ff ff       	jmp    80106145 <alltraps>

80106fdb <vector239>:
.globl vector239
vector239:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $239
80106fdd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fe2:	e9 5e f1 ff ff       	jmp    80106145 <alltraps>

80106fe7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $240
80106fe9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fee:	e9 52 f1 ff ff       	jmp    80106145 <alltraps>

80106ff3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $241
80106ff5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106ffa:	e9 46 f1 ff ff       	jmp    80106145 <alltraps>

80106fff <vector242>:
.globl vector242
vector242:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $242
80107001:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107006:	e9 3a f1 ff ff       	jmp    80106145 <alltraps>

8010700b <vector243>:
.globl vector243
vector243:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $243
8010700d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107012:	e9 2e f1 ff ff       	jmp    80106145 <alltraps>

80107017 <vector244>:
.globl vector244
vector244:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $244
80107019:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010701e:	e9 22 f1 ff ff       	jmp    80106145 <alltraps>

80107023 <vector245>:
.globl vector245
vector245:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $245
80107025:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010702a:	e9 16 f1 ff ff       	jmp    80106145 <alltraps>

8010702f <vector246>:
.globl vector246
vector246:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $246
80107031:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107036:	e9 0a f1 ff ff       	jmp    80106145 <alltraps>

8010703b <vector247>:
.globl vector247
vector247:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $247
8010703d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107042:	e9 fe f0 ff ff       	jmp    80106145 <alltraps>

80107047 <vector248>:
.globl vector248
vector248:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $248
80107049:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010704e:	e9 f2 f0 ff ff       	jmp    80106145 <alltraps>

80107053 <vector249>:
.globl vector249
vector249:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $249
80107055:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010705a:	e9 e6 f0 ff ff       	jmp    80106145 <alltraps>

8010705f <vector250>:
.globl vector250
vector250:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $250
80107061:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107066:	e9 da f0 ff ff       	jmp    80106145 <alltraps>

8010706b <vector251>:
.globl vector251
vector251:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $251
8010706d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107072:	e9 ce f0 ff ff       	jmp    80106145 <alltraps>

80107077 <vector252>:
.globl vector252
vector252:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $252
80107079:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010707e:	e9 c2 f0 ff ff       	jmp    80106145 <alltraps>

80107083 <vector253>:
.globl vector253
vector253:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $253
80107085:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010708a:	e9 b6 f0 ff ff       	jmp    80106145 <alltraps>

8010708f <vector254>:
.globl vector254
vector254:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $254
80107091:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107096:	e9 aa f0 ff ff       	jmp    80106145 <alltraps>

8010709b <vector255>:
.globl vector255
vector255:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $255
8010709d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070a2:	e9 9e f0 ff ff       	jmp    80106145 <alltraps>
801070a7:	66 90                	xchg   %ax,%ax
801070a9:	66 90                	xchg   %ax,%ax
801070ab:	66 90                	xchg   %ax,%ax
801070ad:	66 90                	xchg   %ax,%ax
801070af:	90                   	nop

801070b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070bc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070c2:	83 ec 1c             	sub    $0x1c,%esp
801070c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801070c8:	39 d3                	cmp    %edx,%ebx
801070ca:	73 49                	jae    80107115 <deallocuvm.part.0+0x65>
801070cc:	89 c7                	mov    %eax,%edi
801070ce:	eb 0c                	jmp    801070dc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801070d0:	83 c0 01             	add    $0x1,%eax
801070d3:	c1 e0 16             	shl    $0x16,%eax
801070d6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801070d8:	39 da                	cmp    %ebx,%edx
801070da:	76 39                	jbe    80107115 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801070dc:	89 d8                	mov    %ebx,%eax
801070de:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801070e1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801070e4:	f6 c1 01             	test   $0x1,%cl
801070e7:	74 e7                	je     801070d0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801070e9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801070eb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801070f1:	c1 ee 0a             	shr    $0xa,%esi
801070f4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801070fa:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107101:	85 f6                	test   %esi,%esi
80107103:	74 cb                	je     801070d0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107105:	8b 06                	mov    (%esi),%eax
80107107:	a8 01                	test   $0x1,%al
80107109:	75 15                	jne    80107120 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010710b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107111:	39 da                	cmp    %ebx,%edx
80107113:	77 c7                	ja     801070dc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107115:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107118:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010711b:	5b                   	pop    %ebx
8010711c:	5e                   	pop    %esi
8010711d:	5f                   	pop    %edi
8010711e:	5d                   	pop    %ebp
8010711f:	c3                   	ret    
      if(pa == 0)
80107120:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107125:	74 25                	je     8010714c <deallocuvm.part.0+0x9c>
      kfree(v);
80107127:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010712a:	05 00 00 00 80       	add    $0x80000000,%eax
8010712f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107132:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107138:	50                   	push   %eax
80107139:	e8 22 b8 ff ff       	call   80102960 <kfree>
      *pte = 0;
8010713e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107147:	83 c4 10             	add    $0x10,%esp
8010714a:	eb 8c                	jmp    801070d8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010714c:	83 ec 0c             	sub    $0xc,%esp
8010714f:	68 06 7d 10 80       	push   $0x80107d06
80107154:	e8 27 92 ff ff       	call   80100380 <panic>
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107160 <mappages>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107166:	89 d3                	mov    %edx,%ebx
80107168:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010716e:	83 ec 1c             	sub    $0x1c,%esp
80107171:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107174:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107178:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010717d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107180:	8b 45 08             	mov    0x8(%ebp),%eax
80107183:	29 d8                	sub    %ebx,%eax
80107185:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107188:	eb 3d                	jmp    801071c7 <mappages+0x67>
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107190:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107192:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107197:	c1 ea 0a             	shr    $0xa,%edx
8010719a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071a7:	85 c0                	test   %eax,%eax
801071a9:	74 75                	je     80107220 <mappages+0xc0>
    if(*pte & PTE_P)
801071ab:	f6 00 01             	testb  $0x1,(%eax)
801071ae:	0f 85 86 00 00 00    	jne    8010723a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071b4:	0b 75 0c             	or     0xc(%ebp),%esi
801071b7:	83 ce 01             	or     $0x1,%esi
801071ba:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071bc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801071bf:	74 6f                	je     80107230 <mappages+0xd0>
    a += PGSIZE;
801071c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801071c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801071ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071cd:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801071d0:	89 d8                	mov    %ebx,%eax
801071d2:	c1 e8 16             	shr    $0x16,%eax
801071d5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801071d8:	8b 07                	mov    (%edi),%eax
801071da:	a8 01                	test   $0x1,%al
801071dc:	75 b2                	jne    80107190 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801071de:	e8 3d b9 ff ff       	call   80102b20 <kalloc>
801071e3:	85 c0                	test   %eax,%eax
801071e5:	74 39                	je     80107220 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801071e7:	83 ec 04             	sub    $0x4,%esp
801071ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
801071ed:	68 00 10 00 00       	push   $0x1000
801071f2:	6a 00                	push   $0x0
801071f4:	50                   	push   %eax
801071f5:	e8 a6 dc ff ff       	call   80104ea0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801071fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801071fd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107200:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107206:	83 c8 07             	or     $0x7,%eax
80107209:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010720b:	89 d8                	mov    %ebx,%eax
8010720d:	c1 e8 0a             	shr    $0xa,%eax
80107210:	25 fc 0f 00 00       	and    $0xffc,%eax
80107215:	01 d0                	add    %edx,%eax
80107217:	eb 92                	jmp    801071ab <mappages+0x4b>
80107219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107220:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107228:	5b                   	pop    %ebx
80107229:	5e                   	pop    %esi
8010722a:	5f                   	pop    %edi
8010722b:	5d                   	pop    %ebp
8010722c:	c3                   	ret    
8010722d:	8d 76 00             	lea    0x0(%esi),%esi
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107233:	31 c0                	xor    %eax,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret    
      panic("remap");
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	68 c0 84 10 80       	push   $0x801084c0
80107242:	e8 39 91 ff ff       	call   80100380 <panic>
80107247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724e:	66 90                	xchg   %ax,%ax

80107250 <seginit>:
{
80107250:	55                   	push   %ebp
80107251:	89 e5                	mov    %esp,%ebp
80107253:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107256:	e8 95 cb ff ff       	call   80103df0 <cpuid>
  pd[0] = size-1;
8010725b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107260:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107266:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010726a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107271:	ff 00 00 
80107274:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
8010727b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010727e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107285:	ff 00 00 
80107288:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
8010728f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107292:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107299:	ff 00 00 
8010729c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801072a3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072a6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801072ad:	ff 00 00 
801072b0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801072b7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ba:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801072bf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072c3:	c1 e8 10             	shr    $0x10,%eax
801072c6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072ca:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072cd:	0f 01 10             	lgdtl  (%eax)
}
801072d0:	c9                   	leave  
801072d1:	c3                   	ret    
801072d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072e0:	a1 44 55 11 80       	mov    0x80115544,%eax
801072e5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ea:	0f 22 d8             	mov    %eax,%cr3
}
801072ed:	c3                   	ret    
801072ee:	66 90                	xchg   %ax,%ax

801072f0 <switchuvm>:
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
801072f9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801072fc:	85 f6                	test   %esi,%esi
801072fe:	0f 84 cb 00 00 00    	je     801073cf <switchuvm+0xdf>
  if(p->kstack == 0)
80107304:	8b 46 08             	mov    0x8(%esi),%eax
80107307:	85 c0                	test   %eax,%eax
80107309:	0f 84 da 00 00 00    	je     801073e9 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010730f:	8b 46 04             	mov    0x4(%esi),%eax
80107312:	85 c0                	test   %eax,%eax
80107314:	0f 84 c2 00 00 00    	je     801073dc <switchuvm+0xec>
  pushcli();
8010731a:	e8 71 d9 ff ff       	call   80104c90 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010731f:	e8 6c ca ff ff       	call   80103d90 <mycpu>
80107324:	89 c3                	mov    %eax,%ebx
80107326:	e8 65 ca ff ff       	call   80103d90 <mycpu>
8010732b:	89 c7                	mov    %eax,%edi
8010732d:	e8 5e ca ff ff       	call   80103d90 <mycpu>
80107332:	83 c7 08             	add    $0x8,%edi
80107335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107338:	e8 53 ca ff ff       	call   80103d90 <mycpu>
8010733d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107340:	ba 67 00 00 00       	mov    $0x67,%edx
80107345:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010734c:	83 c0 08             	add    $0x8,%eax
8010734f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107356:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735b:	83 c1 08             	add    $0x8,%ecx
8010735e:	c1 e8 18             	shr    $0x18,%eax
80107361:	c1 e9 10             	shr    $0x10,%ecx
80107364:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010736a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107370:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107375:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010737c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107381:	e8 0a ca ff ff       	call   80103d90 <mycpu>
80107386:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010738d:	e8 fe c9 ff ff       	call   80103d90 <mycpu>
80107392:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107396:	8b 5e 08             	mov    0x8(%esi),%ebx
80107399:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010739f:	e8 ec c9 ff ff       	call   80103d90 <mycpu>
801073a4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073a7:	e8 e4 c9 ff ff       	call   80103d90 <mycpu>
801073ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073b0:	b8 28 00 00 00       	mov    $0x28,%eax
801073b5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073b8:	8b 46 04             	mov    0x4(%esi),%eax
801073bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073c0:	0f 22 d8             	mov    %eax,%cr3
}
801073c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073c6:	5b                   	pop    %ebx
801073c7:	5e                   	pop    %esi
801073c8:	5f                   	pop    %edi
801073c9:	5d                   	pop    %ebp
  popcli();
801073ca:	e9 11 d9 ff ff       	jmp    80104ce0 <popcli>
    panic("switchuvm: no process");
801073cf:	83 ec 0c             	sub    $0xc,%esp
801073d2:	68 c6 84 10 80       	push   $0x801084c6
801073d7:	e8 a4 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
801073dc:	83 ec 0c             	sub    $0xc,%esp
801073df:	68 f1 84 10 80       	push   $0x801084f1
801073e4:	e8 97 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 dc 84 10 80       	push   $0x801084dc
801073f1:	e8 8a 8f ff ff       	call   80100380 <panic>
801073f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073fd:	8d 76 00             	lea    0x0(%esi),%esi

80107400 <inituvm>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	57                   	push   %edi
80107404:	56                   	push   %esi
80107405:	53                   	push   %ebx
80107406:	83 ec 1c             	sub    $0x1c,%esp
80107409:	8b 45 0c             	mov    0xc(%ebp),%eax
8010740c:	8b 75 10             	mov    0x10(%ebp),%esi
8010740f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107415:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010741b:	77 4b                	ja     80107468 <inituvm+0x68>
  mem = kalloc();
8010741d:	e8 fe b6 ff ff       	call   80102b20 <kalloc>
  memset(mem, 0, PGSIZE);
80107422:	83 ec 04             	sub    $0x4,%esp
80107425:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010742a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010742c:	6a 00                	push   $0x0
8010742e:	50                   	push   %eax
8010742f:	e8 6c da ff ff       	call   80104ea0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107434:	58                   	pop    %eax
80107435:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010743b:	5a                   	pop    %edx
8010743c:	6a 06                	push   $0x6
8010743e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107443:	31 d2                	xor    %edx,%edx
80107445:	50                   	push   %eax
80107446:	89 f8                	mov    %edi,%eax
80107448:	e8 13 fd ff ff       	call   80107160 <mappages>
  memmove(mem, init, sz);
8010744d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107450:	89 75 10             	mov    %esi,0x10(%ebp)
80107453:	83 c4 10             	add    $0x10,%esp
80107456:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107459:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010745c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010745f:	5b                   	pop    %ebx
80107460:	5e                   	pop    %esi
80107461:	5f                   	pop    %edi
80107462:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107463:	e9 d8 da ff ff       	jmp    80104f40 <memmove>
    panic("inituvm: more than a page");
80107468:	83 ec 0c             	sub    $0xc,%esp
8010746b:	68 05 85 10 80       	push   $0x80108505
80107470:	e8 0b 8f ff ff       	call   80100380 <panic>
80107475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010747c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107480 <loaduvm>:
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
80107489:	8b 45 0c             	mov    0xc(%ebp),%eax
8010748c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010748f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107494:	0f 85 bb 00 00 00    	jne    80107555 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010749a:	01 f0                	add    %esi,%eax
8010749c:	89 f3                	mov    %esi,%ebx
8010749e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074a1:	8b 45 14             	mov    0x14(%ebp),%eax
801074a4:	01 f0                	add    %esi,%eax
801074a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074a9:	85 f6                	test   %esi,%esi
801074ab:	0f 84 87 00 00 00    	je     80107538 <loaduvm+0xb8>
801074b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801074b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801074bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074be:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
801074c0:	89 c2                	mov    %eax,%edx
801074c2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801074c5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
801074c8:	f6 c2 01             	test   $0x1,%dl
801074cb:	75 13                	jne    801074e0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
801074cd:	83 ec 0c             	sub    $0xc,%esp
801074d0:	68 1f 85 10 80       	push   $0x8010851f
801074d5:	e8 a6 8e ff ff       	call   80100380 <panic>
801074da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801074e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801074e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801074ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074f5:	85 c0                	test   %eax,%eax
801074f7:	74 d4                	je     801074cd <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801074f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107508:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010750e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107511:	29 d9                	sub    %ebx,%ecx
80107513:	05 00 00 00 80       	add    $0x80000000,%eax
80107518:	57                   	push   %edi
80107519:	51                   	push   %ecx
8010751a:	50                   	push   %eax
8010751b:	ff 75 10             	push   0x10(%ebp)
8010751e:	e8 0d aa ff ff       	call   80101f30 <readi>
80107523:	83 c4 10             	add    $0x10,%esp
80107526:	39 f8                	cmp    %edi,%eax
80107528:	75 1e                	jne    80107548 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010752a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107530:	89 f0                	mov    %esi,%eax
80107532:	29 d8                	sub    %ebx,%eax
80107534:	39 c6                	cmp    %eax,%esi
80107536:	77 80                	ja     801074b8 <loaduvm+0x38>
}
80107538:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010753b:	31 c0                	xor    %eax,%eax
}
8010753d:	5b                   	pop    %ebx
8010753e:	5e                   	pop    %esi
8010753f:	5f                   	pop    %edi
80107540:	5d                   	pop    %ebp
80107541:	c3                   	ret    
80107542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107548:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010754b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107550:	5b                   	pop    %ebx
80107551:	5e                   	pop    %esi
80107552:	5f                   	pop    %edi
80107553:	5d                   	pop    %ebp
80107554:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107555:	83 ec 0c             	sub    $0xc,%esp
80107558:	68 c0 85 10 80       	push   $0x801085c0
8010755d:	e8 1e 8e ff ff       	call   80100380 <panic>
80107562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107570 <allocuvm>:
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107579:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010757c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010757f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107582:	85 c0                	test   %eax,%eax
80107584:	0f 88 b6 00 00 00    	js     80107640 <allocuvm+0xd0>
  if(newsz < oldsz)
8010758a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010758d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107590:	0f 82 9a 00 00 00    	jb     80107630 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107596:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010759c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075a2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075a5:	77 44                	ja     801075eb <allocuvm+0x7b>
801075a7:	e9 87 00 00 00       	jmp    80107633 <allocuvm+0xc3>
801075ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075b0:	83 ec 04             	sub    $0x4,%esp
801075b3:	68 00 10 00 00       	push   $0x1000
801075b8:	6a 00                	push   $0x0
801075ba:	50                   	push   %eax
801075bb:	e8 e0 d8 ff ff       	call   80104ea0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075c0:	58                   	pop    %eax
801075c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075c7:	5a                   	pop    %edx
801075c8:	6a 06                	push   $0x6
801075ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075cf:	89 f2                	mov    %esi,%edx
801075d1:	50                   	push   %eax
801075d2:	89 f8                	mov    %edi,%eax
801075d4:	e8 87 fb ff ff       	call   80107160 <mappages>
801075d9:	83 c4 10             	add    $0x10,%esp
801075dc:	85 c0                	test   %eax,%eax
801075de:	78 78                	js     80107658 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075e9:	76 48                	jbe    80107633 <allocuvm+0xc3>
    mem = kalloc();
801075eb:	e8 30 b5 ff ff       	call   80102b20 <kalloc>
801075f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075f2:	85 c0                	test   %eax,%eax
801075f4:	75 ba                	jne    801075b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075f6:	83 ec 0c             	sub    $0xc,%esp
801075f9:	68 3d 85 10 80       	push   $0x8010853d
801075fe:	e8 ed 90 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107603:	8b 45 0c             	mov    0xc(%ebp),%eax
80107606:	83 c4 10             	add    $0x10,%esp
80107609:	39 45 10             	cmp    %eax,0x10(%ebp)
8010760c:	74 32                	je     80107640 <allocuvm+0xd0>
8010760e:	8b 55 10             	mov    0x10(%ebp),%edx
80107611:	89 c1                	mov    %eax,%ecx
80107613:	89 f8                	mov    %edi,%eax
80107615:	e8 96 fa ff ff       	call   801070b0 <deallocuvm.part.0>
      return 0;
8010761a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107624:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107627:	5b                   	pop    %ebx
80107628:	5e                   	pop    %esi
80107629:	5f                   	pop    %edi
8010762a:	5d                   	pop    %ebp
8010762b:	c3                   	ret    
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107639:	5b                   	pop    %ebx
8010763a:	5e                   	pop    %esi
8010763b:	5f                   	pop    %edi
8010763c:	5d                   	pop    %ebp
8010763d:	c3                   	ret    
8010763e:	66 90                	xchg   %ax,%ax
    return 0;
80107640:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010764a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010764d:	5b                   	pop    %ebx
8010764e:	5e                   	pop    %esi
8010764f:	5f                   	pop    %edi
80107650:	5d                   	pop    %ebp
80107651:	c3                   	ret    
80107652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107658:	83 ec 0c             	sub    $0xc,%esp
8010765b:	68 55 85 10 80       	push   $0x80108555
80107660:	e8 8b 90 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107665:	8b 45 0c             	mov    0xc(%ebp),%eax
80107668:	83 c4 10             	add    $0x10,%esp
8010766b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010766e:	74 0c                	je     8010767c <allocuvm+0x10c>
80107670:	8b 55 10             	mov    0x10(%ebp),%edx
80107673:	89 c1                	mov    %eax,%ecx
80107675:	89 f8                	mov    %edi,%eax
80107677:	e8 34 fa ff ff       	call   801070b0 <deallocuvm.part.0>
      kfree(mem);
8010767c:	83 ec 0c             	sub    $0xc,%esp
8010767f:	53                   	push   %ebx
80107680:	e8 db b2 ff ff       	call   80102960 <kfree>
      return 0;
80107685:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010768c:	83 c4 10             	add    $0x10,%esp
}
8010768f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107692:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107695:	5b                   	pop    %ebx
80107696:	5e                   	pop    %esi
80107697:	5f                   	pop    %edi
80107698:	5d                   	pop    %ebp
80107699:	c3                   	ret    
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076a0 <deallocuvm>:
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076a9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076ac:	39 d1                	cmp    %edx,%ecx
801076ae:	73 10                	jae    801076c0 <deallocuvm+0x20>
}
801076b0:	5d                   	pop    %ebp
801076b1:	e9 fa f9 ff ff       	jmp    801070b0 <deallocuvm.part.0>
801076b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076bd:	8d 76 00             	lea    0x0(%esi),%esi
801076c0:	89 d0                	mov    %edx,%eax
801076c2:	5d                   	pop    %ebp
801076c3:	c3                   	ret    
801076c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076cf:	90                   	nop

801076d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	57                   	push   %edi
801076d4:	56                   	push   %esi
801076d5:	53                   	push   %ebx
801076d6:	83 ec 0c             	sub    $0xc,%esp
801076d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076dc:	85 f6                	test   %esi,%esi
801076de:	74 59                	je     80107739 <freevm+0x69>
  if(newsz >= oldsz)
801076e0:	31 c9                	xor    %ecx,%ecx
801076e2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076e7:	89 f0                	mov    %esi,%eax
801076e9:	89 f3                	mov    %esi,%ebx
801076eb:	e8 c0 f9 ff ff       	call   801070b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076f0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076f6:	eb 0f                	jmp    80107707 <freevm+0x37>
801076f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ff:	90                   	nop
80107700:	83 c3 04             	add    $0x4,%ebx
80107703:	39 df                	cmp    %ebx,%edi
80107705:	74 23                	je     8010772a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107707:	8b 03                	mov    (%ebx),%eax
80107709:	a8 01                	test   $0x1,%al
8010770b:	74 f3                	je     80107700 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010770d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107712:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107715:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107718:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010771d:	50                   	push   %eax
8010771e:	e8 3d b2 ff ff       	call   80102960 <kfree>
80107723:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107726:	39 df                	cmp    %ebx,%edi
80107728:	75 dd                	jne    80107707 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010772a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010772d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107730:	5b                   	pop    %ebx
80107731:	5e                   	pop    %esi
80107732:	5f                   	pop    %edi
80107733:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107734:	e9 27 b2 ff ff       	jmp    80102960 <kfree>
    panic("freevm: no pgdir");
80107739:	83 ec 0c             	sub    $0xc,%esp
8010773c:	68 71 85 10 80       	push   $0x80108571
80107741:	e8 3a 8c ff ff       	call   80100380 <panic>
80107746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010774d:	8d 76 00             	lea    0x0(%esi),%esi

80107750 <setupkvm>:
{
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	56                   	push   %esi
80107754:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107755:	e8 c6 b3 ff ff       	call   80102b20 <kalloc>
8010775a:	89 c6                	mov    %eax,%esi
8010775c:	85 c0                	test   %eax,%eax
8010775e:	74 42                	je     801077a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107760:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107763:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107768:	68 00 10 00 00       	push   $0x1000
8010776d:	6a 00                	push   $0x0
8010776f:	50                   	push   %eax
80107770:	e8 2b d7 ff ff       	call   80104ea0 <memset>
80107775:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107778:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010777b:	83 ec 08             	sub    $0x8,%esp
8010777e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107781:	ff 73 0c             	push   0xc(%ebx)
80107784:	8b 13                	mov    (%ebx),%edx
80107786:	50                   	push   %eax
80107787:	29 c1                	sub    %eax,%ecx
80107789:	89 f0                	mov    %esi,%eax
8010778b:	e8 d0 f9 ff ff       	call   80107160 <mappages>
80107790:	83 c4 10             	add    $0x10,%esp
80107793:	85 c0                	test   %eax,%eax
80107795:	78 19                	js     801077b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107797:	83 c3 10             	add    $0x10,%ebx
8010779a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077a0:	75 d6                	jne    80107778 <setupkvm+0x28>
}
801077a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a5:	89 f0                	mov    %esi,%eax
801077a7:	5b                   	pop    %ebx
801077a8:	5e                   	pop    %esi
801077a9:	5d                   	pop    %ebp
801077aa:	c3                   	ret    
801077ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077af:	90                   	nop
      freevm(pgdir);
801077b0:	83 ec 0c             	sub    $0xc,%esp
801077b3:	56                   	push   %esi
      return 0;
801077b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077b6:	e8 15 ff ff ff       	call   801076d0 <freevm>
      return 0;
801077bb:	83 c4 10             	add    $0x10,%esp
}
801077be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077c1:	89 f0                	mov    %esi,%eax
801077c3:	5b                   	pop    %ebx
801077c4:	5e                   	pop    %esi
801077c5:	5d                   	pop    %ebp
801077c6:	c3                   	ret    
801077c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ce:	66 90                	xchg   %ax,%ax

801077d0 <kvmalloc>:
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077d6:	e8 75 ff ff ff       	call   80107750 <setupkvm>
801077db:	a3 44 55 11 80       	mov    %eax,0x80115544
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077e0:	05 00 00 00 80       	add    $0x80000000,%eax
801077e5:	0f 22 d8             	mov    %eax,%cr3
}
801077e8:	c9                   	leave  
801077e9:	c3                   	ret    
801077ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	83 ec 08             	sub    $0x8,%esp
801077f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801077f9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801077fc:	89 c1                	mov    %eax,%ecx
801077fe:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107801:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107804:	f6 c2 01             	test   $0x1,%dl
80107807:	75 17                	jne    80107820 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107809:	83 ec 0c             	sub    $0xc,%esp
8010780c:	68 82 85 10 80       	push   $0x80108582
80107811:	e8 6a 8b ff ff       	call   80100380 <panic>
80107816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010781d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107820:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107823:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107829:	25 fc 0f 00 00       	and    $0xffc,%eax
8010782e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107835:	85 c0                	test   %eax,%eax
80107837:	74 d0                	je     80107809 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107839:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010783c:	c9                   	leave  
8010783d:	c3                   	ret    
8010783e:	66 90                	xchg   %ax,%ax

80107840 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	57                   	push   %edi
80107844:	56                   	push   %esi
80107845:	53                   	push   %ebx
80107846:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107849:	e8 02 ff ff ff       	call   80107750 <setupkvm>
8010784e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107851:	85 c0                	test   %eax,%eax
80107853:	0f 84 bd 00 00 00    	je     80107916 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010785c:	85 c9                	test   %ecx,%ecx
8010785e:	0f 84 b2 00 00 00    	je     80107916 <copyuvm+0xd6>
80107864:	31 f6                	xor    %esi,%esi
80107866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80107870:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107873:	89 f0                	mov    %esi,%eax
80107875:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107878:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010787b:	a8 01                	test   $0x1,%al
8010787d:	75 11                	jne    80107890 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010787f:	83 ec 0c             	sub    $0xc,%esp
80107882:	68 8c 85 10 80       	push   $0x8010858c
80107887:	e8 f4 8a ff ff       	call   80100380 <panic>
8010788c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107890:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107892:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107897:	c1 ea 0a             	shr    $0xa,%edx
8010789a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078a0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078a7:	85 c0                	test   %eax,%eax
801078a9:	74 d4                	je     8010787f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801078ab:	8b 00                	mov    (%eax),%eax
801078ad:	a8 01                	test   $0x1,%al
801078af:	0f 84 9f 00 00 00    	je     80107954 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078b5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078b7:	25 ff 0f 00 00       	and    $0xfff,%eax
801078bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078bf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801078c5:	e8 56 b2 ff ff       	call   80102b20 <kalloc>
801078ca:	89 c3                	mov    %eax,%ebx
801078cc:	85 c0                	test   %eax,%eax
801078ce:	74 64                	je     80107934 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801078d0:	83 ec 04             	sub    $0x4,%esp
801078d3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801078d9:	68 00 10 00 00       	push   $0x1000
801078de:	57                   	push   %edi
801078df:	50                   	push   %eax
801078e0:	e8 5b d6 ff ff       	call   80104f40 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801078e5:	58                   	pop    %eax
801078e6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078ec:	5a                   	pop    %edx
801078ed:	ff 75 e4             	push   -0x1c(%ebp)
801078f0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078f5:	89 f2                	mov    %esi,%edx
801078f7:	50                   	push   %eax
801078f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078fb:	e8 60 f8 ff ff       	call   80107160 <mappages>
80107900:	83 c4 10             	add    $0x10,%esp
80107903:	85 c0                	test   %eax,%eax
80107905:	78 21                	js     80107928 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107907:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010790d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107910:	0f 87 5a ff ff ff    	ja     80107870 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107916:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010791c:	5b                   	pop    %ebx
8010791d:	5e                   	pop    %esi
8010791e:	5f                   	pop    %edi
8010791f:	5d                   	pop    %ebp
80107920:	c3                   	ret    
80107921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107928:	83 ec 0c             	sub    $0xc,%esp
8010792b:	53                   	push   %ebx
8010792c:	e8 2f b0 ff ff       	call   80102960 <kfree>
      goto bad;
80107931:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107934:	83 ec 0c             	sub    $0xc,%esp
80107937:	ff 75 e0             	push   -0x20(%ebp)
8010793a:	e8 91 fd ff ff       	call   801076d0 <freevm>
  return 0;
8010793f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107946:	83 c4 10             	add    $0x10,%esp
}
80107949:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010794c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010794f:	5b                   	pop    %ebx
80107950:	5e                   	pop    %esi
80107951:	5f                   	pop    %edi
80107952:	5d                   	pop    %ebp
80107953:	c3                   	ret    
      panic("copyuvm: page not present");
80107954:	83 ec 0c             	sub    $0xc,%esp
80107957:	68 a6 85 10 80       	push   $0x801085a6
8010795c:	e8 1f 8a ff ff       	call   80100380 <panic>
80107961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107968:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796f:	90                   	nop

80107970 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107976:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107979:	89 c1                	mov    %eax,%ecx
8010797b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010797e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107981:	f6 c2 01             	test   $0x1,%dl
80107984:	0f 84 00 01 00 00    	je     80107a8a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010798a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010798d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107993:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107994:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107999:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079a0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079a7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079aa:	05 00 00 00 80       	add    $0x80000000,%eax
801079af:	83 fa 05             	cmp    $0x5,%edx
801079b2:	ba 00 00 00 00       	mov    $0x0,%edx
801079b7:	0f 45 c2             	cmovne %edx,%eax
}
801079ba:	c3                   	ret    
801079bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079bf:	90                   	nop

801079c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801079c0:	55                   	push   %ebp
801079c1:	89 e5                	mov    %esp,%ebp
801079c3:	57                   	push   %edi
801079c4:	56                   	push   %esi
801079c5:	53                   	push   %ebx
801079c6:	83 ec 0c             	sub    $0xc,%esp
801079c9:	8b 75 14             	mov    0x14(%ebp),%esi
801079cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801079cf:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801079d2:	85 f6                	test   %esi,%esi
801079d4:	75 51                	jne    80107a27 <copyout+0x67>
801079d6:	e9 a5 00 00 00       	jmp    80107a80 <copyout+0xc0>
801079db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079df:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801079e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801079e6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801079ec:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801079f2:	74 75                	je     80107a69 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801079f4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801079f6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801079f9:	29 c3                	sub    %eax,%ebx
801079fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a01:	39 f3                	cmp    %esi,%ebx
80107a03:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a06:	29 f8                	sub    %edi,%eax
80107a08:	83 ec 04             	sub    $0x4,%esp
80107a0b:	01 c1                	add    %eax,%ecx
80107a0d:	53                   	push   %ebx
80107a0e:	52                   	push   %edx
80107a0f:	51                   	push   %ecx
80107a10:	e8 2b d5 ff ff       	call   80104f40 <memmove>
    len -= n;
    buf += n;
80107a15:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a18:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a1e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a21:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a23:	29 de                	sub    %ebx,%esi
80107a25:	74 59                	je     80107a80 <copyout+0xc0>
  if(*pde & PTE_P){
80107a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a2a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a2c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a2e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a31:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a37:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a3a:	f6 c1 01             	test   $0x1,%cl
80107a3d:	0f 84 4e 00 00 00    	je     80107a91 <copyout.cold>
  return &pgtab[PTX(va)];
80107a43:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a45:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a4b:	c1 eb 0c             	shr    $0xc,%ebx
80107a4e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a54:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a5b:	89 d9                	mov    %ebx,%ecx
80107a5d:	83 e1 05             	and    $0x5,%ecx
80107a60:	83 f9 05             	cmp    $0x5,%ecx
80107a63:	0f 84 77 ff ff ff    	je     801079e0 <copyout+0x20>
  }
  return 0;
}
80107a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a71:	5b                   	pop    %ebx
80107a72:	5e                   	pop    %esi
80107a73:	5f                   	pop    %edi
80107a74:	5d                   	pop    %ebp
80107a75:	c3                   	ret    
80107a76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a7d:	8d 76 00             	lea    0x0(%esi),%esi
80107a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a83:	31 c0                	xor    %eax,%eax
}
80107a85:	5b                   	pop    %ebx
80107a86:	5e                   	pop    %esi
80107a87:	5f                   	pop    %edi
80107a88:	5d                   	pop    %ebp
80107a89:	c3                   	ret    

80107a8a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107a8a:	a1 00 00 00 00       	mov    0x0,%eax
80107a8f:	0f 0b                	ud2    

80107a91 <copyout.cold>:
80107a91:	a1 00 00 00 00       	mov    0x0,%eax
80107a96:	0f 0b                	ud2    
