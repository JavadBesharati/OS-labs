
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 50 7f 11 80       	mov    $0x80117f50,%esp

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
80100044:	bb 54 c5 10 80       	mov    $0x8010c554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 8a 10 80       	push   $0x80108a60
80100051:	68 20 c5 10 80       	push   $0x8010c520
80100056:	e8 e5 58 00 00       	call   80105940 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c 0c 11 80       	mov    $0x80110c1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c 0c 11 80 1c 	movl   $0x80110c1c,0x80110c6c
8010006a:	0c 11 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 0c 11 80 1c 	movl   $0x80110c1c,0x80110c70
80100074:	0c 11 80 
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
8010008b:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 8a 10 80       	push   $0x80108a67
80100097:	50                   	push   %eax
80100098:	e8 63 57 00 00       	call   80105800 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 0c 11 80       	mov    0x80110c70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 09 11 80    	cmp    $0x801109c0,%ebx
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
801000df:	68 20 c5 10 80       	push   $0x8010c520
801000e4:	e8 27 5a 00 00       	call   80105b10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 0c 11 80    	mov    0x80110c70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
80100120:	8b 1d 6c 0c 11 80    	mov    0x80110c6c,%ebx
80100126:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c 0c 11 80    	cmp    $0x80110c1c,%ebx
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
8010015d:	68 20 c5 10 80       	push   $0x8010c520
80100162:	e8 49 59 00 00       	call   80105ab0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 56 00 00       	call   80105840 <acquiresleep>
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
801001a1:	68 6e 8a 10 80       	push   $0x80108a6e
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
801001be:	e8 2d 57 00 00       	call   801058f0 <holdingsleep>
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
801001dc:	68 7f 8a 10 80       	push   $0x80108a7f
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
801001ff:	e8 ec 56 00 00       	call   801058f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 56 00 00       	call   801058a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010021b:	e8 f0 58 00 00       	call   80105b10 <acquire>
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
80100242:	a1 70 0c 11 80       	mov    0x80110c70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c 0c 11 80 	movl   $0x80110c1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 0c 11 80       	mov    0x80110c70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 0c 11 80    	mov    %ebx,0x80110c70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 c5 10 80 	movl   $0x8010c520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 58 00 00       	jmp    80105ab0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 86 8a 10 80       	push   $0x80108a86
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
80100299:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801002a0:	e8 6b 58 00 00       	call   80105b10 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002b5:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
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
801002c3:	68 20 0f 11 80       	push   $0x80110f20
801002c8:	68 00 0f 11 80       	push   $0x80110f00
801002cd:	e8 7e 45 00 00       	call   80104850 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 0f 11 80       	mov    0x80110f00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 3c 00 00       	call   80103ef0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 0f 11 80       	push   $0x80110f20
801002f6:	e8 b5 57 00 00       	call   80105ab0 <release>
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
8010031b:	89 15 00 0f 11 80    	mov    %edx,0x80110f00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 0e 11 80 	movsbl -0x7feef180(%edx),%ecx
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
80100347:	68 20 0f 11 80       	push   $0x80110f20
8010034c:	e8 5f 57 00 00       	call   80105ab0 <release>
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
8010036d:	a3 00 0f 11 80       	mov    %eax,0x80110f00
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
80100389:	c7 05 54 0f 11 80 00 	movl   $0x0,0x80110f54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 29 00 00       	call   80102d90 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 8d 8a 10 80       	push   $0x80108a8d
801003a7:	e8 44 03 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 3b 03 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 df 97 10 80 	movl   $0x801097df,(%esp)
801003bc:	e8 2f 03 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 55 00 00       	call   80105960 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 a1 8a 10 80       	push   $0x80108aa1
801003dd:	e8 0e 03 00 00       	call   801006f0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 0f 11 80 01 	movl   $0x1,0x80110f58
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
8010043f:	8b 0d 0c 0f 11 80    	mov    0x80110f0c,%ecx
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
801004a9:	8b 0d 0c 0f 11 80    	mov    0x80110f0c,%ecx
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
8010051d:	8b 0d 0c 0f 11 80    	mov    0x80110f0c,%ecx
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
80100575:	e8 f6 56 00 00       	call   80105c70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010057a:	b8 80 07 00 00       	mov    $0x780,%eax
8010057f:	83 c4 0c             	add    $0xc,%esp
80100582:	29 d8                	sub    %ebx,%eax
80100584:	01 c0                	add    %eax,%eax
80100586:	50                   	push   %eax
80100587:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
8010058e:	6a 00                	push   $0x0
80100590:	50                   	push   %eax
80100591:	e8 3a 56 00 00       	call   80105bd0 <memset>
  outb(CRTPORT+1, pos);
80100596:	88 5d e3             	mov    %bl,-0x1d(%ebp)
80100599:	8b 0d 0c 0f 11 80    	mov    0x80110f0c,%ecx
8010059f:	83 c4 10             	add    $0x10,%esp
801005a2:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005a6:	e9 07 ff ff ff       	jmp    801004b2 <cgaputc+0xb2>
    panic("pos under/overflow");
801005ab:	83 ec 0c             	sub    $0xc,%esp
801005ae:	68 a5 8a 10 80       	push   $0x80108aa5
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
801005d4:	c7 04 24 20 0f 11 80 	movl   $0x80110f20,(%esp)
801005db:	e8 30 55 00 00       	call   80105b10 <acquire>
  for(i = 0; i < n; i++)
801005e0:	83 c4 10             	add    $0x10,%esp
801005e3:	85 f6                	test   %esi,%esi
801005e5:	7e 37                	jle    8010061e <consolewrite+0x5e>
801005e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ea:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005ed:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
8010060a:	e8 71 6f 00 00       	call   80107580 <uartputc>
  cgaputc(c);
8010060f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100612:	e8 e9 fd ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
80100617:	83 c4 10             	add    $0x10,%esp
8010061a:	39 df                	cmp    %ebx,%edi
8010061c:	75 cf                	jne    801005ed <consolewrite+0x2d>
  release(&cons.lock);
8010061e:	83 ec 0c             	sub    $0xc,%esp
80100621:	68 20 0f 11 80       	push   $0x80110f20
80100626:	e8 85 54 00 00       	call   80105ab0 <release>
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
80100676:	0f b6 92 d0 8a 10 80 	movzbl -0x7fef7530(%edx),%edx
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
8010069f:	a1 58 0f 11 80       	mov    0x80110f58,%eax
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
801006b7:	e8 c4 6e 00 00       	call   80107580 <uartputc>
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
801006f9:	a1 54 0f 11 80       	mov    0x80110f54,%eax
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
801007a5:	bf b8 8a 10 80       	mov    $0x80108ab8,%edi
      for(; *s; s++)
801007aa:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801007ad:	b8 28 00 00 00       	mov    $0x28,%eax
801007b2:	89 fb                	mov    %edi,%ebx
  if(panicked){
801007b4:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
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
80100800:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
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
8010081a:	e8 61 6d 00 00       	call   80107580 <uartputc>
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
80100843:	68 20 0f 11 80       	push   $0x80110f20
80100848:	e8 c3 52 00 00       	call   80105b10 <acquire>
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	e9 b4 fe ff ff       	jmp    80100709 <cprintf+0x19>
  if(panicked){
80100855:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
8010085b:	85 c9                	test   %ecx,%ecx
8010085d:	75 71                	jne    801008d0 <cprintf+0x1e0>
    uartputc(c);
8010085f:	83 ec 0c             	sub    $0xc,%esp
80100862:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100865:	6a 25                	push   $0x25
80100867:	e8 14 6d 00 00       	call   80107580 <uartputc>
  cgaputc(c);
8010086c:	b8 25 00 00 00       	mov    $0x25,%eax
80100871:	e8 8a fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100876:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	85 d2                	test   %edx,%edx
80100881:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100884:	0f 84 8e 00 00 00    	je     80100918 <cprintf+0x228>
8010088a:	fa                   	cli    
    for(;;)
8010088b:	eb fe                	jmp    8010088b <cprintf+0x19b>
8010088d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100890:	a1 58 0f 11 80       	mov    0x80110f58,%eax
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
801008a8:	e8 d3 6c 00 00       	call   80107580 <uartputc>
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
801008f3:	e8 88 6c 00 00       	call   80107580 <uartputc>
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
8010091f:	e8 5c 6c 00 00       	call   80107580 <uartputc>
  cgaputc(c);
80100924:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100927:	e8 d4 fa ff ff       	call   80100400 <cgaputc>
}
8010092c:	83 c4 10             	add    $0x10,%esp
8010092f:	e9 37 fe ff ff       	jmp    8010076b <cprintf+0x7b>
    release(&cons.lock);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	68 20 0f 11 80       	push   $0x80110f20
8010093c:	e8 6f 51 00 00       	call   80105ab0 <release>
80100941:	83 c4 10             	add    $0x10,%esp
}
80100944:	e9 38 fe ff ff       	jmp    80100781 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100949:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010094c:	e9 1a fe ff ff       	jmp    8010076b <cprintf+0x7b>
    panic("null fmt");
80100951:	83 ec 0c             	sub    $0xc,%esp
80100954:	68 bf 8a 10 80       	push   $0x80108abf
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
80100a2e:	a1 08 0f 11 80       	mov    0x80110f08,%eax
  if(panicked){
80100a33:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
      if(input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100a39:	83 e8 01             	sub    $0x1,%eax
80100a3c:	89 c2                	mov    %eax,%edx
        input.e--;
80100a3e:	a3 08 0f 11 80       	mov    %eax,0x80110f08
      if(input.buf[(input.e - 1) % INPUT_BUF] == ' '){
80100a43:	83 e2 7f             	and    $0x7f,%edx
80100a46:	80 ba 80 0e 11 80 20 	cmpb   $0x20,-0x7feef180(%edx)
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
80100a65:	e8 16 6b 00 00       	call   80107580 <uartputc>
80100a6a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a71:	e8 0a 6b 00 00       	call   80107580 <uartputc>
80100a76:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a7d:	e8 fe 6a 00 00       	call   80107580 <uartputc>
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
80100add:	e8 9e 6a 00 00       	call   80107580 <uartputc>
80100ae2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae9:	e8 92 6a 00 00       	call   80107580 <uartputc>
80100aee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100af5:	e8 86 6a 00 00       	call   80107580 <uartputc>
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
80100b6d:	01 15 0c 0f 11 80    	add    %edx,0x80110f0c
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
80100bd6:	8b 1d 08 0f 11 80    	mov    0x80110f08,%ebx
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
80100c01:	01 15 0c 0f 11 80    	add    %edx,0x80110f0c
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
80100c3e:	68 20 0f 11 80       	push   $0x80110f20
80100c43:	e8 c8 4e 00 00       	call   80105b10 <acquire>
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
80100c72:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100c77:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
80100c7d:	74 cc                	je     80100c4b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100c7f:	83 e8 01             	sub    $0x1,%eax
80100c82:	89 c2                	mov    %eax,%edx
80100c84:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100c87:	80 ba 80 0e 11 80 0a 	cmpb   $0xa,-0x7feef180(%edx)
80100c8e:	74 bb                	je     80100c4b <consoleintr+0x1b>
  if(panicked){
80100c90:	8b 15 58 0f 11 80    	mov    0x80110f58,%edx
        input.e--;
80100c96:	a3 08 0f 11 80       	mov    %eax,0x80110f08
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
80100cb9:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100cbe:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
80100cc4:	74 85                	je     80100c4b <consoleintr+0x1b>
        input.e--;
80100cc6:	83 e8 01             	sub    $0x1,%eax
80100cc9:	a3 08 0f 11 80       	mov    %eax,0x80110f08
  if(panicked){
80100cce:	a1 58 0f 11 80       	mov    0x80110f58,%eax
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
80100d13:	68 20 0f 11 80       	push   $0x80110f20
80100d18:	e8 93 4d 00 00       	call   80105ab0 <release>
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
80100d3f:	e8 3c 68 00 00       	call   80107580 <uartputc>
80100d44:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100d4b:	e8 30 68 00 00       	call   80107580 <uartputc>
80100d50:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100d57:	e8 24 68 00 00       	call   80107580 <uartputc>
  cgaputc(c);
80100d5c:	b8 00 01 00 00       	mov    $0x100,%eax
80100d61:	e8 9a f6 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100d66:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100d6b:	83 c4 10             	add    $0x10,%esp
80100d6e:	3b 05 04 0f 11 80    	cmp    0x80110f04,%eax
80100d74:	0f 85 05 ff ff ff    	jne    80100c7f <consoleintr+0x4f>
80100d7a:	e9 cc fe ff ff       	jmp    80100c4b <consoleintr+0x1b>
80100d7f:	90                   	nop
      if(c != 0 && input.e - input.r < INPUT_BUF){
80100d80:	85 c0                	test   %eax,%eax
80100d82:	0f 84 c3 fe ff ff    	je     80100c4b <consoleintr+0x1b>
80100d88:	8b 0d 08 0f 11 80    	mov    0x80110f08,%ecx
80100d8e:	89 ca                	mov    %ecx,%edx
80100d90:	2b 15 00 0f 11 80    	sub    0x80110f00,%edx
80100d96:	83 fa 7f             	cmp    $0x7f,%edx
80100d99:	0f 87 ac fe ff ff    	ja     80100c4b <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d9f:	89 ca                	mov    %ecx,%edx
80100da1:	8d 59 01             	lea    0x1(%ecx),%ebx
  if(panicked){
80100da4:	8b 0d 58 0f 11 80    	mov    0x80110f58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100daa:	89 1d 08 0f 11 80    	mov    %ebx,0x80110f08
80100db0:	83 e2 7f             	and    $0x7f,%edx
        c = (c == '\r') ? '\n' : c;
80100db3:	83 f8 0d             	cmp    $0xd,%eax
80100db6:	0f 84 e0 00 00 00    	je     80100e9c <consoleintr+0x26c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100dbc:	88 82 80 0e 11 80    	mov    %al,-0x7feef180(%edx)
  if(panicked){
80100dc2:	85 c9                	test   %ecx,%ecx
80100dc4:	0f 85 bc 00 00 00    	jne    80100e86 <consoleintr+0x256>
  if(c == BACKSPACE){
80100dca:	3d 00 01 00 00       	cmp    $0x100,%eax
80100dcf:	0f 85 f3 00 00 00    	jne    80100ec8 <consoleintr+0x298>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100dd5:	83 ec 0c             	sub    $0xc,%esp
80100dd8:	6a 08                	push   $0x8
80100dda:	e8 a1 67 00 00       	call   80107580 <uartputc>
80100ddf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100de6:	e8 95 67 00 00       	call   80107580 <uartputc>
80100deb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100df2:	e8 89 67 00 00       	call   80107580 <uartputc>
  cgaputc(c);
80100df7:	b8 00 01 00 00       	mov    $0x100,%eax
80100dfc:	e8 ff f5 ff ff       	call   80100400 <cgaputc>
80100e01:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e04:	a1 00 0f 11 80       	mov    0x80110f00,%eax
80100e09:	83 e8 80             	sub    $0xffffff80,%eax
80100e0c:	39 05 08 0f 11 80    	cmp    %eax,0x80110f08
80100e12:	0f 85 33 fe ff ff    	jne    80100c4b <consoleintr+0x1b>
          wakeup(&input.r);
80100e18:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100e1b:	a3 04 0f 11 80       	mov    %eax,0x80110f04
          wakeup(&input.r);
80100e20:	68 00 0f 11 80       	push   $0x80110f00
80100e25:	e8 e6 3a 00 00       	call   80104910 <wakeup>
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
80100e57:	e8 24 67 00 00       	call   80107580 <uartputc>
80100e5c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100e63:	e8 18 67 00 00       	call   80107580 <uartputc>
80100e68:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100e6f:	e8 0c 67 00 00       	call   80107580 <uartputc>
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
80100e97:	e9 54 3b 00 00       	jmp    801049f0 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100e9c:	c6 82 80 0e 11 80 0a 	movb   $0xa,-0x7feef180(%edx)
  if(panicked){
80100ea3:	85 c9                	test   %ecx,%ecx
80100ea5:	75 df                	jne    80100e86 <consoleintr+0x256>
    uartputc(c);
80100ea7:	83 ec 0c             	sub    $0xc,%esp
80100eaa:	6a 0a                	push   $0xa
80100eac:	e8 cf 66 00 00       	call   80107580 <uartputc>
  cgaputc(c);
80100eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
80100eb6:	e8 45 f5 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100ebb:	a1 08 0f 11 80       	mov    0x80110f08,%eax
80100ec0:	83 c4 10             	add    $0x10,%esp
80100ec3:	e9 50 ff ff ff       	jmp    80100e18 <consoleintr+0x1e8>
    uartputc(c);
80100ec8:	83 ec 0c             	sub    $0xc,%esp
80100ecb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100ece:	50                   	push   %eax
80100ecf:	e8 ac 66 00 00       	call   80107580 <uartputc>
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
80100ef0:	a1 08 0f 11 80       	mov    0x80110f08,%eax
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
80100f06:	68 c8 8a 10 80       	push   $0x80108ac8
80100f0b:	68 20 0f 11 80       	push   $0x80110f20
80100f10:	e8 2b 4a 00 00       	call   80105940 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f15:	58                   	pop    %eax
80100f16:	5a                   	pop    %edx
80100f17:	6a 00                	push   $0x0
80100f19:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f1b:	c7 05 0c 19 11 80 c0 	movl   $0x801005c0,0x8011190c
80100f22:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100f25:	c7 05 08 19 11 80 80 	movl   $0x80100280,0x80111908
80100f2c:	02 10 80 
  cons.locking = 1;
80100f2f:	c7 05 54 0f 11 80 01 	movl   $0x1,0x80110f54
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
80100f5c:	e8 8f 2f 00 00       	call   80103ef0 <myproc>
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
80100fd4:	e8 37 77 00 00       	call   80108710 <setupkvm>
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
80101043:	e8 e8 74 00 00       	call   80108530 <allocuvm>
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
80101079:	e8 c2 73 00 00       	call   80108440 <loaduvm>
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
801010bb:	e8 d0 75 00 00       	call   80108690 <freevm>
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
80101102:	e8 29 74 00 00       	call   80108530 <allocuvm>
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
80101123:	e8 88 76 00 00       	call   801087b0 <clearpteu>
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
80101173:	e8 58 4c 00 00       	call   80105dd0 <strlen>
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
80101187:	e8 44 4c 00 00       	call   80105dd0 <strlen>
8010118c:	83 c0 01             	add    $0x1,%eax
8010118f:	50                   	push   %eax
80101190:	8b 45 0c             	mov    0xc(%ebp),%eax
80101193:	ff 34 b8             	push   (%eax,%edi,4)
80101196:	53                   	push   %ebx
80101197:	56                   	push   %esi
80101198:	e8 e3 77 00 00       	call   80108980 <copyout>
8010119d:	83 c4 20             	add    $0x20,%esp
801011a0:	85 c0                	test   %eax,%eax
801011a2:	79 ac                	jns    80101150 <exec+0x200>
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011a8:	83 ec 0c             	sub    $0xc,%esp
801011ab:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011b1:	e8 da 74 00 00       	call   80108690 <freevm>
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
80101203:	e8 78 77 00 00       	call   80108980 <copyout>
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
80101241:	e8 4a 4b 00 00       	call   80105d90 <safestrcpy>
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
8010126d:	e8 3e 70 00 00       	call   801082b0 <switchuvm>
  freevm(oldpgdir);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 16 74 00 00       	call   80108690 <freevm>
  return 0;
8010127a:	83 c4 10             	add    $0x10,%esp
8010127d:	31 c0                	xor    %eax,%eax
8010127f:	e9 38 fd ff ff       	jmp    80100fbc <exec+0x6c>
    end_op();
80101284:	e8 e7 1f 00 00       	call   80103270 <end_op>
    cprintf("exec: fail\n");
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	68 e1 8a 10 80       	push   $0x80108ae1
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
801012b6:	68 ed 8a 10 80       	push   $0x80108aed
801012bb:	68 60 0f 11 80       	push   $0x80110f60
801012c0:	e8 7b 46 00 00       	call   80105940 <initlock>
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
801012d4:	bb 94 0f 11 80       	mov    $0x80110f94,%ebx
{
801012d9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
801012dc:	68 60 0f 11 80       	push   $0x80110f60
801012e1:	e8 2a 48 00 00       	call   80105b10 <acquire>
801012e6:	83 c4 10             	add    $0x10,%esp
801012e9:	eb 10                	jmp    801012fb <filealloc+0x2b>
801012eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801012ef:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801012f0:	83 c3 18             	add    $0x18,%ebx
801012f3:	81 fb f4 18 11 80    	cmp    $0x801118f4,%ebx
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
8010130c:	68 60 0f 11 80       	push   $0x80110f60
80101311:	e8 9a 47 00 00       	call   80105ab0 <release>
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
80101325:	68 60 0f 11 80       	push   $0x80110f60
8010132a:	e8 81 47 00 00       	call   80105ab0 <release>
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
8010134a:	68 60 0f 11 80       	push   $0x80110f60
8010134f:	e8 bc 47 00 00       	call   80105b10 <acquire>
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
80101367:	68 60 0f 11 80       	push   $0x80110f60
8010136c:	e8 3f 47 00 00       	call   80105ab0 <release>
  return f;
}
80101371:	89 d8                	mov    %ebx,%eax
80101373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101376:	c9                   	leave  
80101377:	c3                   	ret    
    panic("filedup");
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	68 f4 8a 10 80       	push   $0x80108af4
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
8010139c:	68 60 0f 11 80       	push   $0x80110f60
801013a1:	e8 6a 47 00 00       	call   80105b10 <acquire>
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
801013d4:	68 60 0f 11 80       	push   $0x80110f60
  ff = *f;
801013d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
801013dc:	e8 cf 46 00 00       	call   80105ab0 <release>

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
80101400:	c7 45 08 60 0f 11 80 	movl   $0x80110f60,0x8(%ebp)
}
80101407:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010140e:	e9 9d 46 00 00       	jmp    80105ab0 <release>
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
8010145c:	68 fc 8a 10 80       	push   $0x80108afc
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
80101542:	68 06 8b 10 80       	push   $0x80108b06
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
80101617:	68 0f 8b 10 80       	push   $0x80108b0f
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
80101651:	68 15 8b 10 80       	push   $0x80108b15
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
80101668:	03 05 cc 35 11 80    	add    0x801135cc,%eax
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
801016c7:	68 1f 8b 10 80       	push   $0x80108b1f
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
801016e9:	8b 0d b4 35 11 80    	mov    0x801135b4,%ecx
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
8010170c:	03 05 cc 35 11 80    	add    0x801135cc,%eax
80101712:	50                   	push   %eax
80101713:	ff 75 d8             	push   -0x28(%ebp)
80101716:	e8 b5 e9 ff ff       	call   801000d0 <bread>
8010171b:	83 c4 10             	add    $0x10,%esp
8010171e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101721:	a1 b4 35 11 80       	mov    0x801135b4,%eax
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
80101779:	39 05 b4 35 11 80    	cmp    %eax,0x801135b4
8010177f:	77 80                	ja     80101701 <balloc+0x21>
  panic("balloc: out of blocks");
80101781:	83 ec 0c             	sub    $0xc,%esp
80101784:	68 32 8b 10 80       	push   $0x80108b32
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
801017c5:	e8 06 44 00 00       	call   80105bd0 <memset>
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
801017fa:	bb 94 19 11 80       	mov    $0x80111994,%ebx
{
801017ff:	83 ec 28             	sub    $0x28,%esp
80101802:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101805:	68 60 19 11 80       	push   $0x80111960
8010180a:	e8 01 43 00 00       	call   80105b10 <acquire>
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
8010182a:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
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
80101849:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
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
80101872:	68 60 19 11 80       	push   $0x80111960
80101877:	e8 34 42 00 00       	call   80105ab0 <release>

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
8010189d:	68 60 19 11 80       	push   $0x80111960
      ip->ref++;
801018a2:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801018a5:	e8 06 42 00 00       	call   80105ab0 <release>
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
801018bd:	81 fb b4 35 11 80    	cmp    $0x801135b4,%ebx
801018c3:	73 10                	jae    801018d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018c5:	8b 43 08             	mov    0x8(%ebx),%eax
801018c8:	85 c0                	test   %eax,%eax
801018ca:	0f 8f 50 ff ff ff    	jg     80101820 <iget+0x30>
801018d0:	e9 68 ff ff ff       	jmp    8010183d <iget+0x4d>
    panic("iget: no inodes");
801018d5:	83 ec 0c             	sub    $0xc,%esp
801018d8:	68 48 8b 10 80       	push   $0x80108b48
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
801019b5:	68 58 8b 10 80       	push   $0x80108b58
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
801019e1:	e8 8a 42 00 00       	call   80105c70 <memmove>
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
80101a04:	bb a0 19 11 80       	mov    $0x801119a0,%ebx
80101a09:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a0c:	68 6b 8b 10 80       	push   $0x80108b6b
80101a11:	68 60 19 11 80       	push   $0x80111960
80101a16:	e8 25 3f 00 00       	call   80105940 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a1b:	83 c4 10             	add    $0x10,%esp
80101a1e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a20:	83 ec 08             	sub    $0x8,%esp
80101a23:	68 72 8b 10 80       	push   $0x80108b72
80101a28:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a29:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a2f:	e8 cc 3d 00 00       	call   80105800 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	81 fb c0 35 11 80    	cmp    $0x801135c0,%ebx
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
80101a57:	68 b4 35 11 80       	push   $0x801135b4
80101a5c:	e8 0f 42 00 00       	call   80105c70 <memmove>
  brelse(bp);
80101a61:	89 1c 24             	mov    %ebx,(%esp)
80101a64:	e8 87 e7 ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101a69:	ff 35 cc 35 11 80    	push   0x801135cc
80101a6f:	ff 35 c8 35 11 80    	push   0x801135c8
80101a75:	ff 35 c4 35 11 80    	push   0x801135c4
80101a7b:	ff 35 c0 35 11 80    	push   0x801135c0
80101a81:	ff 35 bc 35 11 80    	push   0x801135bc
80101a87:	ff 35 b8 35 11 80    	push   0x801135b8
80101a8d:	ff 35 b4 35 11 80    	push   0x801135b4
80101a93:	68 d8 8b 10 80       	push   $0x80108bd8
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
80101abc:	83 3d bc 35 11 80 01 	cmpl   $0x1,0x801135bc
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
80101aef:	3b 3d bc 35 11 80    	cmp    0x801135bc,%edi
80101af5:	73 69                	jae    80101b60 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101af7:	89 f8                	mov    %edi,%eax
80101af9:	83 ec 08             	sub    $0x8,%esp
80101afc:	c1 e8 03             	shr    $0x3,%eax
80101aff:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101b2e:	e8 9d 40 00 00       	call   80105bd0 <memset>
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
80101b63:	68 78 8b 10 80       	push   $0x80108b78
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
80101b84:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101bd1:	e8 9a 40 00 00       	call   80105c70 <memmove>
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
80101bfa:	68 60 19 11 80       	push   $0x80111960
80101bff:	e8 0c 3f 00 00       	call   80105b10 <acquire>
  ip->ref++;
80101c04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c08:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101c0f:	e8 9c 3e 00 00       	call   80105ab0 <release>
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
80101c42:	e8 f9 3b 00 00       	call   80105840 <acquiresleep>
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
80101c69:	03 05 c8 35 11 80    	add    0x801135c8,%eax
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
80101cb8:	e8 b3 3f 00 00       	call   80105c70 <memmove>
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
80101cdd:	68 90 8b 10 80       	push   $0x80108b90
80101ce2:	e8 99 e6 ff ff       	call   80100380 <panic>
    panic("ilock");
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	68 8a 8b 10 80       	push   $0x80108b8a
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
80101d13:	e8 d8 3b 00 00       	call   801058f0 <holdingsleep>
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
80101d2f:	e9 6c 3b 00 00       	jmp    801058a0 <releasesleep>
    panic("iunlock");
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 9f 8b 10 80       	push   $0x80108b9f
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
80101d60:	e8 db 3a 00 00       	call   80105840 <acquiresleep>
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
80101d7a:	e8 21 3b 00 00       	call   801058a0 <releasesleep>
  acquire(&icache.lock);
80101d7f:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101d86:	e8 85 3d 00 00       	call   80105b10 <acquire>
  ip->ref--;
80101d8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101d8f:	83 c4 10             	add    $0x10,%esp
80101d92:	c7 45 08 60 19 11 80 	movl   $0x80111960,0x8(%ebp)
}
80101d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9c:	5b                   	pop    %ebx
80101d9d:	5e                   	pop    %esi
80101d9e:	5f                   	pop    %edi
80101d9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101da0:	e9 0b 3d 00 00       	jmp    80105ab0 <release>
80101da5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	68 60 19 11 80       	push   $0x80111960
80101db0:	e8 5b 3d 00 00       	call   80105b10 <acquire>
    int r = ip->ref;
80101db5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101db8:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
80101dbf:	e8 ec 3c 00 00       	call   80105ab0 <release>
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
80101ec3:	e8 28 3a 00 00       	call   801058f0 <holdingsleep>
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	85 c0                	test   %eax,%eax
80101ecd:	74 21                	je     80101ef0 <iunlockput+0x40>
80101ecf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ed2:	85 c0                	test   %eax,%eax
80101ed4:	7e 1a                	jle    80101ef0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ed6:	83 ec 0c             	sub    $0xc,%esp
80101ed9:	56                   	push   %esi
80101eda:	e8 c1 39 00 00       	call   801058a0 <releasesleep>
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
80101ef3:	68 9f 8b 10 80       	push   $0x80108b9f
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
80101fd7:	e8 94 3c 00 00       	call   80105c70 <memmove>
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
8010200a:	8b 04 c5 00 19 11 80 	mov    -0x7feee700(,%eax,8),%eax
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
801020d3:	e8 98 3b 00 00       	call   80105c70 <memmove>
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
8010211a:	8b 04 c5 04 19 11 80 	mov    -0x7feee6fc(,%eax,8),%eax
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
8010216e:	e8 6d 3b 00 00       	call   80105ce0 <strncmp>
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
801021cd:	e8 0e 3b 00 00       	call   80105ce0 <strncmp>
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
80102212:	68 b9 8b 10 80       	push   $0x80108bb9
80102217:	e8 64 e1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010221c:	83 ec 0c             	sub    $0xc,%esp
8010221f:	68 a7 8b 10 80       	push   $0x80108ba7
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
8010224a:	e8 a1 1c 00 00       	call   80103ef0 <myproc>
  acquire(&icache.lock);
8010224f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102252:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102255:	68 60 19 11 80       	push   $0x80111960
8010225a:	e8 b1 38 00 00       	call   80105b10 <acquire>
  ip->ref++;
8010225f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102263:	c7 04 24 60 19 11 80 	movl   $0x80111960,(%esp)
8010226a:	e8 41 38 00 00       	call   80105ab0 <release>
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
801022c7:	e8 a4 39 00 00       	call   80105c70 <memmove>
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
8010232c:	e8 bf 35 00 00       	call   801058f0 <holdingsleep>
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
8010234e:	e8 4d 35 00 00       	call   801058a0 <releasesleep>
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
8010237b:	e8 f0 38 00 00       	call   80105c70 <memmove>
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
801023cb:	e8 20 35 00 00       	call   801058f0 <holdingsleep>
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	85 c0                	test   %eax,%eax
801023d5:	0f 84 91 00 00 00    	je     8010246c <namex+0x23c>
801023db:	8b 46 08             	mov    0x8(%esi),%eax
801023de:	85 c0                	test   %eax,%eax
801023e0:	0f 8e 86 00 00 00    	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
801023e6:	83 ec 0c             	sub    $0xc,%esp
801023e9:	53                   	push   %ebx
801023ea:	e8 b1 34 00 00       	call   801058a0 <releasesleep>
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
8010240d:	e8 de 34 00 00       	call   801058f0 <holdingsleep>
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
80102430:	e8 bb 34 00 00       	call   801058f0 <holdingsleep>
80102435:	83 c4 10             	add    $0x10,%esp
80102438:	85 c0                	test   %eax,%eax
8010243a:	74 30                	je     8010246c <namex+0x23c>
8010243c:	8b 7e 08             	mov    0x8(%esi),%edi
8010243f:	85 ff                	test   %edi,%edi
80102441:	7e 29                	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
80102443:	83 ec 0c             	sub    $0xc,%esp
80102446:	53                   	push   %ebx
80102447:	e8 54 34 00 00       	call   801058a0 <releasesleep>
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
8010246f:	68 9f 8b 10 80       	push   $0x80108b9f
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
801024dd:	e8 4e 38 00 00       	call   80105d30 <strncpy>
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
8010251b:	68 c8 8b 10 80       	push   $0x80108bc8
80102520:	e8 5b de ff ff       	call   80100380 <panic>
    panic("dirlink");
80102525:	83 ec 0c             	sub    $0xc,%esp
80102528:	68 5e 94 10 80       	push   $0x8010945e
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
8010263b:	68 34 8c 10 80       	push   $0x80108c34
80102640:	e8 3b dd ff ff       	call   80100380 <panic>
    panic("idestart");
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	68 2b 8c 10 80       	push   $0x80108c2b
8010264d:	e8 2e dd ff ff       	call   80100380 <panic>
80102652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102660 <ideinit>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102666:	68 46 8c 10 80       	push   $0x80108c46
8010266b:	68 00 36 11 80       	push   $0x80113600
80102670:	e8 cb 32 00 00       	call   80105940 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102675:	58                   	pop    %eax
80102676:	a1 84 37 11 80       	mov    0x80113784,%eax
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
801026ba:	c7 05 e0 35 11 80 01 	movl   $0x1,0x801135e0
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
801026e9:	68 00 36 11 80       	push   $0x80113600
801026ee:	e8 1d 34 00 00       	call   80105b10 <acquire>

  if((b = idequeue) == 0){
801026f3:	8b 1d e4 35 11 80    	mov    0x801135e4,%ebx
801026f9:	83 c4 10             	add    $0x10,%esp
801026fc:	85 db                	test   %ebx,%ebx
801026fe:	74 63                	je     80102763 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102700:	8b 43 58             	mov    0x58(%ebx),%eax
80102703:	a3 e4 35 11 80       	mov    %eax,0x801135e4

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
8010274d:	e8 be 21 00 00       	call   80104910 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102752:	a1 e4 35 11 80       	mov    0x801135e4,%eax
80102757:	83 c4 10             	add    $0x10,%esp
8010275a:	85 c0                	test   %eax,%eax
8010275c:	74 05                	je     80102763 <ideintr+0x83>
    idestart(idequeue);
8010275e:	e8 1d fe ff ff       	call   80102580 <idestart>
    release(&idelock);
80102763:	83 ec 0c             	sub    $0xc,%esp
80102766:	68 00 36 11 80       	push   $0x80113600
8010276b:	e8 40 33 00 00       	call   80105ab0 <release>

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
8010278e:	e8 5d 31 00 00       	call   801058f0 <holdingsleep>
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
801027b3:	a1 e0 35 11 80       	mov    0x801135e0,%eax
801027b8:	85 c0                	test   %eax,%eax
801027ba:	0f 84 87 00 00 00    	je     80102847 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027c0:	83 ec 0c             	sub    $0xc,%esp
801027c3:	68 00 36 11 80       	push   $0x80113600
801027c8:	e8 43 33 00 00       	call   80105b10 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027cd:	a1 e4 35 11 80       	mov    0x801135e4,%eax
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
801027ee:	39 1d e4 35 11 80    	cmp    %ebx,0x801135e4
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
80102803:	68 00 36 11 80       	push   $0x80113600
80102808:	53                   	push   %ebx
80102809:	e8 42 20 00 00       	call   80104850 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010280e:	8b 03                	mov    (%ebx),%eax
80102810:	83 c4 10             	add    $0x10,%esp
80102813:	83 e0 06             	and    $0x6,%eax
80102816:	83 f8 02             	cmp    $0x2,%eax
80102819:	75 e5                	jne    80102800 <iderw+0x80>
  }


  release(&idelock);
8010281b:	c7 45 08 00 36 11 80 	movl   $0x80113600,0x8(%ebp)
}
80102822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102825:	c9                   	leave  
  release(&idelock);
80102826:	e9 85 32 00 00       	jmp    80105ab0 <release>
8010282b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    idestart(b);
80102830:	89 d8                	mov    %ebx,%eax
80102832:	e8 49 fd ff ff       	call   80102580 <idestart>
80102837:	eb bd                	jmp    801027f6 <iderw+0x76>
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102840:	ba e4 35 11 80       	mov    $0x801135e4,%edx
80102845:	eb a5                	jmp    801027ec <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102847:	83 ec 0c             	sub    $0xc,%esp
8010284a:	68 75 8c 10 80       	push   $0x80108c75
8010284f:	e8 2c db ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102854:	83 ec 0c             	sub    $0xc,%esp
80102857:	68 60 8c 10 80       	push   $0x80108c60
8010285c:	e8 1f db ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102861:	83 ec 0c             	sub    $0xc,%esp
80102864:	68 4a 8c 10 80       	push   $0x80108c4a
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
80102871:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102878:	00 c0 fe 
{
8010287b:	89 e5                	mov    %esp,%ebp
8010287d:	56                   	push   %esi
8010287e:	53                   	push   %ebx
  ioapic->reg = reg;
8010287f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102886:	00 00 00 
  return ioapic->data;
80102889:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010288f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102892:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102898:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010289e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
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
801028ba:	68 94 8c 10 80       	push   $0x80108c94
801028bf:	e8 2c de ff ff       	call   801006f0 <cprintf>
  ioapic->reg = reg;
801028c4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
801028e4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
801028fe:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102921:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102935:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010293b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010293e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102941:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102944:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102946:	a1 34 36 11 80       	mov    0x80113634,%eax
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
80102972:	81 fb 50 7f 11 80    	cmp    $0x80117f50,%ebx
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
80102992:	e8 39 32 00 00       	call   80105bd0 <memset>

  if(kmem.use_lock)
80102997:	8b 15 74 36 11 80    	mov    0x80113674,%edx
8010299d:	83 c4 10             	add    $0x10,%esp
801029a0:	85 d2                	test   %edx,%edx
801029a2:	75 1c                	jne    801029c0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029a4:	a1 78 36 11 80       	mov    0x80113678,%eax
801029a9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029ab:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801029b0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
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
801029c3:	68 40 36 11 80       	push   $0x80113640
801029c8:	e8 43 31 00 00       	call   80105b10 <acquire>
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	eb d2                	jmp    801029a4 <kfree+0x44>
801029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029d8:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801029df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e2:	c9                   	leave  
    release(&kmem.lock);
801029e3:	e9 c8 30 00 00       	jmp    80105ab0 <release>
    panic("kfree");
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	68 c6 8c 10 80       	push   $0x80108cc6
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
80102a94:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
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
80102abb:	68 cc 8c 10 80       	push   $0x80108ccc
80102ac0:	68 40 36 11 80       	push   $0x80113640
80102ac5:	e8 76 2e 00 00       	call   80105940 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102aca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102acd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102ad0:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
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
80102b20:	a1 74 36 11 80       	mov    0x80113674,%eax
80102b25:	85 c0                	test   %eax,%eax
80102b27:	75 1f                	jne    80102b48 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b29:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102b2e:	85 c0                	test   %eax,%eax
80102b30:	74 0e                	je     80102b40 <kalloc+0x20>
    kmem.freelist = r->next;
80102b32:	8b 10                	mov    (%eax),%edx
80102b34:	89 15 78 36 11 80    	mov    %edx,0x80113678
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
80102b4e:	68 40 36 11 80       	push   $0x80113640
80102b53:	e8 b8 2f 00 00       	call   80105b10 <acquire>
  r = kmem.freelist;
80102b58:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(kmem.use_lock)
80102b5d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
  if(r)
80102b63:	83 c4 10             	add    $0x10,%esp
80102b66:	85 c0                	test   %eax,%eax
80102b68:	74 08                	je     80102b72 <kalloc+0x52>
    kmem.freelist = r->next;
80102b6a:	8b 08                	mov    (%eax),%ecx
80102b6c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102b72:	85 d2                	test   %edx,%edx
80102b74:	74 16                	je     80102b8c <kalloc+0x6c>
    release(&kmem.lock);
80102b76:	83 ec 0c             	sub    $0xc,%esp
80102b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b7c:	68 40 36 11 80       	push   $0x80113640
80102b81:	e8 2a 2f 00 00       	call   80105ab0 <release>
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
80102ba8:	8b 1d 7c 36 11 80    	mov    0x8011367c,%ebx
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
80102bcb:	0f b6 91 00 8e 10 80 	movzbl -0x7fef7200(%ecx),%edx
  shift ^= togglecode[data];
80102bd2:	0f b6 81 00 8d 10 80 	movzbl -0x7fef7300(%ecx),%eax
  shift |= shiftcode[data];
80102bd9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102bdb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bdd:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
80102bdf:	89 15 7c 36 11 80    	mov    %edx,0x8011367c
  c = charcode[shift & (CTL | SHIFT)][data];
80102be5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102be8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
80102beb:	8b 04 85 e0 8c 10 80 	mov    -0x7fef7320(,%eax,4),%eax
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
80102c15:	89 1d 7c 36 11 80    	mov    %ebx,0x8011367c
}
80102c1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c1e:	c9                   	leave  
80102c1f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102c20:	83 e0 7f             	and    $0x7f,%eax
80102c23:	85 d2                	test   %edx,%edx
80102c25:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102c28:	0f b6 81 00 8e 10 80 	movzbl -0x7fef7200(%ecx),%eax
80102c2f:	83 c8 40             	or     $0x40,%eax
80102c32:	0f b6 c0             	movzbl %al,%eax
80102c35:	f7 d0                	not    %eax
80102c37:	21 d8                	and    %ebx,%eax
}
80102c39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
80102c3c:	a3 7c 36 11 80       	mov    %eax,0x8011367c
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
80102c90:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102d90:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102db0:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102e1e:	a1 80 36 11 80       	mov    0x80113680,%eax
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
80102f97:	e8 84 2c 00 00       	call   80105c20 <memcmp>
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
80103060:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
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
80103080:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103085:	83 ec 08             	sub    $0x8,%esp
80103088:	01 f8                	add    %edi,%eax
8010308a:	83 c0 01             	add    $0x1,%eax
8010308d:	50                   	push   %eax
8010308e:	ff 35 e4 36 11 80    	push   0x801136e4
80103094:	e8 37 d0 ff ff       	call   801000d0 <bread>
80103099:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010309b:	58                   	pop    %eax
8010309c:	5a                   	pop    %edx
8010309d:	ff 34 bd ec 36 11 80 	push   -0x7feec914(,%edi,4)
801030a4:	ff 35 e4 36 11 80    	push   0x801136e4
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
801030c4:	e8 a7 2b 00 00       	call   80105c70 <memmove>
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
801030e4:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
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
80103107:	ff 35 d4 36 11 80    	push   0x801136d4
8010310d:	ff 35 e4 36 11 80    	push   0x801136e4
80103113:	e8 b8 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103118:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010311b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010311d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80103122:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103125:	85 c0                	test   %eax,%eax
80103127:	7e 19                	jle    80103142 <write_head+0x42>
80103129:	31 d2                	xor    %edx,%edx
8010312b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010312f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103130:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
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
8010316a:	68 00 8f 10 80       	push   $0x80108f00
8010316f:	68 a0 36 11 80       	push   $0x801136a0
80103174:	e8 c7 27 00 00       	call   80105940 <initlock>
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
80103189:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
8010318f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103192:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80103197:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
8010319d:	5a                   	pop    %edx
8010319e:	50                   	push   %eax
8010319f:	53                   	push   %ebx
801031a0:	e8 2b cf ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031a5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031a8:	8b 58 5c             	mov    0x5c(%eax),%ebx
801031ab:	89 1d e8 36 11 80    	mov    %ebx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
801031b1:	85 db                	test   %ebx,%ebx
801031b3:	7e 1d                	jle    801031d2 <initlog+0x72>
801031b5:	31 d2                	xor    %edx,%edx
801031b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031be:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
801031c0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801031c4:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
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
801031e0:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
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
80103206:	68 a0 36 11 80       	push   $0x801136a0
8010320b:	e8 00 29 00 00       	call   80105b10 <acquire>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	eb 18                	jmp    8010322d <begin_op+0x2d>
80103215:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103218:	83 ec 08             	sub    $0x8,%esp
8010321b:	68 a0 36 11 80       	push   $0x801136a0
80103220:	68 a0 36 11 80       	push   $0x801136a0
80103225:	e8 26 16 00 00       	call   80104850 <sleep>
8010322a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010322d:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80103232:	85 c0                	test   %eax,%eax
80103234:	75 e2                	jne    80103218 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103236:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010323b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80103252:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80103257:	68 a0 36 11 80       	push   $0x801136a0
8010325c:	e8 4f 28 00 00       	call   80105ab0 <release>
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
80103279:	68 a0 36 11 80       	push   $0x801136a0
8010327e:	e8 8d 28 00 00       	call   80105b10 <acquire>
  log.outstanding -= 1;
80103283:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80103288:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
8010328e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103291:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103294:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
8010329a:	85 f6                	test   %esi,%esi
8010329c:	0f 85 22 01 00 00    	jne    801033c4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032a2:	85 db                	test   %ebx,%ebx
801032a4:	0f 85 f6 00 00 00    	jne    801033a0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032aa:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
801032b1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801032b4:	83 ec 0c             	sub    $0xc,%esp
801032b7:	68 a0 36 11 80       	push   $0x801136a0
801032bc:	e8 ef 27 00 00       	call   80105ab0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032c1:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	85 c9                	test   %ecx,%ecx
801032cc:	7f 42                	jg     80103310 <end_op+0xa0>
    acquire(&log.lock);
801032ce:	83 ec 0c             	sub    $0xc,%esp
801032d1:	68 a0 36 11 80       	push   $0x801136a0
801032d6:	e8 35 28 00 00       	call   80105b10 <acquire>
    wakeup(&log);
801032db:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
801032e2:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
801032e9:	00 00 00 
    wakeup(&log);
801032ec:	e8 1f 16 00 00       	call   80104910 <wakeup>
    release(&log.lock);
801032f1:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
801032f8:	e8 b3 27 00 00       	call   80105ab0 <release>
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
80103310:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80103315:	83 ec 08             	sub    $0x8,%esp
80103318:	01 d8                	add    %ebx,%eax
8010331a:	83 c0 01             	add    $0x1,%eax
8010331d:	50                   	push   %eax
8010331e:	ff 35 e4 36 11 80    	push   0x801136e4
80103324:	e8 a7 cd ff ff       	call   801000d0 <bread>
80103329:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010332b:	58                   	pop    %eax
8010332c:	5a                   	pop    %edx
8010332d:	ff 34 9d ec 36 11 80 	push   -0x7feec914(,%ebx,4)
80103334:	ff 35 e4 36 11 80    	push   0x801136e4
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
80103354:	e8 17 29 00 00       	call   80105c70 <memmove>
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
80103374:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
8010337a:	7c 94                	jl     80103310 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010337c:	e8 7f fd ff ff       	call   80103100 <write_head>
    install_trans(); // Now install writes to home locations
80103381:	e8 da fc ff ff       	call   80103060 <install_trans>
    log.lh.n = 0;
80103386:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
8010338d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103390:	e8 6b fd ff ff       	call   80103100 <write_head>
80103395:	e9 34 ff ff ff       	jmp    801032ce <end_op+0x5e>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 a0 36 11 80       	push   $0x801136a0
801033a8:	e8 63 15 00 00       	call   80104910 <wakeup>
  release(&log.lock);
801033ad:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
801033b4:	e8 f7 26 00 00       	call   80105ab0 <release>
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
801033c7:	68 04 8f 10 80       	push   $0x80108f04
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
801033e7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
801033ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033f0:	83 fa 1d             	cmp    $0x1d,%edx
801033f3:	0f 8f 85 00 00 00    	jg     8010347e <log_write+0x9e>
801033f9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
801033fe:	83 e8 01             	sub    $0x1,%eax
80103401:	39 c2                	cmp    %eax,%edx
80103403:	7d 79                	jge    8010347e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103405:	a1 dc 36 11 80       	mov    0x801136dc,%eax
8010340a:	85 c0                	test   %eax,%eax
8010340c:	7e 7d                	jle    8010348b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010340e:	83 ec 0c             	sub    $0xc,%esp
80103411:	68 a0 36 11 80       	push   $0x801136a0
80103416:	e8 f5 26 00 00       	call   80105b10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010341b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
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
80103437:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
8010343e:	75 f0                	jne    80103430 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103440:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103447:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010344a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010344d:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80103454:	c9                   	leave  
  release(&log.lock);
80103455:	e9 56 26 00 00       	jmp    80105ab0 <release>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103460:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80103467:	83 c2 01             	add    $0x1,%edx
8010346a:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80103470:	eb d5                	jmp    80103447 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103472:	8b 43 08             	mov    0x8(%ebx),%eax
80103475:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
8010347a:	75 cb                	jne    80103447 <log_write+0x67>
8010347c:	eb e9                	jmp    80103467 <log_write+0x87>
    panic("too big a transaction");
8010347e:	83 ec 0c             	sub    $0xc,%esp
80103481:	68 13 8f 10 80       	push   $0x80108f13
80103486:	e8 f5 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	68 29 8f 10 80       	push   $0x80108f29
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
801034a7:	e8 24 0a 00 00       	call   80103ed0 <cpuid>
801034ac:	89 c3                	mov    %eax,%ebx
801034ae:	e8 1d 0a 00 00       	call   80103ed0 <cpuid>
801034b3:	83 ec 04             	sub    $0x4,%esp
801034b6:	53                   	push   %ebx
801034b7:	50                   	push   %eax
801034b8:	68 44 8f 10 80       	push   $0x80108f44
801034bd:	e8 2e d2 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
801034c2:	e8 e9 3c 00 00       	call   801071b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034c7:	e8 a4 09 00 00       	call   80103e70 <mycpu>
801034cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ce:	b8 01 00 00 00       	mov    $0x1,%eax
801034d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034da:	e8 71 0e 00 00       	call   80104350 <scheduler>
801034df:	90                   	nop

801034e0 <mpenter>:
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034e6:	e8 b5 4d 00 00       	call   801082a0 <switchkvm>
  seginit();
801034eb:	e8 20 4d 00 00       	call   80108210 <seginit>
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
80103517:	68 50 7f 11 80       	push   $0x80117f50
8010351c:	e8 8f f5 ff ff       	call   80102ab0 <kinit1>
  kvmalloc();      // kernel page table
80103521:	e8 6a 52 00 00       	call   80108790 <kvmalloc>
  mpinit();        // detect other processors
80103526:	e8 85 01 00 00       	call   801036b0 <mpinit>
  lapicinit();     // interrupt controller
8010352b:	e8 60 f7 ff ff       	call   80102c90 <lapicinit>
  seginit();       // segment descriptors
80103530:	e8 db 4c 00 00       	call   80108210 <seginit>
  picinit();       // disable pic
80103535:	e8 76 03 00 00       	call   801038b0 <picinit>
  ioapicinit();    // another interrupt controller
8010353a:	e8 31 f3 ff ff       	call   80102870 <ioapicinit>
  consoleinit();   // console hardware
8010353f:	e8 bc d9 ff ff       	call   80100f00 <consoleinit>
  uartinit();      // serial port
80103544:	e8 57 3f 00 00       	call   801074a0 <uartinit>
  pinit();         // process table
80103549:	e8 02 09 00 00       	call   80103e50 <pinit>
  tvinit();        // trap vectors
8010354e:	e8 dd 3b 00 00       	call   80107130 <tvinit>
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
8010356a:	68 8c c4 10 80       	push   $0x8010c48c
8010356f:	68 00 70 00 80       	push   $0x80007000
80103574:	e8 f7 26 00 00       	call   80105c70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
80103583:	00 00 00 
80103586:	05 a0 37 11 80       	add    $0x801137a0,%eax
8010358b:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
80103590:	76 7e                	jbe    80103610 <main+0x110>
80103592:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
80103597:	eb 20                	jmp    801035b9 <main+0xb9>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035a0:	69 05 84 37 11 80 b0 	imul   $0xb0,0x80113784,%eax
801035a7:	00 00 00 
801035aa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035b0:	05 a0 37 11 80       	add    $0x801137a0,%eax
801035b5:	39 c3                	cmp    %eax,%ebx
801035b7:	73 57                	jae    80103610 <main+0x110>
    if(c == mycpu())  // We've started already.
801035b9:	e8 b2 08 00 00       	call   80103e70 <mycpu>
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
801035d4:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
801035db:	b0 10 00 
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
80103622:	e8 f9 08 00 00       	call   80103f20 <userinit>
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
8010365e:	68 58 8f 10 80       	push   $0x80108f58
80103663:	56                   	push   %esi
80103664:	e8 b7 25 00 00       	call   80105c20 <memcmp>
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
80103716:	68 5d 8f 10 80       	push   $0x80108f5d
8010371b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010371c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010371f:	e8 fc 24 00 00       	call   80105c20 <memcmp>
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
80103776:	a3 80 36 11 80       	mov    %eax,0x80113680
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
801037f7:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
801037fd:	eb 99                	jmp    80103798 <mpinit+0xe8>
801037ff:	90                   	nop
      if(ncpu < NCPU) {
80103800:	8b 0d 84 37 11 80    	mov    0x80113784,%ecx
80103806:	83 f9 07             	cmp    $0x7,%ecx
80103809:	7f 19                	jg     80103824 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010380b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103811:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103815:	83 c1 01             	add    $0x1,%ecx
80103818:	89 0d 84 37 11 80    	mov    %ecx,0x80113784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010381e:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
80103824:	83 c0 14             	add    $0x14,%eax
      continue;
80103827:	e9 6c ff ff ff       	jmp    80103798 <mpinit+0xe8>
8010382c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	68 62 8f 10 80       	push   $0x80108f62
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
80103862:	68 58 8f 10 80       	push   $0x80108f58
80103867:	53                   	push   %ebx
80103868:	e8 b3 23 00 00       	call   80105c20 <memcmp>
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
80103898:	68 7c 8f 10 80       	push   $0x80108f7c
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
80103943:	68 9b 8f 10 80       	push   $0x80108f9b
80103948:	50                   	push   %eax
80103949:	e8 f2 1f 00 00       	call   80105940 <initlock>
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
801039df:	e8 2c 21 00 00       	call   80105b10 <acquire>
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
801039ff:	e8 0c 0f 00 00       	call   80104910 <wakeup>
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
80103a24:	e9 87 20 00 00       	jmp    80105ab0 <release>
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	53                   	push   %ebx
80103a34:	e8 77 20 00 00       	call   80105ab0 <release>
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
80103a64:	e8 a7 0e 00 00       	call   80104910 <wakeup>
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
80103a7d:	e8 8e 20 00 00       	call   80105b10 <acquire>
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
80103ac8:	e8 23 04 00 00       	call   80103ef0 <myproc>
80103acd:	8b 48 24             	mov    0x24(%eax),%ecx
80103ad0:	85 c9                	test   %ecx,%ecx
80103ad2:	75 34                	jne    80103b08 <pipewrite+0x98>
      wakeup(&p->nread);
80103ad4:	83 ec 0c             	sub    $0xc,%esp
80103ad7:	57                   	push   %edi
80103ad8:	e8 33 0e 00 00       	call   80104910 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103add:	58                   	pop    %eax
80103ade:	5a                   	pop    %edx
80103adf:	53                   	push   %ebx
80103ae0:	56                   	push   %esi
80103ae1:	e8 6a 0d 00 00       	call   80104850 <sleep>
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
80103b0c:	e8 9f 1f 00 00       	call   80105ab0 <release>
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
80103b5a:	e8 b1 0d 00 00       	call   80104910 <wakeup>
  release(&p->lock);
80103b5f:	89 1c 24             	mov    %ebx,(%esp)
80103b62:	e8 49 1f 00 00       	call   80105ab0 <release>
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
80103b86:	e8 85 1f 00 00       	call   80105b10 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b8b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103b91:	83 c4 10             	add    $0x10,%esp
80103b94:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103b9a:	74 2f                	je     80103bcb <piperead+0x5b>
80103b9c:	eb 37                	jmp    80103bd5 <piperead+0x65>
80103b9e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103ba0:	e8 4b 03 00 00       	call   80103ef0 <myproc>
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
80103bb5:	e8 96 0c 00 00       	call   80104850 <sleep>
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
80103c16:	e8 f5 0c 00 00       	call   80104910 <wakeup>
  release(&p->lock);
80103c1b:	89 34 24             	mov    %esi,(%esp)
80103c1e:	e8 8d 1e 00 00       	call   80105ab0 <release>
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
80103c39:	e8 72 1e 00 00       	call   80105ab0 <release>
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

80103c50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103c56:	68 00 3e 11 80       	push   $0x80113e00
80103c5b:	e8 50 1e 00 00       	call   80105ab0 <release>

  if (first) {
80103c60:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103c65:	83 c4 10             	add    $0x10,%esp
80103c68:	85 c0                	test   %eax,%eax
80103c6a:	75 04                	jne    80103c70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103c6c:	c9                   	leave  
80103c6d:	c3                   	ret    
80103c6e:	66 90                	xchg   %ax,%ax
    first = 0;
80103c70:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103c77:	00 00 00 
    iinit(ROOTDEV);
80103c7a:	83 ec 0c             	sub    $0xc,%esp
80103c7d:	6a 01                	push   $0x1
80103c7f:	e8 7c dd ff ff       	call   80101a00 <iinit>
    initlog(ROOTDEV);
80103c84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103c8b:	e8 d0 f4 ff ff       	call   80103160 <initlog>
}
80103c90:	83 c4 10             	add    $0x10,%esp
80103c93:	c9                   	leave  
80103c94:	c3                   	ret    
80103c95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ca0 <random_number_generator.part.0>:
random_number_generator(int min, int max)
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	57                   	push   %edi
80103ca4:	89 c7                	mov    %eax,%edi
80103ca6:	56                   	push   %esi
80103ca7:	89 d6                	mov    %edx,%esi
80103ca9:	53                   	push   %ebx
    int random_number, diff = max - min + 1, time = ticks;
80103caa:	89 f3                	mov    %esi,%ebx
80103cac:	29 fb                	sub    %edi,%ebx
80103cae:	83 c3 01             	add    $0x1,%ebx
random_number_generator(int min, int max)
80103cb1:	83 ec 28             	sub    $0x28,%esp
    acquire(&tickslock);
80103cb4:	68 00 67 11 80       	push   $0x80116700
80103cb9:	e8 52 1e 00 00       	call   80105b10 <acquire>
    int random_number, diff = max - min + 1, time = ticks;
80103cbe:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
    release(&tickslock);
80103cc4:	c7 04 24 00 67 11 80 	movl   $0x80116700,(%esp)
    int random_number, diff = max - min + 1, time = ticks;
80103ccb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    release(&tickslock);
80103cce:	e8 dd 1d 00 00       	call   80105ab0 <release>
    random_number = (1 + (1 + ((time + 2) % diff ) * (time + 1) * 132) % diff) * (1 + time % max) * (1 + 2 * max % diff);
80103cd3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd6:	8d 41 02             	lea    0x2(%ecx),%eax
80103cd9:	99                   	cltd   
80103cda:	f7 fb                	idiv   %ebx
80103cdc:	8d 41 01             	lea    0x1(%ecx),%eax
80103cdf:	0f af d0             	imul   %eax,%edx
80103ce2:	69 c2 84 00 00 00    	imul   $0x84,%edx,%eax
80103ce8:	83 c0 01             	add    $0x1,%eax
80103ceb:	99                   	cltd   
80103cec:	f7 fb                	idiv   %ebx
80103cee:	8d 42 01             	lea    0x1(%edx),%eax
80103cf1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103cf4:	89 c8                	mov    %ecx,%eax
80103cf6:	99                   	cltd   
80103cf7:	f7 fe                	idiv   %esi
80103cf9:	8d 04 36             	lea    (%esi,%esi,1),%eax
80103cfc:	8d 4a 01             	lea    0x1(%edx),%ecx
80103cff:	99                   	cltd   
80103d00:	f7 fb                	idiv   %ebx
80103d02:	0f af 4d e4          	imul   -0x1c(%ebp),%ecx
}
80103d06:	8d 65 f4             	lea    -0xc(%ebp),%esp
    random_number = (1 + (1 + ((time + 2) % diff ) * (time + 1) * 132) % diff) * (1 + time % max) * (1 + 2 * max % diff);
80103d09:	89 c8                	mov    %ecx,%eax
80103d0b:	83 c2 01             	add    $0x1,%edx
80103d0e:	0f af c2             	imul   %edx,%eax
    random_number = random_number % (max - min + 1) + min;
80103d11:	99                   	cltd   
80103d12:	f7 fb                	idiv   %ebx
}
80103d14:	5b                   	pop    %ebx
80103d15:	5e                   	pop    %esi
    random_number = random_number % (max - min + 1) + min;
80103d16:	8d 04 17             	lea    (%edi,%edx,1),%eax
}
80103d19:	5f                   	pop    %edi
80103d1a:	5d                   	pop    %ebp
80103d1b:	c3                   	ret    
80103d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d20 <allocproc>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d24:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
{
80103d29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103d2c:	68 00 3e 11 80       	push   $0x80113e00
80103d31:	e8 da 1d 00 00       	call   80105b10 <acquire>
80103d36:	83 c4 10             	add    $0x10,%esp
80103d39:	eb 17                	jmp    80103d52 <allocproc+0x32>
80103d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d40:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103d46:	81 fb 34 60 11 80    	cmp    $0x80116034,%ebx
80103d4c:	0f 84 9e 00 00 00    	je     80103df0 <allocproc+0xd0>
    if(p->state == UNUSED)
80103d52:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d55:	85 c0                	test   %eax,%eax
80103d57:	75 e7                	jne    80103d40 <allocproc+0x20>
  p->pid = nextpid++;
80103d59:	a1 04 c0 10 80       	mov    0x8010c004,%eax
  release(&ptable.lock);
80103d5e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d61:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103d68:	89 43 10             	mov    %eax,0x10(%ebx)
80103d6b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d6e:	68 00 3e 11 80       	push   $0x80113e00
  p->pid = nextpid++;
80103d73:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103d79:	e8 32 1d 00 00       	call   80105ab0 <release>
  if((p->kstack = kalloc()) == 0){
80103d7e:	e8 9d ed ff ff       	call   80102b20 <kalloc>
80103d83:	83 c4 10             	add    $0x10,%esp
80103d86:	89 43 08             	mov    %eax,0x8(%ebx)
80103d89:	85 c0                	test   %eax,%eax
80103d8b:	74 7c                	je     80103e09 <allocproc+0xe9>
  sp -= sizeof *p->tf;
80103d8d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
80103d93:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103d96:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103d9b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103d9e:	c7 40 14 1a 71 10 80 	movl   $0x8010711a,0x14(%eax)
  p->context = (struct context*)sp;
80103da5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103da8:	6a 14                	push   $0x14
80103daa:	6a 00                	push   $0x0
80103dac:	50                   	push   %eax
80103dad:	e8 1e 1e 00 00       	call   80105bd0 <memset>
  p->context->eip = (uint)forkret;
80103db2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103db5:	ba 1e 00 00 00       	mov    $0x1e,%edx
80103dba:	c7 40 10 50 3c 10 80 	movl   $0x80103c50,0x10(%eax)
  p->entered_queue = ticks;
80103dc1:	a1 e0 66 11 80       	mov    0x801166e0,%eax
  p->queue = 2;
80103dc6:	c7 43 7c 02 00 00 00 	movl   $0x2,0x7c(%ebx)
  p->entered_queue = ticks;
80103dcd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
    if (min >= max)
80103dd3:	b8 01 00 00 00       	mov    $0x1,%eax
80103dd8:	e8 c3 fe ff ff       	call   80103ca0 <random_number_generator.part.0>
  return p;
80103ddd:	83 c4 10             	add    $0x10,%esp
  p->tickets = random_number_generator(1, DEFAULT_MAX_TICKETS);
80103de0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
}
80103de6:	89 d8                	mov    %ebx,%eax
80103de8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103deb:	c9                   	leave  
80103dec:	c3                   	ret    
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103df0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103df3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103df5:	68 00 3e 11 80       	push   $0x80113e00
80103dfa:	e8 b1 1c 00 00       	call   80105ab0 <release>
}
80103dff:	89 d8                	mov    %ebx,%eax
  return 0;
80103e01:	83 c4 10             	add    $0x10,%esp
}
80103e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e07:	c9                   	leave  
80103e08:	c3                   	ret    
    p->state = UNUSED;
80103e09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103e10:	31 db                	xor    %ebx,%ebx
}
80103e12:	89 d8                	mov    %ebx,%eax
80103e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e17:	c9                   	leave  
80103e18:	c3                   	ret    
80103e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e20 <random_number_generator>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	8b 45 08             	mov    0x8(%ebp),%eax
80103e26:	8b 55 0c             	mov    0xc(%ebp),%edx
    if (min >= max)
80103e29:	39 d0                	cmp    %edx,%eax
80103e2b:	7c 13                	jl     80103e40 <random_number_generator+0x20>
        return max > 0 ? max : -1 * max;
80103e2d:	89 d0                	mov    %edx,%eax
}
80103e2f:	5d                   	pop    %ebp
        return max > 0 ? max : -1 * max;
80103e30:	f7 d8                	neg    %eax
80103e32:	0f 48 c2             	cmovs  %edx,%eax
}
80103e35:	c3                   	ret    
80103e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi
80103e40:	5d                   	pop    %ebp
80103e41:	e9 5a fe ff ff       	jmp    80103ca0 <random_number_generator.part.0>
80103e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi

80103e50 <pinit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e56:	68 a0 8f 10 80       	push   $0x80108fa0
80103e5b:	68 00 3e 11 80       	push   $0x80113e00
80103e60:	e8 db 1a 00 00       	call   80105940 <initlock>
}
80103e65:	83 c4 10             	add    $0x10,%esp
80103e68:	c9                   	leave  
80103e69:	c3                   	ret    
80103e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e70 <mycpu>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	56                   	push   %esi
80103e74:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e75:	9c                   	pushf  
80103e76:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e77:	f6 c4 02             	test   $0x2,%ah
80103e7a:	75 46                	jne    80103ec2 <mycpu+0x52>
  apicid = lapicid();
80103e7c:	e8 0f ef ff ff       	call   80102d90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e81:	8b 35 84 37 11 80    	mov    0x80113784,%esi
80103e87:	85 f6                	test   %esi,%esi
80103e89:	7e 2a                	jle    80103eb5 <mycpu+0x45>
80103e8b:	31 d2                	xor    %edx,%edx
80103e8d:	eb 08                	jmp    80103e97 <mycpu+0x27>
80103e8f:	90                   	nop
80103e90:	83 c2 01             	add    $0x1,%edx
80103e93:	39 f2                	cmp    %esi,%edx
80103e95:	74 1e                	je     80103eb5 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103e97:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103e9d:	0f b6 99 a0 37 11 80 	movzbl -0x7feec860(%ecx),%ebx
80103ea4:	39 c3                	cmp    %eax,%ebx
80103ea6:	75 e8                	jne    80103e90 <mycpu+0x20>
}
80103ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103eab:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
80103eb1:	5b                   	pop    %ebx
80103eb2:	5e                   	pop    %esi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret    
  panic("unknown apicid\n");
80103eb5:	83 ec 0c             	sub    $0xc,%esp
80103eb8:	68 a7 8f 10 80       	push   $0x80108fa7
80103ebd:	e8 be c4 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ec2:	83 ec 0c             	sub    $0xc,%esp
80103ec5:	68 40 91 10 80       	push   $0x80109140
80103eca:	e8 b1 c4 ff ff       	call   80100380 <panic>
80103ecf:	90                   	nop

80103ed0 <cpuid>:
cpuid() {
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ed6:	e8 95 ff ff ff       	call   80103e70 <mycpu>
}
80103edb:	c9                   	leave  
  return mycpu()-cpus;
80103edc:	2d a0 37 11 80       	sub    $0x801137a0,%eax
80103ee1:	c1 f8 04             	sar    $0x4,%eax
80103ee4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eea:	c3                   	ret    
80103eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103eef:	90                   	nop

80103ef0 <myproc>:
myproc(void) {
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ef7:	e8 c4 1a 00 00       	call   801059c0 <pushcli>
  c = mycpu();
80103efc:	e8 6f ff ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80103f01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f07:	e8 04 1b 00 00       	call   80105a10 <popcli>
}
80103f0c:	89 d8                	mov    %ebx,%eax
80103f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f11:	c9                   	leave  
80103f12:	c3                   	ret    
80103f13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f20 <userinit>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f27:	e8 f4 fd ff ff       	call   80103d20 <allocproc>
80103f2c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f2e:	a3 c0 66 11 80       	mov    %eax,0x801166c0
  if((p->pgdir = setupkvm()) == 0)
80103f33:	e8 d8 47 00 00       	call   80108710 <setupkvm>
80103f38:	89 43 04             	mov    %eax,0x4(%ebx)
80103f3b:	85 c0                	test   %eax,%eax
80103f3d:	0f 84 bd 00 00 00    	je     80104000 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f43:	83 ec 04             	sub    $0x4,%esp
80103f46:	68 2c 00 00 00       	push   $0x2c
80103f4b:	68 60 c4 10 80       	push   $0x8010c460
80103f50:	50                   	push   %eax
80103f51:	e8 6a 44 00 00       	call   801083c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f5f:	6a 4c                	push   $0x4c
80103f61:	6a 00                	push   $0x0
80103f63:	ff 73 18             	push   0x18(%ebx)
80103f66:	e8 65 1c 00 00       	call   80105bd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f6b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f6e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f73:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f76:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f7b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f7f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f82:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f86:	8b 43 18             	mov    0x18(%ebx),%eax
80103f89:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f8d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f91:	8b 43 18             	mov    0x18(%ebx),%eax
80103f94:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f98:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f9c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f9f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103fa6:	8b 43 18             	mov    0x18(%ebx),%eax
80103fa9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103fb0:	8b 43 18             	mov    0x18(%ebx),%eax
80103fb3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103fba:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103fbd:	6a 10                	push   $0x10
80103fbf:	68 d0 8f 10 80       	push   $0x80108fd0
80103fc4:	50                   	push   %eax
80103fc5:	e8 c6 1d 00 00       	call   80105d90 <safestrcpy>
  p->cwd = namei("/");
80103fca:	c7 04 24 d9 8f 10 80 	movl   $0x80108fd9,(%esp)
80103fd1:	e8 6a e5 ff ff       	call   80102540 <namei>
80103fd6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fd9:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103fe0:	e8 2b 1b 00 00       	call   80105b10 <acquire>
  p->state = RUNNABLE;
80103fe5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fec:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80103ff3:	e8 b8 1a 00 00       	call   80105ab0 <release>
}
80103ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ffb:	83 c4 10             	add    $0x10,%esp
80103ffe:	c9                   	leave  
80103fff:	c3                   	ret    
    panic("userinit: out of memory?");
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	68 b7 8f 10 80       	push   $0x80108fb7
80104008:	e8 73 c3 ff ff       	call   80100380 <panic>
8010400d:	8d 76 00             	lea    0x0(%esi),%esi

80104010 <growproc>:
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	56                   	push   %esi
80104014:	53                   	push   %ebx
80104015:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104018:	e8 a3 19 00 00       	call   801059c0 <pushcli>
  c = mycpu();
8010401d:	e8 4e fe ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104022:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104028:	e8 e3 19 00 00       	call   80105a10 <popcli>
  sz = curproc->sz;
8010402d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
8010402f:	85 f6                	test   %esi,%esi
80104031:	7f 1d                	jg     80104050 <growproc+0x40>
  } else if(n < 0){
80104033:	75 3b                	jne    80104070 <growproc+0x60>
  switchuvm(curproc);
80104035:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104038:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010403a:	53                   	push   %ebx
8010403b:	e8 70 42 00 00       	call   801082b0 <switchuvm>
  return 0;
80104040:	83 c4 10             	add    $0x10,%esp
80104043:	31 c0                	xor    %eax,%eax
}
80104045:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104048:	5b                   	pop    %ebx
80104049:	5e                   	pop    %esi
8010404a:	5d                   	pop    %ebp
8010404b:	c3                   	ret    
8010404c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104050:	83 ec 04             	sub    $0x4,%esp
80104053:	01 c6                	add    %eax,%esi
80104055:	56                   	push   %esi
80104056:	50                   	push   %eax
80104057:	ff 73 04             	push   0x4(%ebx)
8010405a:	e8 d1 44 00 00       	call   80108530 <allocuvm>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	75 cf                	jne    80104035 <growproc+0x25>
      return -1;
80104066:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010406b:	eb d8                	jmp    80104045 <growproc+0x35>
8010406d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104070:	83 ec 04             	sub    $0x4,%esp
80104073:	01 c6                	add    %eax,%esi
80104075:	56                   	push   %esi
80104076:	50                   	push   %eax
80104077:	ff 73 04             	push   0x4(%ebx)
8010407a:	e8 e1 45 00 00       	call   80108660 <deallocuvm>
8010407f:	83 c4 10             	add    $0x10,%esp
80104082:	85 c0                	test   %eax,%eax
80104084:	75 af                	jne    80104035 <growproc+0x25>
80104086:	eb de                	jmp    80104066 <growproc+0x56>
80104088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408f:	90                   	nop

80104090 <fork>:
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104099:	e8 22 19 00 00       	call   801059c0 <pushcli>
  c = mycpu();
8010409e:	e8 cd fd ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801040a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a9:	e8 62 19 00 00       	call   80105a10 <popcli>
  if((np = allocproc()) == 0){
801040ae:	e8 6d fc ff ff       	call   80103d20 <allocproc>
801040b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801040b6:	85 c0                	test   %eax,%eax
801040b8:	0f 84 b7 00 00 00    	je     80104175 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801040be:	83 ec 08             	sub    $0x8,%esp
801040c1:	ff 33                	push   (%ebx)
801040c3:	89 c7                	mov    %eax,%edi
801040c5:	ff 73 04             	push   0x4(%ebx)
801040c8:	e8 33 47 00 00       	call   80108800 <copyuvm>
801040cd:	83 c4 10             	add    $0x10,%esp
801040d0:	89 47 04             	mov    %eax,0x4(%edi)
801040d3:	85 c0                	test   %eax,%eax
801040d5:	0f 84 a1 00 00 00    	je     8010417c <fork+0xec>
  np->sz = curproc->sz;
801040db:	8b 03                	mov    (%ebx),%eax
801040dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040e0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
801040e2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
801040e5:	89 c8                	mov    %ecx,%eax
801040e7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801040ea:	b9 13 00 00 00       	mov    $0x13,%ecx
801040ef:	8b 73 18             	mov    0x18(%ebx),%esi
801040f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801040f4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040f6:	8b 40 18             	mov    0x18(%eax),%eax
801040f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104100:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104104:	85 c0                	test   %eax,%eax
80104106:	74 13                	je     8010411b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	50                   	push   %eax
8010410c:	e8 2f d2 ff ff       	call   80101340 <filedup>
80104111:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104114:	83 c4 10             	add    $0x10,%esp
80104117:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010411b:	83 c6 01             	add    $0x1,%esi
8010411e:	83 fe 10             	cmp    $0x10,%esi
80104121:	75 dd                	jne    80104100 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80104123:	83 ec 0c             	sub    $0xc,%esp
80104126:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104129:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010412c:	e8 bf da ff ff       	call   80101bf0 <idup>
80104131:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104134:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104137:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010413a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010413d:	6a 10                	push   $0x10
8010413f:	53                   	push   %ebx
80104140:	50                   	push   %eax
80104141:	e8 4a 1c 00 00       	call   80105d90 <safestrcpy>
  pid = np->pid;
80104146:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104149:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80104150:	e8 bb 19 00 00       	call   80105b10 <acquire>
  np->state = RUNNABLE;
80104155:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010415c:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80104163:	e8 48 19 00 00       	call   80105ab0 <release>
  return pid;
80104168:	83 c4 10             	add    $0x10,%esp
}
8010416b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416e:	89 d8                	mov    %ebx,%eax
80104170:	5b                   	pop    %ebx
80104171:	5e                   	pop    %esi
80104172:	5f                   	pop    %edi
80104173:	5d                   	pop    %ebp
80104174:	c3                   	ret    
    return -1;
80104175:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010417a:	eb ef                	jmp    8010416b <fork+0xdb>
    kfree(np->kstack);
8010417c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	ff 73 08             	push   0x8(%ebx)
80104185:	e8 d6 e7 ff ff       	call   80102960 <kfree>
    np->kstack = 0;
8010418a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104191:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104194:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010419b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801041a0:	eb c9                	jmp    8010416b <fork+0xdb>
801041a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041b0 <fix_queues>:
      if(ticks - p->entered_queue >= STARVING_THRESHOLD){
801041b0:	8b 0d e0 66 11 80    	mov    0x801166e0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b6:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
801041bb:	eb 0f                	jmp    801041cc <fix_queues+0x1c>
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
801041c0:	05 88 00 00 00       	add    $0x88,%eax
801041c5:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801041ca:	74 2c                	je     801041f8 <fix_queues+0x48>
    if(p->state == RUNNABLE){
801041cc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801041d0:	75 ee                	jne    801041c0 <fix_queues+0x10>
      if(ticks - p->entered_queue >= STARVING_THRESHOLD){
801041d2:	89 ca                	mov    %ecx,%edx
801041d4:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
801041da:	81 fa 3f 1f 00 00    	cmp    $0x1f3f,%edx
801041e0:	76 de                	jbe    801041c0 <fix_queues+0x10>
        p->queue = 1;
801041e2:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e9:	05 88 00 00 00       	add    $0x88,%eax
        p->entered_queue = ticks;
801041ee:	89 48 f8             	mov    %ecx,-0x8(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f1:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801041f6:	75 d4                	jne    801041cc <fix_queues+0x1c>
}
801041f8:	c3                   	ret    
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104200 <round_robin>:
{ 
80104200:	55                   	push   %ebp
    int starvation_time = 0;
80104201:	31 c9                	xor    %ecx,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104203:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
{ 
80104208:	89 e5                	mov    %esp,%ebp
8010420a:	56                   	push   %esi
    struct proc *min_p = 0;
8010420b:	31 f6                	xor    %esi,%esi
{ 
8010420d:	53                   	push   %ebx
    int time = ticks;
8010420e:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (p->state != RUNNABLE || p->queue != 1)
80104218:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010421c:	75 1a                	jne    80104238 <round_robin+0x38>
8010421e:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
80104222:	75 14                	jne    80104238 <round_robin+0x38>
        int starved_for = time - p->entered_queue;
80104224:	89 da                	mov    %ebx,%edx
80104226:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
        if (starved_for > starvation_time) {
8010422c:	39 ca                	cmp    %ecx,%edx
8010422e:	7e 08                	jle    80104238 <round_robin+0x38>
80104230:	89 d1                	mov    %edx,%ecx
80104232:	89 c6                	mov    %eax,%esi
80104234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104238:	05 88 00 00 00       	add    $0x88,%eax
8010423d:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104242:	75 d4                	jne    80104218 <round_robin+0x18>
}
80104244:	89 f0                	mov    %esi,%eax
80104246:	5b                   	pop    %ebx
80104247:	5e                   	pop    %esi
80104248:	5d                   	pop    %ebp
80104249:	c3                   	ret    
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <lottery>:
  int total_tickets = 0;
80104250:	31 d2                	xor    %edx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104252:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
80104257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010425e:	66 90                	xchg   %ax,%ax
    if(p->state != RUNNABLE || p->queue != 2){
80104260:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104264:	75 0c                	jne    80104272 <lottery+0x22>
80104266:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
8010426a:	75 06                	jne    80104272 <lottery+0x22>
    total_tickets += p->tickets;
8010426c:	03 90 84 00 00 00    	add    0x84(%eax),%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104272:	05 88 00 00 00       	add    $0x88,%eax
80104277:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010427c:	75 e2                	jne    80104260 <lottery+0x10>
    if (min >= max)
8010427e:	83 fa 01             	cmp    $0x1,%edx
80104281:	7f 33                	jg     801042b6 <lottery+0x66>
        return max > 0 ? max : -1 * max;
80104283:	89 d0                	mov    %edx,%eax
80104285:	f7 d8                	neg    %eax
80104287:	0f 49 d0             	cmovns %eax,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428a:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010428f:	90                   	nop
    if(p->state != RUNNABLE || p->queue != 2){
80104290:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104294:	75 10                	jne    801042a6 <lottery+0x56>
80104296:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
8010429a:	75 0a                	jne    801042a6 <lottery+0x56>
    winning_ticket -= p->tickets;
8010429c:	2b 90 84 00 00 00    	sub    0x84(%eax),%edx
    if(winning_ticket <= 0){
801042a2:	85 d2                	test   %edx,%edx
801042a4:	7e 0f                	jle    801042b5 <lottery+0x65>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a6:	05 88 00 00 00       	add    $0x88,%eax
801042ab:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801042b0:	75 de                	jne    80104290 <lottery+0x40>
  return 0;
801042b2:	31 c0                	xor    %eax,%eax
801042b4:	c3                   	ret    
}
801042b5:	c3                   	ret    
{
801042b6:	55                   	push   %ebp
801042b7:	b8 01 00 00 00       	mov    $0x1,%eax
801042bc:	89 e5                	mov    %esp,%ebp
801042be:	83 ec 08             	sub    $0x8,%esp
801042c1:	e8 da f9 ff ff       	call   80103ca0 <random_number_generator.part.0>
801042c6:	89 c2                	mov    %eax,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c8:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
801042cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->state != RUNNABLE || p->queue != 2){
801042d0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042d4:	75 10                	jne    801042e6 <lottery+0x96>
801042d6:	83 78 7c 02          	cmpl   $0x2,0x7c(%eax)
801042da:	75 0a                	jne    801042e6 <lottery+0x96>
    winning_ticket -= p->tickets;
801042dc:	2b 90 84 00 00 00    	sub    0x84(%eax),%edx
    if(winning_ticket <= 0){
801042e2:	85 d2                	test   %edx,%edx
801042e4:	7e 0e                	jle    801042f4 <lottery+0xa4>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e6:	05 88 00 00 00       	add    $0x88,%eax
801042eb:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801042f0:	75 de                	jne    801042d0 <lottery+0x80>
  return 0;
801042f2:	31 c0                	xor    %eax,%eax
}
801042f4:	c9                   	leave  
801042f5:	c3                   	ret    
801042f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fd:	8d 76 00             	lea    0x0(%esi),%esi

80104300 <fcfs>:
{
80104300:	55                   	push   %ebp
  int mn = 2e9;
80104301:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104306:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
{
8010430b:	89 e5                	mov    %esp,%ebp
8010430d:	53                   	push   %ebx
  struct proc* first_proc = 0;
8010430e:	31 db                	xor    %ebx,%ebx
    if(p->state != RUNNABLE || p->queue != 3){
80104310:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104314:	75 1a                	jne    80104330 <fcfs+0x30>
80104316:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
8010431a:	75 14                	jne    80104330 <fcfs+0x30>
    if(p->entered_queue < mn){
8010431c:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104322:	39 ca                	cmp    %ecx,%edx
80104324:	7d 0a                	jge    80104330 <fcfs+0x30>
80104326:	89 d1                	mov    %edx,%ecx
80104328:	89 c3                	mov    %eax,%ebx
8010432a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104330:	05 88 00 00 00       	add    $0x88,%eax
80104335:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010433a:	75 d4                	jne    80104310 <fcfs+0x10>
}
8010433c:	89 d8                	mov    %ebx,%eax
8010433e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104341:	c9                   	leave  
80104342:	c3                   	ret    
80104343:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <scheduler>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104359:	e8 12 fb ff ff       	call   80103e70 <mycpu>
  c->proc = 0;
8010435e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104365:	00 00 00 
  struct cpu *c = mycpu();
80104368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
8010436b:	83 c0 04             	add    $0x4,%eax
8010436e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80104378:	fb                   	sti    
    acquire(&ptable.lock);
80104379:	83 ec 0c             	sub    $0xc,%esp
8010437c:	68 00 3e 11 80       	push   $0x80113e00
80104381:	e8 8a 17 00 00       	call   80105b10 <acquire>
      if(ticks - p->entered_queue >= STARVING_THRESHOLD){
80104386:	8b 15 e0 66 11 80    	mov    0x801166e0,%edx
        p->entered_queue = ticks;
8010438c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438f:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
        p->entered_queue = ticks;
80104394:	89 d7                	mov    %edx,%edi
80104396:	eb 14                	jmp    801043ac <scheduler+0x5c>
80104398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a0:	05 88 00 00 00       	add    $0x88,%eax
801043a5:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801043aa:	74 34                	je     801043e0 <scheduler+0x90>
    if(p->state == RUNNABLE){
801043ac:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043b0:	75 ee                	jne    801043a0 <scheduler+0x50>
      if(ticks - p->entered_queue >= STARVING_THRESHOLD){
801043b2:	89 d1                	mov    %edx,%ecx
801043b4:	2b 88 80 00 00 00    	sub    0x80(%eax),%ecx
801043ba:	81 f9 3f 1f 00 00    	cmp    $0x1f3f,%ecx
801043c0:	76 de                	jbe    801043a0 <scheduler+0x50>
        p->queue = 1;
801043c2:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c9:	05 88 00 00 00       	add    $0x88,%eax
        p->entered_queue = ticks;
801043ce:	89 50 f8             	mov    %edx,-0x8(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d1:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801043d6:	75 d4                	jne    801043ac <scheduler+0x5c>
801043d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop
    struct proc *min_p = 0;
801043e0:	31 f6                	xor    %esi,%esi
    int starvation_time = 0;
801043e2:	31 db                	xor    %ebx,%ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043e4:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (p->state != RUNNABLE || p->queue != 1)
801043f0:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801043f4:	75 1a                	jne    80104410 <scheduler+0xc0>
801043f6:	83 78 7c 01          	cmpl   $0x1,0x7c(%eax)
801043fa:	75 14                	jne    80104410 <scheduler+0xc0>
        int starved_for = time - p->entered_queue;
801043fc:	89 d1                	mov    %edx,%ecx
801043fe:	2b 88 80 00 00 00    	sub    0x80(%eax),%ecx
        if (starved_for > starvation_time) {
80104404:	39 d9                	cmp    %ebx,%ecx
80104406:	7e 08                	jle    80104410 <scheduler+0xc0>
80104408:	89 cb                	mov    %ecx,%ebx
8010440a:	89 c6                	mov    %eax,%esi
8010440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104410:	05 88 00 00 00       	add    $0x88,%eax
80104415:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010441a:	75 d4                	jne    801043f0 <scheduler+0xa0>
    if(p == 0){
8010441c:	85 f6                	test   %esi,%esi
8010441e:	74 4f                	je     8010446f <scheduler+0x11f>
    p->entered_queue = ticks;
80104420:	89 be 80 00 00 00    	mov    %edi,0x80(%esi)
    c->proc = p;
80104426:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    switchuvm(p);
80104429:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
8010442c:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
    switchuvm(p);
80104432:	56                   	push   %esi
80104433:	e8 78 3e 00 00       	call   801082b0 <switchuvm>
    p->state = RUNNING;
80104438:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    swtch(&(c->scheduler), p->context);
8010443f:	58                   	pop    %eax
80104440:	5a                   	pop    %edx
80104441:	ff 76 1c             	push   0x1c(%esi)
80104444:	ff 75 e0             	push   -0x20(%ebp)
80104447:	e8 9f 19 00 00       	call   80105deb <swtch>
    switchkvm();
8010444c:	e8 4f 3e 00 00       	call   801082a0 <switchkvm>
    c->proc = 0;
80104451:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104458:	00 00 00 
    release(&ptable.lock);
8010445b:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80104462:	e8 49 16 00 00       	call   80105ab0 <release>
80104467:	83 c4 10             	add    $0x10,%esp
8010446a:	e9 09 ff ff ff       	jmp    80104378 <scheduler+0x28>
      p = lottery();
8010446f:	e8 dc fd ff ff       	call   80104250 <lottery>
80104474:	89 c6                	mov    %eax,%esi
    if(p == 0){
80104476:	85 c0                	test   %eax,%eax
80104478:	75 53                	jne    801044cd <scheduler+0x17d>
  int mn = 2e9;
8010447a:	b9 00 94 35 77       	mov    $0x77359400,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010447f:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state != RUNNABLE || p->queue != 3){
80104488:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010448c:	75 1a                	jne    801044a8 <scheduler+0x158>
8010448e:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
80104492:	75 14                	jne    801044a8 <scheduler+0x158>
    if(p->entered_queue < mn){
80104494:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010449a:	39 ca                	cmp    %ecx,%edx
8010449c:	7d 0a                	jge    801044a8 <scheduler+0x158>
8010449e:	89 d1                	mov    %edx,%ecx
801044a0:	89 c6                	mov    %eax,%esi
801044a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a8:	05 88 00 00 00       	add    $0x88,%eax
801044ad:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801044b2:	75 d4                	jne    80104488 <scheduler+0x138>
    if(p == 0){
801044b4:	85 f6                	test   %esi,%esi
801044b6:	75 15                	jne    801044cd <scheduler+0x17d>
      release(&ptable.lock);
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 00 3e 11 80       	push   $0x80113e00
801044c0:	e8 eb 15 00 00       	call   80105ab0 <release>
      continue;
801044c5:	83 c4 10             	add    $0x10,%esp
801044c8:	e9 ab fe ff ff       	jmp    80104378 <scheduler+0x28>
    p->entered_queue = ticks;
801044cd:	8b 3d e0 66 11 80    	mov    0x801166e0,%edi
801044d3:	e9 48 ff ff ff       	jmp    80104420 <scheduler+0xd0>
801044d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044df:	90                   	nop

801044e0 <sched>:
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	56                   	push   %esi
801044e4:	53                   	push   %ebx
  pushcli();
801044e5:	e8 d6 14 00 00       	call   801059c0 <pushcli>
  c = mycpu();
801044ea:	e8 81 f9 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801044ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f5:	e8 16 15 00 00       	call   80105a10 <popcli>
  if(!holding(&ptable.lock))
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 00 3e 11 80       	push   $0x80113e00
80104502:	e8 69 15 00 00       	call   80105a70 <holding>
80104507:	83 c4 10             	add    $0x10,%esp
8010450a:	85 c0                	test   %eax,%eax
8010450c:	74 4f                	je     8010455d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010450e:	e8 5d f9 ff ff       	call   80103e70 <mycpu>
80104513:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010451a:	75 68                	jne    80104584 <sched+0xa4>
  if(p->state == RUNNING)
8010451c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104520:	74 55                	je     80104577 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104522:	9c                   	pushf  
80104523:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104524:	f6 c4 02             	test   $0x2,%ah
80104527:	75 41                	jne    8010456a <sched+0x8a>
  intena = mycpu()->intena;
80104529:	e8 42 f9 ff ff       	call   80103e70 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010452e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104531:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104537:	e8 34 f9 ff ff       	call   80103e70 <mycpu>
8010453c:	83 ec 08             	sub    $0x8,%esp
8010453f:	ff 70 04             	push   0x4(%eax)
80104542:	53                   	push   %ebx
80104543:	e8 a3 18 00 00       	call   80105deb <swtch>
  mycpu()->intena = intena;
80104548:	e8 23 f9 ff ff       	call   80103e70 <mycpu>
}
8010454d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104550:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104556:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104559:	5b                   	pop    %ebx
8010455a:	5e                   	pop    %esi
8010455b:	5d                   	pop    %ebp
8010455c:	c3                   	ret    
    panic("sched ptable.lock");
8010455d:	83 ec 0c             	sub    $0xc,%esp
80104560:	68 db 8f 10 80       	push   $0x80108fdb
80104565:	e8 16 be ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 07 90 10 80       	push   $0x80109007
80104572:	e8 09 be ff ff       	call   80100380 <panic>
    panic("sched running");
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	68 f9 8f 10 80       	push   $0x80108ff9
8010457f:	e8 fc bd ff ff       	call   80100380 <panic>
    panic("sched locks");
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	68 ed 8f 10 80       	push   $0x80108fed
8010458c:	e8 ef bd ff ff       	call   80100380 <panic>
80104591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459f:	90                   	nop

801045a0 <exit>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	53                   	push   %ebx
801045a6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801045a9:	e8 42 f9 ff ff       	call   80103ef0 <myproc>
  if(curproc == initproc)
801045ae:	39 05 c0 66 11 80    	cmp    %eax,0x801166c0
801045b4:	0f 84 07 01 00 00    	je     801046c1 <exit+0x121>
801045ba:	89 c3                	mov    %eax,%ebx
801045bc:	8d 70 28             	lea    0x28(%eax),%esi
801045bf:	8d 78 68             	lea    0x68(%eax),%edi
801045c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801045c8:	8b 06                	mov    (%esi),%eax
801045ca:	85 c0                	test   %eax,%eax
801045cc:	74 12                	je     801045e0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
801045ce:	83 ec 0c             	sub    $0xc,%esp
801045d1:	50                   	push   %eax
801045d2:	e8 b9 cd ff ff       	call   80101390 <fileclose>
      curproc->ofile[fd] = 0;
801045d7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801045dd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801045e0:	83 c6 04             	add    $0x4,%esi
801045e3:	39 f7                	cmp    %esi,%edi
801045e5:	75 e1                	jne    801045c8 <exit+0x28>
  begin_op();
801045e7:	e8 14 ec ff ff       	call   80103200 <begin_op>
  iput(curproc->cwd);
801045ec:	83 ec 0c             	sub    $0xc,%esp
801045ef:	ff 73 68             	push   0x68(%ebx)
801045f2:	e8 59 d7 ff ff       	call   80101d50 <iput>
  end_op();
801045f7:	e8 74 ec ff ff       	call   80103270 <end_op>
  curproc->cwd = 0;
801045fc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80104603:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
8010460a:	e8 01 15 00 00       	call   80105b10 <acquire>
  wakeup1(curproc->parent);
8010460f:	8b 53 14             	mov    0x14(%ebx),%edx
80104612:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104615:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010461a:	eb 10                	jmp    8010462c <exit+0x8c>
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104620:	05 88 00 00 00       	add    $0x88,%eax
80104625:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010462a:	74 1e                	je     8010464a <exit+0xaa>
    if(p->state == SLEEPING && p->chan == chan)
8010462c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104630:	75 ee                	jne    80104620 <exit+0x80>
80104632:	3b 50 20             	cmp    0x20(%eax),%edx
80104635:	75 e9                	jne    80104620 <exit+0x80>
      p->state = RUNNABLE;
80104637:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010463e:	05 88 00 00 00       	add    $0x88,%eax
80104643:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104648:	75 e2                	jne    8010462c <exit+0x8c>
      p->parent = initproc;
8010464a:	8b 0d c0 66 11 80    	mov    0x801166c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104650:	ba 34 3e 11 80       	mov    $0x80113e34,%edx
80104655:	eb 17                	jmp    8010466e <exit+0xce>
80104657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465e:	66 90                	xchg   %ax,%ax
80104660:	81 c2 88 00 00 00    	add    $0x88,%edx
80104666:	81 fa 34 60 11 80    	cmp    $0x80116034,%edx
8010466c:	74 3a                	je     801046a8 <exit+0x108>
    if(p->parent == curproc){
8010466e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104671:	75 ed                	jne    80104660 <exit+0xc0>
      if(p->state == ZOMBIE)
80104673:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104677:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010467a:	75 e4                	jne    80104660 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010467c:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
80104681:	eb 11                	jmp    80104694 <exit+0xf4>
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	05 88 00 00 00       	add    $0x88,%eax
8010468d:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104692:	74 cc                	je     80104660 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104694:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104698:	75 ee                	jne    80104688 <exit+0xe8>
8010469a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010469d:	75 e9                	jne    80104688 <exit+0xe8>
      p->state = RUNNABLE;
8010469f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801046a6:	eb e0                	jmp    80104688 <exit+0xe8>
  curproc->state = ZOMBIE;
801046a8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801046af:	e8 2c fe ff ff       	call   801044e0 <sched>
  panic("zombie exit");
801046b4:	83 ec 0c             	sub    $0xc,%esp
801046b7:	68 28 90 10 80       	push   $0x80109028
801046bc:	e8 bf bc ff ff       	call   80100380 <panic>
    panic("init exiting");
801046c1:	83 ec 0c             	sub    $0xc,%esp
801046c4:	68 1b 90 10 80       	push   $0x8010901b
801046c9:	e8 b2 bc ff ff       	call   80100380 <panic>
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <wait>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
  pushcli();
801046d5:	e8 e6 12 00 00       	call   801059c0 <pushcli>
  c = mycpu();
801046da:	e8 91 f7 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801046df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046e5:	e8 26 13 00 00       	call   80105a10 <popcli>
  acquire(&ptable.lock);
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	68 00 3e 11 80       	push   $0x80113e00
801046f2:	e8 19 14 00 00       	call   80105b10 <acquire>
801046f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801046fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046fc:	bb 34 3e 11 80       	mov    $0x80113e34,%ebx
80104701:	eb 13                	jmp    80104716 <wait+0x46>
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
80104708:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010470e:	81 fb 34 60 11 80    	cmp    $0x80116034,%ebx
80104714:	74 1e                	je     80104734 <wait+0x64>
      if(p->parent != curproc)
80104716:	39 73 14             	cmp    %esi,0x14(%ebx)
80104719:	75 ed                	jne    80104708 <wait+0x38>
      if(p->state == ZOMBIE){
8010471b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010471f:	74 5f                	je     80104780 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104721:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80104727:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472c:	81 fb 34 60 11 80    	cmp    $0x80116034,%ebx
80104732:	75 e2                	jne    80104716 <wait+0x46>
    if(!havekids || curproc->killed){
80104734:	85 c0                	test   %eax,%eax
80104736:	0f 84 9a 00 00 00    	je     801047d6 <wait+0x106>
8010473c:	8b 46 24             	mov    0x24(%esi),%eax
8010473f:	85 c0                	test   %eax,%eax
80104741:	0f 85 8f 00 00 00    	jne    801047d6 <wait+0x106>
  pushcli();
80104747:	e8 74 12 00 00       	call   801059c0 <pushcli>
  c = mycpu();
8010474c:	e8 1f f7 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104751:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104757:	e8 b4 12 00 00       	call   80105a10 <popcli>
  if(p == 0)
8010475c:	85 db                	test   %ebx,%ebx
8010475e:	0f 84 89 00 00 00    	je     801047ed <wait+0x11d>
  p->chan = chan;
80104764:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104767:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010476e:	e8 6d fd ff ff       	call   801044e0 <sched>
  p->chan = 0;
80104773:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010477a:	e9 7b ff ff ff       	jmp    801046fa <wait+0x2a>
8010477f:	90                   	nop
        kfree(p->kstack);
80104780:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104783:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104786:	ff 73 08             	push   0x8(%ebx)
80104789:	e8 d2 e1 ff ff       	call   80102960 <kfree>
        p->kstack = 0;
8010478e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104795:	5a                   	pop    %edx
80104796:	ff 73 04             	push   0x4(%ebx)
80104799:	e8 f2 3e 00 00       	call   80108690 <freevm>
        p->pid = 0;
8010479e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801047a5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047ac:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801047b0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801047be:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
801047c5:	e8 e6 12 00 00       	call   80105ab0 <release>
        return pid;
801047ca:	83 c4 10             	add    $0x10,%esp
}
801047cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d0:	89 f0                	mov    %esi,%eax
801047d2:	5b                   	pop    %ebx
801047d3:	5e                   	pop    %esi
801047d4:	5d                   	pop    %ebp
801047d5:	c3                   	ret    
      release(&ptable.lock);
801047d6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801047d9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801047de:	68 00 3e 11 80       	push   $0x80113e00
801047e3:	e8 c8 12 00 00       	call   80105ab0 <release>
      return -1;
801047e8:	83 c4 10             	add    $0x10,%esp
801047eb:	eb e0                	jmp    801047cd <wait+0xfd>
    panic("sleep");
801047ed:	83 ec 0c             	sub    $0xc,%esp
801047f0:	68 34 90 10 80       	push   $0x80109034
801047f5:	e8 86 bb ff ff       	call   80100380 <panic>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <yield>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104807:	68 00 3e 11 80       	push   $0x80113e00
8010480c:	e8 ff 12 00 00       	call   80105b10 <acquire>
  pushcli();
80104811:	e8 aa 11 00 00       	call   801059c0 <pushcli>
  c = mycpu();
80104816:	e8 55 f6 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
8010481b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104821:	e8 ea 11 00 00       	call   80105a10 <popcli>
  myproc()->state = RUNNABLE;
80104826:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010482d:	e8 ae fc ff ff       	call   801044e0 <sched>
  release(&ptable.lock);
80104832:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80104839:	e8 72 12 00 00       	call   80105ab0 <release>
}
8010483e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104841:	83 c4 10             	add    $0x10,%esp
80104844:	c9                   	leave  
80104845:	c3                   	ret    
80104846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010484d:	8d 76 00             	lea    0x0(%esi),%esi

80104850 <sleep>:
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	83 ec 0c             	sub    $0xc,%esp
80104859:	8b 7d 08             	mov    0x8(%ebp),%edi
8010485c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010485f:	e8 5c 11 00 00       	call   801059c0 <pushcli>
  c = mycpu();
80104864:	e8 07 f6 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104869:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010486f:	e8 9c 11 00 00       	call   80105a10 <popcli>
  if(p == 0)
80104874:	85 db                	test   %ebx,%ebx
80104876:	0f 84 87 00 00 00    	je     80104903 <sleep+0xb3>
  if(lk == 0)
8010487c:	85 f6                	test   %esi,%esi
8010487e:	74 76                	je     801048f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104880:	81 fe 00 3e 11 80    	cmp    $0x80113e00,%esi
80104886:	74 50                	je     801048d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	68 00 3e 11 80       	push   $0x80113e00
80104890:	e8 7b 12 00 00       	call   80105b10 <acquire>
    release(lk);
80104895:	89 34 24             	mov    %esi,(%esp)
80104898:	e8 13 12 00 00       	call   80105ab0 <release>
  p->chan = chan;
8010489d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048a7:	e8 34 fc ff ff       	call   801044e0 <sched>
  p->chan = 0;
801048ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801048b3:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
801048ba:	e8 f1 11 00 00       	call   80105ab0 <release>
    acquire(lk);
801048bf:	89 75 08             	mov    %esi,0x8(%ebp)
801048c2:	83 c4 10             	add    $0x10,%esp
}
801048c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c8:	5b                   	pop    %ebx
801048c9:	5e                   	pop    %esi
801048ca:	5f                   	pop    %edi
801048cb:	5d                   	pop    %ebp
    acquire(lk);
801048cc:	e9 3f 12 00 00       	jmp    80105b10 <acquire>
801048d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801048d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048e2:	e8 f9 fb ff ff       	call   801044e0 <sched>
  p->chan = 0;
801048e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801048ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048f1:	5b                   	pop    %ebx
801048f2:	5e                   	pop    %esi
801048f3:	5f                   	pop    %edi
801048f4:	5d                   	pop    %ebp
801048f5:	c3                   	ret    
    panic("sleep without lk");
801048f6:	83 ec 0c             	sub    $0xc,%esp
801048f9:	68 3a 90 10 80       	push   $0x8010903a
801048fe:	e8 7d ba ff ff       	call   80100380 <panic>
    panic("sleep");
80104903:	83 ec 0c             	sub    $0xc,%esp
80104906:	68 34 90 10 80       	push   $0x80109034
8010490b:	e8 70 ba ff ff       	call   80100380 <panic>

80104910 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 10             	sub    $0x10,%esp
80104917:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010491a:	68 00 3e 11 80       	push   $0x80113e00
8010491f:	e8 ec 11 00 00       	call   80105b10 <acquire>
80104924:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104927:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010492c:	eb 0e                	jmp    8010493c <wakeup+0x2c>
8010492e:	66 90                	xchg   %ax,%ax
80104930:	05 88 00 00 00       	add    $0x88,%eax
80104935:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010493a:	74 1e                	je     8010495a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010493c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104940:	75 ee                	jne    80104930 <wakeup+0x20>
80104942:	3b 58 20             	cmp    0x20(%eax),%ebx
80104945:	75 e9                	jne    80104930 <wakeup+0x20>
      p->state = RUNNABLE;
80104947:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010494e:	05 88 00 00 00       	add    $0x88,%eax
80104953:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104958:	75 e2                	jne    8010493c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010495a:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
80104961:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104964:	c9                   	leave  
  release(&ptable.lock);
80104965:	e9 46 11 00 00       	jmp    80105ab0 <release>
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104970 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
80104974:	83 ec 10             	sub    $0x10,%esp
80104977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010497a:	68 00 3e 11 80       	push   $0x80113e00
8010497f:	e8 8c 11 00 00       	call   80105b10 <acquire>
80104984:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104987:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010498c:	eb 0e                	jmp    8010499c <kill+0x2c>
8010498e:	66 90                	xchg   %ax,%ax
80104990:	05 88 00 00 00       	add    $0x88,%eax
80104995:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010499a:	74 34                	je     801049d0 <kill+0x60>
    if(p->pid == pid){
8010499c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010499f:	75 ef                	jne    80104990 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801049a1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801049a5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801049ac:	75 07                	jne    801049b5 <kill+0x45>
        p->state = RUNNABLE;
801049ae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801049b5:	83 ec 0c             	sub    $0xc,%esp
801049b8:	68 00 3e 11 80       	push   $0x80113e00
801049bd:	e8 ee 10 00 00       	call   80105ab0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801049c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	31 c0                	xor    %eax,%eax
}
801049ca:	c9                   	leave  
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801049d0:	83 ec 0c             	sub    $0xc,%esp
801049d3:	68 00 3e 11 80       	push   $0x80113e00
801049d8:	e8 d3 10 00 00       	call   80105ab0 <release>
}
801049dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801049e0:	83 c4 10             	add    $0x10,%esp
801049e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e8:	c9                   	leave  
801049e9:	c3                   	ret    
801049ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049f0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801049f8:	53                   	push   %ebx
801049f9:	bb a0 3e 11 80       	mov    $0x80113ea0,%ebx
801049fe:	83 ec 3c             	sub    $0x3c,%esp
80104a01:	eb 27                	jmp    80104a2a <procdump+0x3a>
80104a03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a07:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	68 df 97 10 80       	push   $0x801097df
80104a10:	e8 db bc ff ff       	call   801006f0 <cprintf>
80104a15:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a18:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104a1e:	81 fb a0 60 11 80    	cmp    $0x801160a0,%ebx
80104a24:	0f 84 7e 00 00 00    	je     80104aa8 <procdump+0xb8>
    if(p->state == UNUSED)
80104a2a:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	74 e7                	je     80104a18 <procdump+0x28>
      state = "???";
80104a31:	ba 4b 90 10 80       	mov    $0x8010904b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a36:	83 f8 05             	cmp    $0x5,%eax
80104a39:	77 11                	ja     80104a4c <procdump+0x5c>
80104a3b:	8b 14 85 28 93 10 80 	mov    -0x7fef6cd8(,%eax,4),%edx
      state = "???";
80104a42:	b8 4b 90 10 80       	mov    $0x8010904b,%eax
80104a47:	85 d2                	test   %edx,%edx
80104a49:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a4c:	53                   	push   %ebx
80104a4d:	52                   	push   %edx
80104a4e:	ff 73 a4             	push   -0x5c(%ebx)
80104a51:	68 4f 90 10 80       	push   $0x8010904f
80104a56:	e8 95 bc ff ff       	call   801006f0 <cprintf>
    if(p->state == SLEEPING){
80104a5b:	83 c4 10             	add    $0x10,%esp
80104a5e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104a62:	75 a4                	jne    80104a08 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104a64:	83 ec 08             	sub    $0x8,%esp
80104a67:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104a6a:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104a6d:	50                   	push   %eax
80104a6e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104a71:	8b 40 0c             	mov    0xc(%eax),%eax
80104a74:	83 c0 08             	add    $0x8,%eax
80104a77:	50                   	push   %eax
80104a78:	e8 e3 0e 00 00       	call   80105960 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	8b 17                	mov    (%edi),%edx
80104a82:	85 d2                	test   %edx,%edx
80104a84:	74 82                	je     80104a08 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104a86:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104a89:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
80104a8c:	52                   	push   %edx
80104a8d:	68 a1 8a 10 80       	push   $0x80108aa1
80104a92:	e8 59 bc ff ff       	call   801006f0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	39 fe                	cmp    %edi,%esi
80104a9c:	75 e2                	jne    80104a80 <procdump+0x90>
80104a9e:	e9 65 ff ff ff       	jmp    80104a08 <procdump+0x18>
80104aa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104aa7:	90                   	nop
  }
}
80104aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aab:	5b                   	pop    %ebx
80104aac:	5e                   	pop    %esi
80104aad:	5f                   	pop    %edi
80104aae:	5d                   	pop    %ebp
80104aaf:	c3                   	ret    

80104ab0 <find_fibonacci_number>:

// find the nth fibonacci number:
int find_fibonacci_number(int n) {
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 4c             	sub    $0x4c,%esp
80104ab9:	8b 55 08             	mov    0x8(%ebp),%edx
    if(n > 1 && n < 4) {
80104abc:	8d 42 fe             	lea    -0x2(%edx),%eax
80104abf:	83 f8 01             	cmp    $0x1,%eax
80104ac2:	0f 86 4f 02 00 00    	jbe    80104d17 <find_fibonacci_number+0x267>
        return 1;
    }
    else if(n == 1) {
80104ac8:	83 fa 01             	cmp    $0x1,%edx
80104acb:	0f 84 4d 02 00 00    	je     80104d1e <find_fibonacci_number+0x26e>
        return 0;
    }
    else if (n < 1) {
80104ad1:	85 d2                	test   %edx,%edx
80104ad3:	0f 8e 49 02 00 00    	jle    80104d22 <find_fibonacci_number+0x272>
80104ad9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if(n > 1 && n < 4) {
80104ae0:	83 f8 02             	cmp    $0x2,%eax
80104ae3:	0f 84 20 02 00 00    	je     80104d09 <find_fibonacci_number+0x259>
80104ae9:	83 e8 02             	sub    $0x2,%eax
80104aec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        return -1;
    }
    else{
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104af3:	89 c1                	mov    %eax,%ecx
    if(n > 1 && n < 4) {
80104af5:	89 45 c8             	mov    %eax,-0x38(%ebp)
80104af8:	83 f9 01             	cmp    $0x1,%ecx
80104afb:	0f 84 98 01 00 00    	je     80104c99 <find_fibonacci_number+0x1e9>
80104b01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80104b08:	89 c8                	mov    %ecx,%eax
80104b0a:	89 4d bc             	mov    %ecx,-0x44(%ebp)
80104b0d:	83 f8 02             	cmp    $0x2,%eax
80104b10:	0f 84 e2 01 00 00    	je     80104cf8 <find_fibonacci_number+0x248>
80104b16:	83 e8 02             	sub    $0x2,%eax
80104b19:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104b20:	89 c1                	mov    %eax,%ecx
    if(n > 1 && n < 4) {
80104b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80104b25:	83 f9 01             	cmp    $0x1,%ecx
80104b28:	0f 84 21 01 00 00    	je     80104c4f <find_fibonacci_number+0x19f>
80104b2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
80104b35:	89 c8                	mov    %ecx,%eax
80104b37:	89 4d b8             	mov    %ecx,-0x48(%ebp)
80104b3a:	83 f8 02             	cmp    $0x2,%eax
80104b3d:	0f 84 a4 01 00 00    	je     80104ce7 <find_fibonacci_number+0x237>
80104b43:	83 e8 02             	sub    $0x2,%eax
80104b46:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104b4d:	89 c1                	mov    %eax,%ecx
    if(n > 1 && n < 4) {
80104b4f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80104b52:	83 f9 01             	cmp    $0x1,%ecx
80104b55:	0f 84 aa 00 00 00    	je     80104c05 <find_fibonacci_number+0x155>
80104b5b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
80104b62:	89 cb                	mov    %ecx,%ebx
80104b64:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
80104b67:	83 fb 02             	cmp    $0x2,%ebx
80104b6a:	0f 84 5f 01 00 00    	je     80104ccf <find_fibonacci_number+0x21f>
80104b70:	83 eb 02             	sub    $0x2,%ebx
80104b73:	31 ff                	xor    %edi,%edi
80104b75:	89 de                	mov    %ebx,%esi
80104b77:	89 da                	mov    %ebx,%edx
80104b79:	83 fe 01             	cmp    $0x1,%esi
80104b7c:	74 46                	je     80104bc4 <find_fibonacci_number+0x114>
80104b7e:	89 f1                	mov    %esi,%ecx
80104b80:	31 db                	xor    %ebx,%ebx
80104b82:	89 75 b0             	mov    %esi,-0x50(%ebp)
80104b85:	89 de                	mov    %ebx,%esi
80104b87:	89 cb                	mov    %ecx,%ebx
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104b89:	83 ec 0c             	sub    $0xc,%esp
80104b8c:	8d 43 01             	lea    0x1(%ebx),%eax
80104b8f:	89 55 ac             	mov    %edx,-0x54(%ebp)
    if(n > 1 && n < 4) {
80104b92:	83 eb 02             	sub    $0x2,%ebx
        return find_fibonacci_number(n - 1) + find_fibonacci_number(n - 2);
80104b95:	50                   	push   %eax
80104b96:	e8 15 ff ff ff       	call   80104ab0 <find_fibonacci_number>
80104b9b:	83 c4 10             	add    $0x10,%esp
    if(n > 1 && n < 4) {
80104b9e:	8b 55 ac             	mov    -0x54(%ebp),%edx
80104ba1:	01 c6                	add    %eax,%esi
80104ba3:	83 fb 01             	cmp    $0x1,%ebx
80104ba6:	77 e1                	ja     80104b89 <find_fibonacci_number+0xd9>
80104ba8:	89 f3                	mov    %esi,%ebx
80104baa:	8b 75 b0             	mov    -0x50(%ebp),%esi
80104bad:	8d 43 01             	lea    0x1(%ebx),%eax
80104bb0:	01 c7                	add    %eax,%edi
80104bb2:	8d 46 fe             	lea    -0x2(%esi),%eax
80104bb5:	83 ee 01             	sub    $0x1,%esi
80104bb8:	83 fe 01             	cmp    $0x1,%esi
80104bbb:	76 19                	jbe    80104bd6 <find_fibonacci_number+0x126>
80104bbd:	89 c6                	mov    %eax,%esi
80104bbf:	83 fe 01             	cmp    $0x1,%esi
80104bc2:	75 ba                	jne    80104b7e <find_fibonacci_number+0xce>
80104bc4:	b8 01 00 00 00       	mov    $0x1,%eax
80104bc9:	01 c7                	add    %eax,%edi
80104bcb:	8d 46 fe             	lea    -0x2(%esi),%eax
80104bce:	83 ee 01             	sub    $0x1,%esi
80104bd1:	83 fe 01             	cmp    $0x1,%esi
80104bd4:	77 e7                	ja     80104bbd <find_fibonacci_number+0x10d>
80104bd6:	89 d3                	mov    %edx,%ebx
80104bd8:	83 c7 01             	add    $0x1,%edi
80104bdb:	01 7d cc             	add    %edi,-0x34(%ebp)
80104bde:	83 fb 01             	cmp    $0x1,%ebx
80104be1:	77 84                	ja     80104b67 <find_fibonacci_number+0xb7>
80104be3:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
80104be6:	8b 45 cc             	mov    -0x34(%ebp),%eax
80104be9:	83 c0 01             	add    $0x1,%eax
80104bec:	01 45 d0             	add    %eax,-0x30(%ebp)
80104bef:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104bf2:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104bf5:	83 f8 01             	cmp    $0x1,%eax
80104bf8:	76 1e                	jbe    80104c18 <find_fibonacci_number+0x168>
80104bfa:	89 d1                	mov    %edx,%ecx
80104bfc:	83 f9 01             	cmp    $0x1,%ecx
80104bff:	0f 85 56 ff ff ff    	jne    80104b5b <find_fibonacci_number+0xab>
80104c05:	b8 01 00 00 00       	mov    $0x1,%eax
80104c0a:	01 45 d0             	add    %eax,-0x30(%ebp)
80104c0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104c10:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104c13:	83 f8 01             	cmp    $0x1,%eax
80104c16:	77 e2                	ja     80104bfa <find_fibonacci_number+0x14a>
80104c18:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c1b:	83 c0 01             	add    $0x1,%eax
80104c1e:	01 45 d4             	add    %eax,-0x2c(%ebp)
80104c21:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c24:	83 f8 01             	cmp    $0x1,%eax
80104c27:	0f 87 0d ff ff ff    	ja     80104b3a <find_fibonacci_number+0x8a>
80104c2d:	8b 4d b8             	mov    -0x48(%ebp),%ecx
80104c30:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104c33:	83 c0 01             	add    $0x1,%eax
80104c36:	01 45 d8             	add    %eax,-0x28(%ebp)
80104c39:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104c3c:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104c3f:	83 f8 01             	cmp    $0x1,%eax
80104c42:	76 1e                	jbe    80104c62 <find_fibonacci_number+0x1b2>
80104c44:	89 d1                	mov    %edx,%ecx
80104c46:	83 f9 01             	cmp    $0x1,%ecx
80104c49:	0f 85 df fe ff ff    	jne    80104b2e <find_fibonacci_number+0x7e>
80104c4f:	b8 01 00 00 00       	mov    $0x1,%eax
80104c54:	01 45 d8             	add    %eax,-0x28(%ebp)
80104c57:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104c5a:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104c5d:	83 f8 01             	cmp    $0x1,%eax
80104c60:	77 e2                	ja     80104c44 <find_fibonacci_number+0x194>
80104c62:	8b 45 d8             	mov    -0x28(%ebp),%eax
80104c65:	83 c0 01             	add    $0x1,%eax
80104c68:	01 45 dc             	add    %eax,-0x24(%ebp)
80104c6b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104c6e:	83 f8 01             	cmp    $0x1,%eax
80104c71:	0f 87 96 fe ff ff    	ja     80104b0d <find_fibonacci_number+0x5d>
80104c77:	8b 4d bc             	mov    -0x44(%ebp),%ecx
80104c7a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104c7d:	83 c0 01             	add    $0x1,%eax
80104c80:	01 45 e0             	add    %eax,-0x20(%ebp)
80104c83:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104c86:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104c89:	83 f8 01             	cmp    $0x1,%eax
80104c8c:	76 1e                	jbe    80104cac <find_fibonacci_number+0x1fc>
80104c8e:	89 d1                	mov    %edx,%ecx
80104c90:	83 f9 01             	cmp    $0x1,%ecx
80104c93:	0f 85 68 fe ff ff    	jne    80104b01 <find_fibonacci_number+0x51>
80104c99:	b8 01 00 00 00       	mov    $0x1,%eax
80104c9e:	01 45 e0             	add    %eax,-0x20(%ebp)
80104ca1:	8d 41 ff             	lea    -0x1(%ecx),%eax
80104ca4:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104ca7:	83 f8 01             	cmp    $0x1,%eax
80104caa:	77 e2                	ja     80104c8e <find_fibonacci_number+0x1de>
80104cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104caf:	83 c0 01             	add    $0x1,%eax
80104cb2:	01 45 e4             	add    %eax,-0x1c(%ebp)
80104cb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80104cb8:	83 f8 01             	cmp    $0x1,%eax
80104cbb:	0f 87 1f fe ff ff    	ja     80104ae0 <find_fibonacci_number+0x30>
80104cc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104cc4:	83 c0 01             	add    $0x1,%eax
    }
}
80104cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cca:	5b                   	pop    %ebx
80104ccb:	5e                   	pop    %esi
80104ccc:	5f                   	pop    %edi
80104ccd:	5d                   	pop    %ebp
80104cce:	c3                   	ret    
80104ccf:	31 db                	xor    %ebx,%ebx
    if(n > 1 && n < 4) {
80104cd1:	bf 01 00 00 00       	mov    $0x1,%edi
80104cd6:	01 7d cc             	add    %edi,-0x34(%ebp)
80104cd9:	83 fb 01             	cmp    $0x1,%ebx
80104cdc:	0f 87 85 fe ff ff    	ja     80104b67 <find_fibonacci_number+0xb7>
80104ce2:	e9 fc fe ff ff       	jmp    80104be3 <find_fibonacci_number+0x133>
80104ce7:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
80104cee:	b8 01 00 00 00       	mov    $0x1,%eax
80104cf3:	e9 26 ff ff ff       	jmp    80104c1e <find_fibonacci_number+0x16e>
80104cf8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
80104cff:	b8 01 00 00 00       	mov    $0x1,%eax
80104d04:	e9 5f ff ff ff       	jmp    80104c68 <find_fibonacci_number+0x1b8>
80104d09:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
80104d10:	b8 01 00 00 00       	mov    $0x1,%eax
80104d15:	eb 9b                	jmp    80104cb2 <find_fibonacci_number+0x202>
80104d17:	b8 01 00 00 00       	mov    $0x1,%eax
80104d1c:	eb a9                	jmp    80104cc7 <find_fibonacci_number+0x217>
    else if(n == 1) {
80104d1e:	31 c0                	xor    %eax,%eax
80104d20:	eb a5                	jmp    80104cc7 <find_fibonacci_number+0x217>
    else if (n < 1) {
80104d22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d27:	eb 9e                	jmp    80104cc7 <find_fibonacci_number+0x217>
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d30 <update_syscalls_count>:

// an array to keep how many times each system call called
int syscalls_count[NUM_OF_SYSCALLS] = {0};

void update_syscalls_count(int num){
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	8b 45 08             	mov    0x8(%ebp),%eax
    syscalls_count[num - 1] = syscalls_count[num - 1] + 1;
}
80104d36:	5d                   	pop    %ebp
    syscalls_count[num - 1] = syscalls_count[num - 1] + 1;
80104d37:	83 04 85 3c 3d 11 80 	addl   $0x1,-0x7feec2c4(,%eax,4)
80104d3e:	01 
}
80104d3f:	c3                   	ret    

80104d40 <find_most_callee>:

int find_most_callee(void){
80104d40:	55                   	push   %ebp
    int most_used_sys_call = 0;
    int max_called = -1;
    
    for(int i = 0; i < NUM_OF_SYSCALLS; i++){
80104d41:	31 c0                	xor    %eax,%eax
    int max_called = -1;
80104d43:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
int find_most_callee(void){
80104d48:	89 e5                	mov    %esp,%ebp
80104d4a:	53                   	push   %ebx
    int most_used_sys_call = 0;
80104d4b:	31 db                	xor    %ebx,%ebx
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
      if(syscalls_count[i] > max_called){
80104d50:	8b 14 85 40 3d 11 80 	mov    -0x7feec2c0(,%eax,4),%edx
        most_used_sys_call = i + 1;
80104d57:	83 c0 01             	add    $0x1,%eax
      if(syscalls_count[i] > max_called){
80104d5a:	39 ca                	cmp    %ecx,%edx
80104d5c:	7e 04                	jle    80104d62 <find_most_callee+0x22>
80104d5e:	89 d1                	mov    %edx,%ecx
        most_used_sys_call = i + 1;
80104d60:	89 c3                	mov    %eax,%ebx
    for(int i = 0; i < NUM_OF_SYSCALLS; i++){
80104d62:	83 f8 28             	cmp    $0x28,%eax
80104d65:	75 e9                	jne    80104d50 <find_most_callee+0x10>
        max_called = syscalls_count[i];
      }
    }

    return most_used_sys_call;
}
80104d67:	89 d8                	mov    %ebx,%eax
80104d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d6c:	c9                   	leave  
80104d6d:	c3                   	ret    
80104d6e:	66 90                	xchg   %ax,%ax

80104d70 <get_children_count>:

// a function to return children count of current process:
int get_children_count(void){
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
  pushcli();
80104d75:	e8 46 0c 00 00       	call   801059c0 <pushcli>
  c = mycpu();
80104d7a:	e8 f1 f0 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104d7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d85:	e8 86 0c 00 00       	call   80105a10 <popcli>
    int pid = myproc()->pid;
    struct proc *p;
    int children_count = 0;
    
    acquire(&ptable.lock);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
    int pid = myproc()->pid;
80104d8d:	8b 73 10             	mov    0x10(%ebx),%esi
    acquire(&ptable.lock);
80104d90:	68 00 3e 11 80       	push   $0x80113e00
    int children_count = 0;
80104d95:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
80104d97:	e8 74 0d 00 00       	call   80105b10 <acquire>
80104d9c:	83 c4 10             	add    $0x10,%esp

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d9f:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->parent->pid == pid){
80104da8:	8b 50 14             	mov    0x14(%eax),%edx
        children_count++;
80104dab:	39 72 10             	cmp    %esi,0x10(%edx)
80104dae:	0f 94 c2             	sete   %dl
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104db1:	05 88 00 00 00       	add    $0x88,%eax
        children_count++;
80104db6:	0f b6 d2             	movzbl %dl,%edx
80104db9:	01 d3                	add    %edx,%ebx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dbb:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104dc0:	75 e6                	jne    80104da8 <get_children_count+0x38>
      }
    }

    release(&ptable.lock);
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 00 3e 11 80       	push   $0x80113e00
80104dca:	e8 e1 0c 00 00       	call   80105ab0 <release>

    return children_count;
}
80104dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd2:	89 d8                	mov    %ebx,%eax
80104dd4:	5b                   	pop    %ebx
80104dd5:	5e                   	pop    %esi
80104dd6:	5d                   	pop    %ebp
80104dd7:	c3                   	ret    
80104dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop

80104de0 <kill_first_child_process>:

// a function to kill the first child of current process:

int kill_first_child_process(void){
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104de7:	e8 d4 0b 00 00       	call   801059c0 <pushcli>
  c = mycpu();
80104dec:	e8 7f f0 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104df1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104df7:	e8 14 0c 00 00       	call   80105a10 <popcli>
  int pid = myproc()->pid;
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dfc:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
  int pid = myproc()->pid;
80104e01:	8b 4b 10             	mov    0x10(%ebx),%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e04:	eb 16                	jmp    80104e1c <kill_first_child_process+0x3c>
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi
80104e10:	05 88 00 00 00       	add    $0x88,%eax
80104e15:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104e1a:	74 24                	je     80104e40 <kill_first_child_process+0x60>
    if(p->parent->pid == pid){
80104e1c:	8b 50 14             	mov    0x14(%eax),%edx
80104e1f:	39 4a 10             	cmp    %ecx,0x10(%edx)
80104e22:	75 ec                	jne    80104e10 <kill_first_child_process+0x30>
      kill(p->pid);
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	ff 70 10             	push   0x10(%eax)
80104e2a:	e8 41 fb ff ff       	call   80104970 <kill>
      return 1;
    }
  }
  // If parent has no child, return -1
  return -1;
}
80104e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 1;
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104e3a:	c9                   	leave  
80104e3b:	c3                   	ret    
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104e43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e48:	c9                   	leave  
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <set_proc_queue>:

void
set_proc_queue(int pid, int queue)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
80104e55:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* p;

  acquire(&ptable.lock);
80104e5b:	83 ec 0c             	sub    $0xc,%esp
80104e5e:	68 00 3e 11 80       	push   $0x80113e00
80104e63:	e8 a8 0c 00 00       	call   80105b10 <acquire>
80104e68:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e6b:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
    if(p->pid == pid){
80104e70:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e73:	75 03                	jne    80104e78 <set_proc_queue+0x28>
      p->queue = queue;
80104e75:	89 70 7c             	mov    %esi,0x7c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e78:	05 88 00 00 00       	add    $0x88,%eax
80104e7d:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104e82:	75 ec                	jne    80104e70 <set_proc_queue+0x20>
    }
  }
  release(&ptable.lock);
80104e84:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
80104e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e8e:	5b                   	pop    %ebx
80104e8f:	5e                   	pop    %esi
80104e90:	5d                   	pop    %ebp
  release(&ptable.lock);
80104e91:	e9 1a 0c 00 00       	jmp    80105ab0 <release>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi

80104ea0 <set_lottery_params>:

void 
set_lottery_params(int pid, int ticket_chance){
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 75 0c             	mov    0xc(%ebp),%esi
80104ea8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* p;
  acquire(&ptable.lock);
80104eab:	83 ec 0c             	sub    $0xc,%esp
80104eae:	68 00 3e 11 80       	push   $0x80113e00
80104eb3:	e8 58 0c 00 00       	call   80105b10 <acquire>
80104eb8:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ebb:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
    if(p->pid == pid){
80104ec0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ec3:	75 06                	jne    80104ecb <set_lottery_params+0x2b>
      p->tickets = ticket_chance;
80104ec5:	89 b0 84 00 00 00    	mov    %esi,0x84(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ecb:	05 88 00 00 00       	add    $0x88,%eax
80104ed0:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80104ed5:	75 e9                	jne    80104ec0 <set_lottery_params+0x20>
    }
  }

  release(&ptable.lock);
80104ed7:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
80104ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee1:	5b                   	pop    %ebx
80104ee2:	5e                   	pop    %esi
80104ee3:	5d                   	pop    %ebp
  release(&ptable.lock);
80104ee4:	e9 c7 0b 00 00       	jmp    80105ab0 <release>
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <digit_counter>:

int
digit_counter(int number)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ef7:	53                   	push   %ebx
  int count = 0;
  
  if(number == 0){
    return 1;
80104ef8:	bb 01 00 00 00       	mov    $0x1,%ebx
  if(number == 0){
80104efd:	85 d2                	test   %edx,%edx
80104eff:	74 20                	je     80104f21 <digit_counter+0x31>
  int count = 0;
80104f01:	bb 00 00 00 00       	mov    $0x0,%ebx
  }

  while(number > 0){
80104f06:	7e 19                	jle    80104f21 <digit_counter+0x31>
    number /= 10;
80104f08:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
80104f10:	89 d0                	mov    %edx,%eax
80104f12:	89 d1                	mov    %edx,%ecx
    count++;
80104f14:	83 c3 01             	add    $0x1,%ebx
    number /= 10;
80104f17:	f7 e6                	mul    %esi
80104f19:	c1 ea 03             	shr    $0x3,%edx
  while(number > 0){
80104f1c:	83 f9 09             	cmp    $0x9,%ecx
80104f1f:	7f ef                	jg     80104f10 <digit_counter+0x20>
  }

  return count;
}
80104f21:	89 d8                	mov    %ebx,%eax
80104f23:	5b                   	pop    %ebx
80104f24:	5e                   	pop    %esi
80104f25:	5d                   	pop    %ebp
80104f26:	c3                   	ret    
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <print_all_procs>:

void
print_all_procs()
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	57                   	push   %edi
80104f34:	56                   	push   %esi
80104f35:	53                   	push   %ebx
80104f36:	83 ec 28             	sub    $0x28,%esp
  struct proc* p;
  cprintf("name           pid         state        queue    arrive time        ticket      cycle\n");
80104f39:	68 68 91 10 80       	push   $0x80109168
80104f3e:	e8 ad b7 ff ff       	call   801006f0 <cprintf>
  cprintf(".............................................................................................\n");
80104f43:	c7 04 24 c0 91 10 80 	movl   $0x801091c0,(%esp)
80104f4a:	e8 a1 b7 ff ff       	call   801006f0 <cprintf>
  acquire(&ptable.lock);
80104f4f:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
80104f56:	e8 b5 0b 00 00       	call   80105b10 <acquire>
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f5b:	c7 45 e4 a0 3e 11 80 	movl   $0x80113ea0,-0x1c(%ebp)
80104f62:	83 c4 10             	add    $0x10,%esp
80104f65:	eb 20                	jmp    80104f87 <print_all_procs+0x57>
80104f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6e:	66 90                	xchg   %ax,%ax
80104f70:	81 45 e4 88 00 00 00 	addl   $0x88,-0x1c(%ebp)
80104f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f7a:	bf a0 60 11 80       	mov    $0x801160a0,%edi
80104f7f:	39 c7                	cmp    %eax,%edi
80104f81:	0f 84 e3 02 00 00    	je     8010526a <print_all_procs+0x33a>
    if(p->state == UNUSED){
80104f87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f8a:	8b 50 a0             	mov    -0x60(%eax),%edx
80104f8d:	85 d2                	test   %edx,%edx
80104f8f:	74 df                	je     80104f70 <print_all_procs+0x40>
      continue;
    }
    cprintf(p->name);
80104f91:	83 ec 0c             	sub    $0xc,%esp
80104f94:	89 c7                	mov    %eax,%edi
  
    for(int i = 0; i < 17 - strlen(p->name); i++){ // 15 instead 11
80104f96:	31 db                	xor    %ebx,%ebx
80104f98:	be 11 00 00 00       	mov    $0x11,%esi
    cprintf(p->name);
80104f9d:	50                   	push   %eax
80104f9e:	e8 4d b7 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 17 - strlen(p->name); i++){ // 15 instead 11
80104fa3:	83 c4 10             	add    $0x10,%esp
80104fa6:	eb 1b                	jmp    80104fc3 <print_all_procs+0x93>
80104fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop
      cprintf(" ");
80104fb0:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 17 - strlen(p->name); i++){ // 15 instead 11
80104fb3:	83 c3 01             	add    $0x1,%ebx
      cprintf(" ");
80104fb6:	68 35 91 10 80       	push   $0x80109135
80104fbb:	e8 30 b7 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 17 - strlen(p->name); i++){ // 15 instead 11
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	83 ec 0c             	sub    $0xc,%esp
80104fc6:	57                   	push   %edi
80104fc7:	e8 04 0e 00 00       	call   80105dd0 <strlen>
80104fcc:	83 c4 10             	add    $0x10,%esp
80104fcf:	89 c2                	mov    %eax,%edx
80104fd1:	89 f0                	mov    %esi,%eax
80104fd3:	29 d0                	sub    %edx,%eax
80104fd5:	39 d8                	cmp    %ebx,%eax
80104fd7:	7f d7                	jg     80104fb0 <print_all_procs+0x80>
    }

    cprintf("%d", p->pid);
80104fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104fdc:	83 ec 08             	sub    $0x8,%esp

    for(int i = 0; i < 10 - digit_counter(p->pid); i++){
80104fdf:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->pid);
80104fe1:	ff 70 a4             	push   -0x5c(%eax)
80104fe4:	68 78 90 10 80       	push   $0x80109078
80104fe9:	e8 02 b7 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 10 - digit_counter(p->pid); i++){
80104fee:	83 c4 10             	add    $0x10,%esp
80104ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ffb:	8b 50 a4             	mov    -0x5c(%eax),%edx
  if(number == 0){
80104ffe:	b8 09 00 00 00       	mov    $0x9,%eax
80105003:	85 d2                	test   %edx,%edx
80105005:	74 29                	je     80105030 <print_all_procs+0x100>
  while(number > 0){
80105007:	0f 8e 53 02 00 00    	jle    80105260 <print_all_procs+0x330>
  int count = 0;
8010500d:	31 db                	xor    %ebx,%ebx
    number /= 10;
8010500f:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105018:	89 d0                	mov    %edx,%eax
8010501a:	89 d1                	mov    %edx,%ecx
    count++;
8010501c:	83 c3 01             	add    $0x1,%ebx
    number /= 10;
8010501f:	f7 e6                	mul    %esi
80105021:	c1 ea 03             	shr    $0x3,%edx
  while(number > 0){
80105024:	83 f9 09             	cmp    $0x9,%ecx
80105027:	7f ef                	jg     80105018 <print_all_procs+0xe8>
    for(int i = 0; i < 10 - digit_counter(p->pid); i++){
80105029:	b8 0a 00 00 00       	mov    $0xa,%eax
8010502e:	29 d8                	sub    %ebx,%eax
80105030:	39 c7                	cmp    %eax,%edi
80105032:	7d 1c                	jge    80105050 <print_all_procs+0x120>
      cprintf(" ");
80105034:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 10 - digit_counter(p->pid); i++){
80105037:	83 c7 01             	add    $0x1,%edi
      cprintf(" ");
8010503a:	68 35 91 10 80       	push   $0x80109135
8010503f:	e8 ac b6 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 10 - digit_counter(p->pid); i++){
80105044:	83 c4 10             	add    $0x10,%esp
80105047:	eb af                	jmp    80104ff8 <print_all_procs+0xc8>
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    char* state = "";
    if(p->state == 0){
80105050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      state = "UNUSED";
80105053:	be 58 90 10 80       	mov    $0x80109058,%esi
    if(p->state == 0){
80105058:	8b 40 a0             	mov    -0x60(%eax),%eax
8010505b:	85 c0                	test   %eax,%eax
8010505d:	74 14                	je     80105073 <print_all_procs+0x143>
    }
    else if(p->state == 1){
8010505f:	83 e8 01             	sub    $0x1,%eax
    if(p->state == 0){
80105062:	be e0 97 10 80       	mov    $0x801097e0,%esi
80105067:	83 f8 04             	cmp    $0x4,%eax
8010506a:	77 07                	ja     80105073 <print_all_procs+0x143>
8010506c:	8b 34 85 14 93 10 80 	mov    -0x7fef6cec(,%eax,4),%esi
      state = "RUNNING";
    }
    else if(p->state == 5){
      state = "ZOMBIE";
    }
    cprintf(state);
80105073:	83 ec 0c             	sub    $0xc,%esp

    for(int i = 0; i < 12 - strlen(state); i++){
80105076:	31 db                	xor    %ebx,%ebx
80105078:	bf 0c 00 00 00       	mov    $0xc,%edi
    cprintf(state);
8010507d:	56                   	push   %esi
8010507e:	e8 6d b6 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 12 - strlen(state); i++){
80105083:	83 c4 10             	add    $0x10,%esp
80105086:	eb 1b                	jmp    801050a3 <print_all_procs+0x173>
80105088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508f:	90                   	nop
      cprintf(" ");
80105090:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 12 - strlen(state); i++){
80105093:	83 c3 01             	add    $0x1,%ebx
      cprintf(" ");
80105096:	68 35 91 10 80       	push   $0x80109135
8010509b:	e8 50 b6 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 12 - strlen(state); i++){
801050a0:	83 c4 10             	add    $0x10,%esp
801050a3:	83 ec 0c             	sub    $0xc,%esp
801050a6:	56                   	push   %esi
801050a7:	e8 24 0d 00 00       	call   80105dd0 <strlen>
801050ac:	83 c4 10             	add    $0x10,%esp
801050af:	89 c2                	mov    %eax,%edx
801050b1:	89 f8                	mov    %edi,%eax
801050b3:	29 d0                	sub    %edx,%eax
801050b5:	39 d8                	cmp    %ebx,%eax
801050b7:	7f d7                	jg     80105090 <print_all_procs+0x160>
    }

    char* queue = "";
    if(p->queue == 1){
801050b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      queue = "ROUND ROBIN";
801050bc:	be 5f 90 10 80       	mov    $0x8010905f,%esi
    if(p->queue == 1){
801050c1:	8b 40 10             	mov    0x10(%eax),%eax
801050c4:	83 f8 01             	cmp    $0x1,%eax
801050c7:	74 1a                	je     801050e3 <print_all_procs+0x1b3>
    }
    else if(p->queue == 2){
      queue = "LOTTERY";
801050c9:	be 6b 90 10 80       	mov    $0x8010906b,%esi
    else if(p->queue == 2){
801050ce:	83 f8 02             	cmp    $0x2,%eax
801050d1:	74 10                	je     801050e3 <print_all_procs+0x1b3>
    }
    else if(p->queue == 3){
      queue = "FCFS";
801050d3:	83 f8 03             	cmp    $0x3,%eax
801050d6:	be e0 97 10 80       	mov    $0x801097e0,%esi
801050db:	b8 73 90 10 80       	mov    $0x80109073,%eax
801050e0:	0f 44 f0             	cmove  %eax,%esi
    }
    cprintf(queue);
801050e3:	83 ec 0c             	sub    $0xc,%esp

    for(int i = 0; i < 12 - strlen(queue); i++){
801050e6:	31 db                	xor    %ebx,%ebx
801050e8:	bf 0c 00 00 00       	mov    $0xc,%edi
    cprintf(queue);
801050ed:	56                   	push   %esi
801050ee:	e8 fd b5 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 12 - strlen(queue); i++){
801050f3:	83 c4 10             	add    $0x10,%esp
801050f6:	eb 1b                	jmp    80105113 <print_all_procs+0x1e3>
801050f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop
      cprintf(" ");
80105100:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 12 - strlen(queue); i++){
80105103:	83 c3 01             	add    $0x1,%ebx
      cprintf(" ");
80105106:	68 35 91 10 80       	push   $0x80109135
8010510b:	e8 e0 b5 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 12 - strlen(queue); i++){
80105110:	83 c4 10             	add    $0x10,%esp
80105113:	83 ec 0c             	sub    $0xc,%esp
80105116:	56                   	push   %esi
80105117:	e8 b4 0c 00 00       	call   80105dd0 <strlen>
8010511c:	83 c4 10             	add    $0x10,%esp
8010511f:	89 c2                	mov    %eax,%edx
80105121:	89 f8                	mov    %edi,%eax
80105123:	29 d0                	sub    %edx,%eax
80105125:	39 d8                	cmp    %ebx,%eax
80105127:	7f d7                	jg     80105100 <print_all_procs+0x1d0>
    }

    cprintf("%d", p->entered_queue);
80105129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010512c:	83 ec 08             	sub    $0x8,%esp
  
    for(int i = 0; i < 20 - digit_counter(p->entered_queue); i++){
8010512f:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->entered_queue);
80105131:	ff 70 14             	push   0x14(%eax)
80105134:	68 78 90 10 80       	push   $0x80109078
80105139:	e8 b2 b5 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 20 - digit_counter(p->entered_queue); i++){
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010514b:	8b 50 14             	mov    0x14(%eax),%edx
  if(number == 0){
8010514e:	b8 13 00 00 00       	mov    $0x13,%eax
80105153:	85 d2                	test   %edx,%edx
80105155:	74 29                	je     80105180 <print_all_procs+0x250>
  while(number > 0){
80105157:	0f 8e f3 00 00 00    	jle    80105250 <print_all_procs+0x320>
  int count = 0;
8010515d:	31 db                	xor    %ebx,%ebx
    number /= 10;
8010515f:	be cd cc cc cc       	mov    $0xcccccccd,%esi
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105168:	89 d0                	mov    %edx,%eax
8010516a:	89 d1                	mov    %edx,%ecx
    count++;
8010516c:	83 c3 01             	add    $0x1,%ebx
    number /= 10;
8010516f:	f7 e6                	mul    %esi
80105171:	c1 ea 03             	shr    $0x3,%edx
  while(number > 0){
80105174:	83 f9 09             	cmp    $0x9,%ecx
80105177:	7f ef                	jg     80105168 <print_all_procs+0x238>
    for(int i = 0; i < 20 - digit_counter(p->entered_queue); i++){
80105179:	b8 14 00 00 00       	mov    $0x14,%eax
8010517e:	29 d8                	sub    %ebx,%eax
80105180:	39 c7                	cmp    %eax,%edi
80105182:	7d 1c                	jge    801051a0 <print_all_procs+0x270>
      cprintf(" ");
80105184:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 20 - digit_counter(p->entered_queue); i++){
80105187:	83 c7 01             	add    $0x1,%edi
      cprintf(" ");
8010518a:	68 35 91 10 80       	push   $0x80109135
8010518f:	e8 5c b5 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 20 - digit_counter(p->entered_queue); i++){
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	eb af                	jmp    80105148 <print_all_procs+0x218>
80105199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    cprintf("%d", p->tickets);
801051a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051a3:	83 ec 08             	sub    $0x8,%esp

    for(int i = 0; i < 11 - digit_counter(p->tickets); i++){
801051a6:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->tickets);
801051a8:	ff 70 18             	push   0x18(%eax)
801051ab:	68 78 90 10 80       	push   $0x80109078
801051b0:	e8 3b b5 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 11 - digit_counter(p->tickets); i++){
801051b5:	83 c4 10             	add    $0x10,%esp
801051b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051bf:	90                   	nop
801051c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801051c3:	8b 50 18             	mov    0x18(%eax),%edx
  if(number == 0){
801051c6:	b8 0a 00 00 00       	mov    $0xa,%eax
801051cb:	85 d2                	test   %edx,%edx
801051cd:	74 29                	je     801051f8 <print_all_procs+0x2c8>
  while(number > 0){
801051cf:	7e 77                	jle    80105248 <print_all_procs+0x318>
  int count = 0;
801051d1:	31 db                	xor    %ebx,%ebx
    number /= 10;
801051d3:	be cd cc cc cc       	mov    $0xcccccccd,%esi
801051d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051df:	90                   	nop
801051e0:	89 d0                	mov    %edx,%eax
801051e2:	89 d1                	mov    %edx,%ecx
    count++;
801051e4:	83 c3 01             	add    $0x1,%ebx
    number /= 10;
801051e7:	f7 e6                	mul    %esi
801051e9:	c1 ea 03             	shr    $0x3,%edx
  while(number > 0){
801051ec:	83 f9 09             	cmp    $0x9,%ecx
801051ef:	7f ef                	jg     801051e0 <print_all_procs+0x2b0>
    for(int i = 0; i < 11 - digit_counter(p->tickets); i++){
801051f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801051f6:	29 d8                	sub    %ebx,%eax
801051f8:	39 c7                	cmp    %eax,%edi
801051fa:	7d 1c                	jge    80105218 <print_all_procs+0x2e8>
      cprintf(" ");
801051fc:	83 ec 0c             	sub    $0xc,%esp
    for(int i = 0; i < 11 - digit_counter(p->tickets); i++){
801051ff:	83 c7 01             	add    $0x1,%edi
      cprintf(" ");
80105202:	68 35 91 10 80       	push   $0x80109135
80105207:	e8 e4 b4 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 11 - digit_counter(p->tickets); i++){
8010520c:	83 c4 10             	add    $0x10,%esp
8010520f:	eb af                	jmp    801051c0 <print_all_procs+0x290>
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    int cycle = ticks - p->entered_queue;
80105218:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    cprintf("%d", cycle);
8010521b:	83 ec 08             	sub    $0x8,%esp
    int cycle = ticks - p->entered_queue;
8010521e:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80105223:	2b 47 14             	sub    0x14(%edi),%eax
    cprintf("%d", cycle);
80105226:	50                   	push   %eax
80105227:	68 78 90 10 80       	push   $0x80109078
8010522c:	e8 bf b4 ff ff       	call   801006f0 <cprintf>

    cprintf("\n");
80105231:	c7 04 24 df 97 10 80 	movl   $0x801097df,(%esp)
80105238:	e8 b3 b4 ff ff       	call   801006f0 <cprintf>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	e9 2b fd ff ff       	jmp    80104f70 <print_all_procs+0x40>
80105245:	8d 76 00             	lea    0x0(%esi),%esi
  while(number > 0){
80105248:	b8 0b 00 00 00       	mov    $0xb,%eax
8010524d:	eb a9                	jmp    801051f8 <print_all_procs+0x2c8>
8010524f:	90                   	nop
80105250:	b8 14 00 00 00       	mov    $0x14,%eax
80105255:	e9 26 ff ff ff       	jmp    80105180 <print_all_procs+0x250>
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105260:	b8 0a 00 00 00       	mov    $0xa,%eax
80105265:	e9 c6 fd ff ff       	jmp    80105030 <print_all_procs+0x100>
  }
  
  release(&ptable.lock);
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	68 00 3e 11 80       	push   $0x80113e00
80105272:	e8 39 08 00 00       	call   80105ab0 <release>
}
80105277:	83 c4 10             	add    $0x10,%esp
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527d:	5b                   	pop    %ebx
8010527e:	5e                   	pop    %esi
8010527f:	5f                   	pop    %edi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105290 <sem_init>:

void sem_init(int i, int v_, int m_)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
80105295:	53                   	push   %ebx
80105296:	83 ec 18             	sub    $0x18,%esp
80105299:	8b 45 08             	mov    0x8(%ebp),%eax
8010529c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010529f:	8b 75 10             	mov    0x10(%ebp),%esi
  acquire(&semaphores[i].lock);
801052a2:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
801052a5:	c1 e3 06             	shl    $0x6,%ebx
801052a8:	81 c3 80 60 11 80    	add    $0x80116080,%ebx
801052ae:	53                   	push   %ebx
801052af:	e8 5c 08 00 00       	call   80105b10 <acquire>
  semaphores[i].v = v_;
801052b4:	89 bb 38 01 00 00    	mov    %edi,0x138(%ebx)
  semaphores[i].m = m_;
  semaphores[i].last = 0;
  release(&semaphores[i].lock);
801052ba:	83 c4 10             	add    $0x10,%esp
  semaphores[i].m = m_;
801052bd:	89 b3 3c 01 00 00    	mov    %esi,0x13c(%ebx)
  semaphores[i].last = 0;
801052c3:	c7 83 34 01 00 00 00 	movl   $0x0,0x134(%ebx)
801052ca:	00 00 00 
  release(&semaphores[i].lock);
801052cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801052d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d3:	5b                   	pop    %ebx
801052d4:	5e                   	pop    %esi
801052d5:	5f                   	pop    %edi
801052d6:	5d                   	pop    %ebp
  release(&semaphores[i].lock);
801052d7:	e9 d4 07 00 00       	jmp    80105ab0 <release>
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sem_acquire>:

void sem_acquire(int i)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
801052e6:	83 ec 28             	sub    $0x28,%esp
801052e9:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&semaphores[i].lock);
801052ec:	8d 34 80             	lea    (%eax,%eax,4),%esi
801052ef:	89 f3                	mov    %esi,%ebx
801052f1:	c1 e3 06             	shl    $0x6,%ebx
801052f4:	81 c3 80 60 11 80    	add    $0x80116080,%ebx
801052fa:	53                   	push   %ebx
801052fb:	e8 10 08 00 00       	call   80105b10 <acquire>
  if (semaphores[i].m < semaphores[i].v)
80105300:	8b 83 3c 01 00 00    	mov    0x13c(%ebx),%eax
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	3b 83 38 01 00 00    	cmp    0x138(%ebx),%eax
8010530f:	7d 1f                	jge    80105330 <sem_acquire+0x50>
  {
    semaphores[i].m++;
80105311:	83 c0 01             	add    $0x1,%eax
80105314:	89 83 3c 01 00 00    	mov    %eax,0x13c(%ebx)
  {
    semaphores[i].proc[semaphores[i].last] = myproc();
    semaphores[i].last++;
    sleep(myproc(), &semaphores[i].lock);
  }
  release(&semaphores[i].lock);
8010531a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010531d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105320:	5b                   	pop    %ebx
80105321:	5e                   	pop    %esi
80105322:	5f                   	pop    %edi
80105323:	5d                   	pop    %ebp
  release(&semaphores[i].lock);
80105324:	e9 87 07 00 00       	jmp    80105ab0 <release>
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    semaphores[i].proc[semaphores[i].last] = myproc();
80105330:	8b 93 34 01 00 00    	mov    0x134(%ebx),%edx
80105336:	c1 e6 04             	shl    $0x4,%esi
80105339:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  pushcli();
8010533c:	e8 7f 06 00 00       	call   801059c0 <pushcli>
  c = mycpu();
80105341:	e8 2a eb ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80105346:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010534c:	e8 bf 06 00 00       	call   80105a10 <popcli>
    semaphores[i].last++;
80105351:	83 83 34 01 00 00 01 	addl   $0x1,0x134(%ebx)
    semaphores[i].proc[semaphores[i].last] = myproc();
80105358:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010535b:	8d 44 32 0c          	lea    0xc(%edx,%esi,1),%eax
8010535f:	89 3c 85 84 60 11 80 	mov    %edi,-0x7fee9f7c(,%eax,4)
  pushcli();
80105366:	e8 55 06 00 00       	call   801059c0 <pushcli>
  c = mycpu();
8010536b:	e8 00 eb ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80105370:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80105376:	e8 95 06 00 00       	call   80105a10 <popcli>
    sleep(myproc(), &semaphores[i].lock);
8010537b:	83 ec 08             	sub    $0x8,%esp
8010537e:	53                   	push   %ebx
8010537f:	56                   	push   %esi
80105380:	e8 cb f4 ff ff       	call   80104850 <sleep>
  release(&semaphores[i].lock);
80105385:	89 5d 08             	mov    %ebx,0x8(%ebp)
    sleep(myproc(), &semaphores[i].lock);
80105388:	83 c4 10             	add    $0x10,%esp
}
8010538b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010538e:	5b                   	pop    %ebx
8010538f:	5e                   	pop    %esi
80105390:	5f                   	pop    %edi
80105391:	5d                   	pop    %ebp
  release(&semaphores[i].lock);
80105392:	e9 19 07 00 00       	jmp    80105ab0 <release>
80105397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <sem_release>:

void sem_release(int i)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
801053a6:	83 ec 28             	sub    $0x28,%esp
801053a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801053ac:	8d 1c bf             	lea    (%edi,%edi,4),%ebx
801053af:	c1 e3 06             	shl    $0x6,%ebx
  acquire(&semaphores[i].lock);
801053b2:	8d b3 80 60 11 80    	lea    -0x7fee9f80(%ebx),%esi
801053b8:	56                   	push   %esi
801053b9:	e8 52 07 00 00       	call   80105b10 <acquire>
  if (semaphores[i].m < semaphores[i].v && semaphores[i].m > 0)
801053be:	8b 86 3c 01 00 00    	mov    0x13c(%esi),%eax
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	3b 86 38 01 00 00    	cmp    0x138(%esi),%eax
801053cd:	7d 21                	jge    801053f0 <sem_release+0x50>
801053cf:	85 c0                	test   %eax,%eax
801053d1:	7e 09                	jle    801053dc <sem_release+0x3c>
  }
  else if (semaphores[i].m == semaphores[i].v)
  {
    if (semaphores[i].last == 0)
    {
      semaphores[i].m--;
801053d3:	83 e8 01             	sub    $0x1,%eax
801053d6:	89 86 3c 01 00 00    	mov    %eax,0x13c(%esi)
      for (int j = 1; j < NPROC; j++)
        semaphores[i].proc[j - 1] = semaphores[i].proc[j];
      semaphores[i].last--;
    }
  }
  release(&semaphores[i].lock);
801053dc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801053df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e2:	5b                   	pop    %ebx
801053e3:	5e                   	pop    %esi
801053e4:	5f                   	pop    %edi
801053e5:	5d                   	pop    %ebp
  release(&semaphores[i].lock);
801053e6:	e9 c5 06 00 00       	jmp    80105ab0 <release>
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
  else if (semaphores[i].m == semaphores[i].v)
801053f0:	75 ea                	jne    801053dc <sem_release+0x3c>
    if (semaphores[i].last == 0)
801053f2:	8b 96 34 01 00 00    	mov    0x134(%esi),%edx
801053f8:	85 d2                	test   %edx,%edx
801053fa:	74 d7                	je     801053d3 <sem_release+0x33>
  acquire(&ptable.lock);
801053fc:	83 ec 0c             	sub    $0xc,%esp
      wakeup(semaphores[i].proc[0]);
801053ff:	8b 56 34             	mov    0x34(%esi),%edx
  acquire(&ptable.lock);
80105402:	68 00 3e 11 80       	push   $0x80113e00
      wakeup(semaphores[i].proc[0]);
80105407:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&ptable.lock);
8010540a:	e8 01 07 00 00       	call   80105b10 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010540f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&ptable.lock);
80105412:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105415:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
8010541a:	eb 10                	jmp    8010542c <sem_release+0x8c>
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105420:	05 88 00 00 00       	add    $0x88,%eax
80105425:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010542a:	74 14                	je     80105440 <sem_release+0xa0>
    if(p->state == SLEEPING && p->chan == chan)
8010542c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105430:	75 ee                	jne    80105420 <sem_release+0x80>
80105432:	3b 50 20             	cmp    0x20(%eax),%edx
80105435:	75 e9                	jne    80105420 <sem_release+0x80>
      p->state = RUNNABLE;
80105437:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010543e:	eb e0                	jmp    80105420 <sem_release+0x80>
  release(&ptable.lock);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	68 00 3e 11 80       	push   $0x80113e00
80105448:	e8 63 06 00 00       	call   80105ab0 <release>
      for (int j = 1; j < NPROC; j++)
8010544d:	8d 83 b4 60 11 80    	lea    -0x7fee9f4c(%ebx),%eax
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	81 c3 b0 61 11 80    	add    $0x801161b0,%ebx
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        semaphores[i].proc[j - 1] = semaphores[i].proc[j];
80105460:	8b 50 04             	mov    0x4(%eax),%edx
      for (int j = 1; j < NPROC; j++)
80105463:	83 c0 04             	add    $0x4,%eax
        semaphores[i].proc[j - 1] = semaphores[i].proc[j];
80105466:	89 50 fc             	mov    %edx,-0x4(%eax)
      for (int j = 1; j < NPROC; j++)
80105469:	39 d8                	cmp    %ebx,%eax
8010546b:	75 f3                	jne    80105460 <sem_release+0xc0>
      semaphores[i].last--;
8010546d:	8d 04 bf             	lea    (%edi,%edi,4),%eax
80105470:	c1 e0 06             	shl    $0x6,%eax
80105473:	83 a8 b4 61 11 80 01 	subl   $0x1,-0x7fee9e4c(%eax)
8010547a:	e9 5d ff ff ff       	jmp    801053dc <sem_release+0x3c>
8010547f:	90                   	nop

80105480 <producer>:

void producer(int i)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	53                   	push   %ebx
80105484:	83 ec 04             	sub    $0x4,%esp
80105487:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (i < 10)
8010548a:	83 fb 09             	cmp    $0x9,%ebx
8010548d:	7f 56                	jg     801054e5 <producer+0x65>
8010548f:	90                   	nop
  {
    cprintf("produce an item %d in next produced\n", i);
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	53                   	push   %ebx
    sem_acquire(1);
    sem_acquire(0);
    cprintf("add next produced to the buffer\n");
    sem_release(0);
    sem_release(2);
    i++;
80105494:	83 c3 01             	add    $0x1,%ebx
    cprintf("produce an item %d in next produced\n", i);
80105497:	68 20 92 10 80       	push   $0x80109220
8010549c:	e8 4f b2 ff ff       	call   801006f0 <cprintf>
    sem_acquire(1);
801054a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054a8:	e8 33 fe ff ff       	call   801052e0 <sem_acquire>
    sem_acquire(0);
801054ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054b4:	e8 27 fe ff ff       	call   801052e0 <sem_acquire>
    cprintf("add next produced to the buffer\n");
801054b9:	c7 04 24 48 92 10 80 	movl   $0x80109248,(%esp)
801054c0:	e8 2b b2 ff ff       	call   801006f0 <cprintf>
    sem_release(0);
801054c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054cc:	e8 cf fe ff ff       	call   801053a0 <sem_release>
    sem_release(2);
801054d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054d8:	e8 c3 fe ff ff       	call   801053a0 <sem_release>
  while (i < 10)
801054dd:	83 c4 10             	add    $0x10,%esp
801054e0:	83 fb 0a             	cmp    $0xa,%ebx
801054e3:	75 ab                	jne    80105490 <producer+0x10>
  }
}
801054e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801054e8:	c9                   	leave  
801054e9:	c3                   	ret    
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054f0 <consumer>:

void consumer(int i)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 04             	sub    $0x4,%esp
801054f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while (i < 10)
801054fa:	83 fb 09             	cmp    $0x9,%ebx
801054fd:	7f 53                	jg     80105552 <consumer+0x62>
801054ff:	90                   	nop
  {
    sem_acquire(2);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	6a 02                	push   $0x2
80105505:	e8 d6 fd ff ff       	call   801052e0 <sem_acquire>
    sem_acquire(0);
8010550a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105511:	e8 ca fd ff ff       	call   801052e0 <sem_acquire>
    cprintf("remove an item from buffer to next consumed\n");
80105516:	c7 04 24 6c 92 10 80 	movl   $0x8010926c,(%esp)
8010551d:	e8 ce b1 ff ff       	call   801006f0 <cprintf>
    sem_release(0);
80105522:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105529:	e8 72 fe ff ff       	call   801053a0 <sem_release>
    sem_release(1);
8010552e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105535:	e8 66 fe ff ff       	call   801053a0 <sem_release>
    cprintf("consume the item %d in next consumed\n", i);
8010553a:	58                   	pop    %eax
8010553b:	5a                   	pop    %edx
8010553c:	53                   	push   %ebx
8010553d:	68 9c 92 10 80       	push   $0x8010929c
    i++;
80105542:	83 c3 01             	add    $0x1,%ebx
    cprintf("consume the item %d in next consumed\n", i);
80105545:	e8 a6 b1 ff ff       	call   801006f0 <cprintf>
  while (i < 10)
8010554a:	83 c4 10             	add    $0x10,%esp
8010554d:	83 fb 0a             	cmp    $0xa,%ebx
80105550:	75 ae                	jne    80105500 <consumer+0x10>
  }
}
80105552:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010555e:	66 90                	xchg   %ax,%ax

80105560 <to_sleep>:

void to_sleep(void *chan)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
80105565:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80105568:	e8 53 04 00 00       	call   801059c0 <pushcli>
  c = mycpu();
8010556d:	e8 fe e8 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80105572:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80105578:	e8 93 04 00 00       	call   80105a10 <popcli>
  struct proc *p = myproc();

  if (p == 0)
8010557d:	85 db                	test   %ebx,%ebx
8010557f:	74 38                	je     801055b9 <to_sleep+0x59>
    panic("sleep");

  acquire(&ptable.lock);
80105581:	83 ec 0c             	sub    $0xc,%esp
80105584:	68 00 3e 11 80       	push   $0x80113e00
80105589:	e8 82 05 00 00       	call   80105b10 <acquire>

  p->chan = chan;
8010558e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80105591:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80105598:	e8 43 ef ff ff       	call   801044e0 <sched>

  p->chan = 0;
8010559d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  release(&ptable.lock);
801055a4:	83 c4 10             	add    $0x10,%esp
801055a7:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
}
801055ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055b1:	5b                   	pop    %ebx
801055b2:	5e                   	pop    %esi
801055b3:	5d                   	pop    %ebp
  release(&ptable.lock);
801055b4:	e9 f7 04 00 00       	jmp    80105ab0 <release>
    panic("sleep");
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	68 34 90 10 80       	push   $0x80109034
801055c1:	e8 ba ad ff ff       	call   80100380 <panic>
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi

801055d0 <cv_wait>:

void cv_wait(void *condvar)
{
  to_sleep(condvar);
801055d0:	eb 8e                	jmp    80105560 <to_sleep>
801055d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055e0 <cv_signal>:
}

void cv_signal(void *condvar)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
801055e4:	83 ec 10             	sub    $0x10,%esp
801055e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801055ea:	68 00 3e 11 80       	push   $0x80113e00
801055ef:	e8 1c 05 00 00       	call   80105b10 <acquire>
801055f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801055f7:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
801055fc:	eb 0e                	jmp    8010560c <cv_signal+0x2c>
801055fe:	66 90                	xchg   %ax,%ax
80105600:	05 88 00 00 00       	add    $0x88,%eax
80105605:	3d 34 60 11 80       	cmp    $0x80116034,%eax
8010560a:	74 1e                	je     8010562a <cv_signal+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010560c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105610:	75 ee                	jne    80105600 <cv_signal+0x20>
80105612:	3b 58 20             	cmp    0x20(%eax),%ebx
80105615:	75 e9                	jne    80105600 <cv_signal+0x20>
      p->state = RUNNABLE;
80105617:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010561e:	05 88 00 00 00       	add    $0x88,%eax
80105623:	3d 34 60 11 80       	cmp    $0x80116034,%eax
80105628:	75 e2                	jne    8010560c <cv_signal+0x2c>
  release(&ptable.lock);
8010562a:	c7 45 08 00 3e 11 80 	movl   $0x80113e00,0x8(%ebp)
  wakeup(condvar);
}
80105631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105634:	c9                   	leave  
  release(&ptable.lock);
80105635:	e9 76 04 00 00       	jmp    80105ab0 <release>
8010563a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105640 <reader>:

int test_variable = 0;

void reader(int i, void *condvar)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
80105644:	83 ec 0c             	sub    $0xc,%esp
80105647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  readers_cnt++;
8010564a:	83 05 e4 3d 11 80 01 	addl   $0x1,0x80113de4
  cprintf("reader %d init\n", i);
80105651:	53                   	push   %ebx
80105652:	68 7b 90 10 80       	push   $0x8010907b
80105657:	e8 94 b0 ff ff       	call   801006f0 <cprintf>
  if (writers_cnt)
8010565c:	8b 0d e0 3d 11 80    	mov    0x80113de0,%ecx
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c9                	test   %ecx,%ecx
80105667:	0f 85 82 00 00 00    	jne    801056ef <reader+0xaf>
  {
    cv_wait(&condvar);
  }
  cprintf("reader %d reads one item from buffer\n", i);
8010566d:	83 ec 08             	sub    $0x8,%esp
80105670:	53                   	push   %ebx
80105671:	68 c4 92 10 80       	push   $0x801092c4
80105676:	e8 75 b0 ff ff       	call   801006f0 <cprintf>
  cprintf("number of active readers: %d\n", readers_cnt);
8010567b:	58                   	pop    %eax
8010567c:	5a                   	pop    %edx
8010567d:	ff 35 e4 3d 11 80    	push   0x80113de4
80105683:	68 8b 90 10 80       	push   $0x8010908b
80105688:	e8 63 b0 ff ff       	call   801006f0 <cprintf>
  acquire(&ptable.lock);
8010568d:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
  readers_cnt--;
80105694:	83 2d e4 3d 11 80 01 	subl   $0x1,0x80113de4
  acquire(&ptable.lock);
8010569b:	e8 70 04 00 00       	call   80105b10 <acquire>
801056a0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801056a3:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
    if(p->state == SLEEPING && p->chan == chan)
801056a8:	8d 55 0c             	lea    0xc(%ebp),%edx
801056ab:	eb 0f                	jmp    801056bc <reader+0x7c>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801056b0:	05 88 00 00 00       	add    $0x88,%eax
801056b5:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801056ba:	74 1e                	je     801056da <reader+0x9a>
    if(p->state == SLEEPING && p->chan == chan)
801056bc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801056c0:	75 ee                	jne    801056b0 <reader+0x70>
801056c2:	39 50 20             	cmp    %edx,0x20(%eax)
801056c5:	75 e9                	jne    801056b0 <reader+0x70>
      p->state = RUNNABLE;
801056c7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801056ce:	05 88 00 00 00       	add    $0x88,%eax
801056d3:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801056d8:	75 e2                	jne    801056bc <reader+0x7c>
  release(&ptable.lock);
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	68 00 3e 11 80       	push   $0x80113e00
801056e2:	e8 c9 03 00 00       	call   80105ab0 <release>
  cv_signal(&condvar);
}
801056e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    
  to_sleep(condvar);
801056ef:	83 ec 0c             	sub    $0xc,%esp
801056f2:	8d 45 0c             	lea    0xc(%ebp),%eax
801056f5:	50                   	push   %eax
801056f6:	e8 65 fe ff ff       	call   80105560 <to_sleep>
}
801056fb:	83 c4 10             	add    $0x10,%esp
801056fe:	e9 6a ff ff ff       	jmp    8010566d <reader+0x2d>
80105703:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105710 <writer>:

void writer(int i, void *condvar)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
80105714:	83 ec 0c             	sub    $0xc,%esp
  cprintf("readers: %d\n", readers_cnt);
80105717:	ff 35 e4 3d 11 80    	push   0x80113de4
{
8010571d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("readers: %d\n", readers_cnt);
80105720:	68 9c 90 10 80       	push   $0x8010909c
80105725:	e8 c6 af ff ff       	call   801006f0 <cprintf>
  cprintf("writer %d init\n", i);
8010572a:	58                   	pop    %eax
8010572b:	5a                   	pop    %edx
8010572c:	53                   	push   %ebx
8010572d:	68 a9 90 10 80       	push   $0x801090a9
80105732:	e8 b9 af ff ff       	call   801006f0 <cprintf>
  if (readers_cnt || writers_cnt)
80105737:	a1 e4 3d 11 80       	mov    0x80113de4,%eax
8010573c:	83 c4 10             	add    $0x10,%esp
8010573f:	0b 05 e0 3d 11 80    	or     0x80113de0,%eax
80105745:	74 14                	je     8010575b <writer+0x4b>
  to_sleep(condvar);
80105747:	83 ec 0c             	sub    $0xc,%esp
8010574a:	8d 45 0c             	lea    0xc(%ebp),%eax
8010574d:	50                   	push   %eax
8010574e:	e8 0d fe ff ff       	call   80105560 <to_sleep>
  {
    cv_wait(&condvar);
  }
  writers_cnt++;
80105753:	a1 e0 3d 11 80       	mov    0x80113de0,%eax
}
80105758:	83 c4 10             	add    $0x10,%esp
  writers_cnt++;
8010575b:	83 c0 01             	add    $0x1,%eax
  test_variable++;
  cprintf("test varibale is %d\n", test_variable);
8010575e:	83 ec 08             	sub    $0x8,%esp
  writers_cnt++;
80105761:	a3 e0 3d 11 80       	mov    %eax,0x80113de0
  test_variable++;
80105766:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010576b:	83 c0 01             	add    $0x1,%eax
  cprintf("test varibale is %d\n", test_variable);
8010576e:	50                   	push   %eax
8010576f:	68 b9 90 10 80       	push   $0x801090b9
  test_variable++;
80105774:	a3 20 3d 11 80       	mov    %eax,0x80113d20
  cprintf("test varibale is %d\n", test_variable);
80105779:	e8 72 af ff ff       	call   801006f0 <cprintf>
  cprintf("writer %d writes next item in buffer\n", i);
8010577e:	58                   	pop    %eax
8010577f:	5a                   	pop    %edx
80105780:	53                   	push   %ebx
80105781:	68 ec 92 10 80       	push   $0x801092ec
80105786:	e8 65 af ff ff       	call   801006f0 <cprintf>
  cprintf("number of active writers: %d\n", writers_cnt);
8010578b:	59                   	pop    %ecx
8010578c:	5b                   	pop    %ebx
8010578d:	ff 35 e0 3d 11 80    	push   0x80113de0
80105793:	68 ce 90 10 80       	push   $0x801090ce
80105798:	e8 53 af ff ff       	call   801006f0 <cprintf>
  acquire(&ptable.lock);
8010579d:	c7 04 24 00 3e 11 80 	movl   $0x80113e00,(%esp)
  writers_cnt--;
801057a4:	83 2d e0 3d 11 80 01 	subl   $0x1,0x80113de0
  acquire(&ptable.lock);
801057ab:	e8 60 03 00 00       	call   80105b10 <acquire>
801057b0:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801057b3:	b8 34 3e 11 80       	mov    $0x80113e34,%eax
    if(p->state == SLEEPING && p->chan == chan)
801057b8:	8d 55 0c             	lea    0xc(%ebp),%edx
801057bb:	eb 0f                	jmp    801057cc <writer+0xbc>
801057bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801057c0:	05 88 00 00 00       	add    $0x88,%eax
801057c5:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801057ca:	74 1e                	je     801057ea <writer+0xda>
    if(p->state == SLEEPING && p->chan == chan)
801057cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801057d0:	75 ee                	jne    801057c0 <writer+0xb0>
801057d2:	39 50 20             	cmp    %edx,0x20(%eax)
801057d5:	75 e9                	jne    801057c0 <writer+0xb0>
      p->state = RUNNABLE;
801057d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801057de:	05 88 00 00 00       	add    $0x88,%eax
801057e3:	3d 34 60 11 80       	cmp    $0x80116034,%eax
801057e8:	75 e2                	jne    801057cc <writer+0xbc>
  release(&ptable.lock);
801057ea:	83 ec 0c             	sub    $0xc,%esp
801057ed:	68 00 3e 11 80       	push   $0x80113e00
801057f2:	e8 b9 02 00 00       	call   80105ab0 <release>
  cv_signal(&condvar);
801057f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057fa:	83 c4 10             	add    $0x10,%esp
801057fd:	c9                   	leave  
801057fe:	c3                   	ret    
801057ff:	90                   	nop

80105800 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	53                   	push   %ebx
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010580a:	68 40 93 10 80       	push   $0x80109340
8010580f:	8d 43 04             	lea    0x4(%ebx),%eax
80105812:	50                   	push   %eax
80105813:	e8 28 01 00 00       	call   80105940 <initlock>
  lk->name = name;
80105818:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010581b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105821:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105824:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010582b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010582e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105831:	c9                   	leave  
80105832:	c3                   	ret    
80105833:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	56                   	push   %esi
80105844:	53                   	push   %ebx
80105845:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105848:	8d 73 04             	lea    0x4(%ebx),%esi
8010584b:	83 ec 0c             	sub    $0xc,%esp
8010584e:	56                   	push   %esi
8010584f:	e8 bc 02 00 00       	call   80105b10 <acquire>
  while (lk->locked) {
80105854:	8b 13                	mov    (%ebx),%edx
80105856:	83 c4 10             	add    $0x10,%esp
80105859:	85 d2                	test   %edx,%edx
8010585b:	74 16                	je     80105873 <acquiresleep+0x33>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105860:	83 ec 08             	sub    $0x8,%esp
80105863:	56                   	push   %esi
80105864:	53                   	push   %ebx
80105865:	e8 e6 ef ff ff       	call   80104850 <sleep>
  while (lk->locked) {
8010586a:	8b 03                	mov    (%ebx),%eax
8010586c:	83 c4 10             	add    $0x10,%esp
8010586f:	85 c0                	test   %eax,%eax
80105871:	75 ed                	jne    80105860 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105873:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105879:	e8 72 e6 ff ff       	call   80103ef0 <myproc>
8010587e:	8b 40 10             	mov    0x10(%eax),%eax
80105881:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105884:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105887:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010588a:	5b                   	pop    %ebx
8010588b:	5e                   	pop    %esi
8010588c:	5d                   	pop    %ebp
  release(&lk->lk);
8010588d:	e9 1e 02 00 00       	jmp    80105ab0 <release>
80105892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
801058a5:	53                   	push   %ebx
801058a6:	83 ec 18             	sub    $0x18,%esp
801058a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801058ac:	8d 73 04             	lea    0x4(%ebx),%esi
801058af:	56                   	push   %esi
801058b0:	e8 5b 02 00 00       	call   80105b10 <acquire>

  if (lk->pid != myproc()->pid) {
801058b5:	8b 7b 3c             	mov    0x3c(%ebx),%edi
801058b8:	e8 33 e6 ff ff       	call   80103ef0 <myproc>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	3b 78 10             	cmp    0x10(%eax),%edi
801058c3:	75 19                	jne    801058de <releasesleep+0x3e>
    return;
  }

  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
801058c5:	83 ec 0c             	sub    $0xc,%esp
  lk->locked = 0;
801058c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801058ce:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801058d5:	53                   	push   %ebx
801058d6:	e8 35 f0 ff ff       	call   80104910 <wakeup>
  release(&lk->lk);
801058db:	83 c4 10             	add    $0x10,%esp
801058de:	89 75 08             	mov    %esi,0x8(%ebp)
}
801058e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058e4:	5b                   	pop    %ebx
801058e5:	5e                   	pop    %esi
801058e6:	5f                   	pop    %edi
801058e7:	5d                   	pop    %ebp
  release(&lk->lk);
801058e8:	e9 c3 01 00 00       	jmp    80105ab0 <release>
801058ed:	8d 76 00             	lea    0x0(%esi),%esi

801058f0 <holdingsleep>:


int
holdingsleep(struct sleeplock *lk)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	57                   	push   %edi
801058f4:	31 ff                	xor    %edi,%edi
801058f6:	56                   	push   %esi
801058f7:	53                   	push   %ebx
801058f8:	83 ec 18             	sub    $0x18,%esp
801058fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801058fe:	8d 73 04             	lea    0x4(%ebx),%esi
80105901:	56                   	push   %esi
80105902:	e8 09 02 00 00       	call   80105b10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105907:	8b 03                	mov    (%ebx),%eax
80105909:	83 c4 10             	add    $0x10,%esp
8010590c:	85 c0                	test   %eax,%eax
8010590e:	75 18                	jne    80105928 <holdingsleep+0x38>
  release(&lk->lk);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	56                   	push   %esi
80105914:	e8 97 01 00 00       	call   80105ab0 <release>
  return r;
}
80105919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010591c:	89 f8                	mov    %edi,%eax
8010591e:	5b                   	pop    %ebx
8010591f:	5e                   	pop    %esi
80105920:	5f                   	pop    %edi
80105921:	5d                   	pop    %ebp
80105922:	c3                   	ret    
80105923:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105927:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80105928:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010592b:	e8 c0 e5 ff ff       	call   80103ef0 <myproc>
80105930:	39 58 10             	cmp    %ebx,0x10(%eax)
80105933:	0f 94 c0             	sete   %al
80105936:	0f b6 c0             	movzbl %al,%eax
80105939:	89 c7                	mov    %eax,%edi
8010593b:	eb d3                	jmp    80105910 <holdingsleep+0x20>
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105946:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010594f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105959:	5d                   	pop    %ebp
8010595a:	c3                   	ret    
8010595b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop

80105960 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105960:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105961:	31 d2                	xor    %edx,%edx
{
80105963:	89 e5                	mov    %esp,%ebp
80105965:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105966:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010596c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010596f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105970:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105976:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010597c:	77 1a                	ja     80105998 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010597e:	8b 58 04             	mov    0x4(%eax),%ebx
80105981:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105984:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105987:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105989:	83 fa 0a             	cmp    $0xa,%edx
8010598c:	75 e2                	jne    80105970 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010598e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105991:	c9                   	leave  
80105992:	c3                   	ret    
80105993:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105997:	90                   	nop
  for(; i < 10; i++)
80105998:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010599b:	8d 51 28             	lea    0x28(%ecx),%edx
8010599e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801059a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801059a6:	83 c0 04             	add    $0x4,%eax
801059a9:	39 d0                	cmp    %edx,%eax
801059ab:	75 f3                	jne    801059a0 <getcallerpcs+0x40>
}
801059ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059b0:	c9                   	leave  
801059b1:	c3                   	ret    
801059b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	53                   	push   %ebx
801059c4:	83 ec 04             	sub    $0x4,%esp
801059c7:	9c                   	pushf  
801059c8:	5b                   	pop    %ebx
  asm volatile("cli");
801059c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801059ca:	e8 a1 e4 ff ff       	call   80103e70 <mycpu>
801059cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 17                	je     801059f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801059d9:	e8 92 e4 ff ff       	call   80103e70 <mycpu>
801059de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801059e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059e8:	c9                   	leave  
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801059f0:	e8 7b e4 ff ff       	call   80103e70 <mycpu>
801059f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801059fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105a01:	eb d6                	jmp    801059d9 <pushcli+0x19>
80105a03:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a10 <popcli>:

void
popcli(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105a16:	9c                   	pushf  
80105a17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105a18:	f6 c4 02             	test   $0x2,%ah
80105a1b:	75 35                	jne    80105a52 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105a1d:	e8 4e e4 ff ff       	call   80103e70 <mycpu>
80105a22:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105a29:	78 34                	js     80105a5f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105a2b:	e8 40 e4 ff ff       	call   80103e70 <mycpu>
80105a30:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105a36:	85 d2                	test   %edx,%edx
80105a38:	74 06                	je     80105a40 <popcli+0x30>
    sti();
}
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105a40:	e8 2b e4 ff ff       	call   80103e70 <mycpu>
80105a45:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105a4b:	85 c0                	test   %eax,%eax
80105a4d:	74 eb                	je     80105a3a <popcli+0x2a>
  asm volatile("sti");
80105a4f:	fb                   	sti    
}
80105a50:	c9                   	leave  
80105a51:	c3                   	ret    
    panic("popcli - interruptible");
80105a52:	83 ec 0c             	sub    $0xc,%esp
80105a55:	68 4b 93 10 80       	push   $0x8010934b
80105a5a:	e8 21 a9 ff ff       	call   80100380 <panic>
    panic("popcli");
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	68 62 93 10 80       	push   $0x80109362
80105a67:	e8 14 a9 ff ff       	call   80100380 <panic>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <holding>:
{
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	56                   	push   %esi
80105a74:	53                   	push   %ebx
80105a75:	8b 75 08             	mov    0x8(%ebp),%esi
80105a78:	31 db                	xor    %ebx,%ebx
  pushcli();
80105a7a:	e8 41 ff ff ff       	call   801059c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105a7f:	8b 06                	mov    (%esi),%eax
80105a81:	85 c0                	test   %eax,%eax
80105a83:	75 0b                	jne    80105a90 <holding+0x20>
  popcli();
80105a85:	e8 86 ff ff ff       	call   80105a10 <popcli>
}
80105a8a:	89 d8                	mov    %ebx,%eax
80105a8c:	5b                   	pop    %ebx
80105a8d:	5e                   	pop    %esi
80105a8e:	5d                   	pop    %ebp
80105a8f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105a90:	8b 5e 08             	mov    0x8(%esi),%ebx
80105a93:	e8 d8 e3 ff ff       	call   80103e70 <mycpu>
80105a98:	39 c3                	cmp    %eax,%ebx
80105a9a:	0f 94 c3             	sete   %bl
  popcli();
80105a9d:	e8 6e ff ff ff       	call   80105a10 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105aa2:	0f b6 db             	movzbl %bl,%ebx
}
80105aa5:	89 d8                	mov    %ebx,%eax
80105aa7:	5b                   	pop    %ebx
80105aa8:	5e                   	pop    %esi
80105aa9:	5d                   	pop    %ebp
80105aaa:	c3                   	ret    
80105aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aaf:	90                   	nop

80105ab0 <release>:
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105ab8:	e8 03 ff ff ff       	call   801059c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105abd:	8b 03                	mov    (%ebx),%eax
80105abf:	85 c0                	test   %eax,%eax
80105ac1:	75 15                	jne    80105ad8 <release+0x28>
  popcli();
80105ac3:	e8 48 ff ff ff       	call   80105a10 <popcli>
    panic("release");
80105ac8:	83 ec 0c             	sub    $0xc,%esp
80105acb:	68 69 93 10 80       	push   $0x80109369
80105ad0:	e8 ab a8 ff ff       	call   80100380 <panic>
80105ad5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105ad8:	8b 73 08             	mov    0x8(%ebx),%esi
80105adb:	e8 90 e3 ff ff       	call   80103e70 <mycpu>
80105ae0:	39 c6                	cmp    %eax,%esi
80105ae2:	75 df                	jne    80105ac3 <release+0x13>
  popcli();
80105ae4:	e8 27 ff ff ff       	call   80105a10 <popcli>
  lk->pcs[0] = 0;
80105ae9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105af0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105af7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105afc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b05:	5b                   	pop    %ebx
80105b06:	5e                   	pop    %esi
80105b07:	5d                   	pop    %ebp
  popcli();
80105b08:	e9 03 ff ff ff       	jmp    80105a10 <popcli>
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi

80105b10 <acquire>:
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	53                   	push   %ebx
80105b14:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105b17:	e8 a4 fe ff ff       	call   801059c0 <pushcli>
  if(holding(lk))
80105b1c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105b1f:	e8 9c fe ff ff       	call   801059c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105b24:	8b 03                	mov    (%ebx),%eax
80105b26:	85 c0                	test   %eax,%eax
80105b28:	75 7e                	jne    80105ba8 <acquire+0x98>
  popcli();
80105b2a:	e8 e1 fe ff ff       	call   80105a10 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80105b2f:	b9 01 00 00 00       	mov    $0x1,%ecx
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80105b38:	8b 55 08             	mov    0x8(%ebp),%edx
80105b3b:	89 c8                	mov    %ecx,%eax
80105b3d:	f0 87 02             	lock xchg %eax,(%edx)
80105b40:	85 c0                	test   %eax,%eax
80105b42:	75 f4                	jne    80105b38 <acquire+0x28>
  __sync_synchronize();
80105b44:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105b4c:	e8 1f e3 ff ff       	call   80103e70 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80105b54:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80105b56:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80105b59:	31 c0                	xor    %eax,%eax
80105b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105b60:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80105b66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105b6c:	77 1a                	ja     80105b88 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80105b6e:	8b 5a 04             	mov    0x4(%edx),%ebx
80105b71:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80105b75:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80105b78:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80105b7a:	83 f8 0a             	cmp    $0xa,%eax
80105b7d:	75 e1                	jne    80105b60 <acquire+0x50>
}
80105b7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b82:	c9                   	leave  
80105b83:	c3                   	ret    
80105b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105b88:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80105b8c:	8d 51 34             	lea    0x34(%ecx),%edx
80105b8f:	90                   	nop
    pcs[i] = 0;
80105b90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105b96:	83 c0 04             	add    $0x4,%eax
80105b99:	39 c2                	cmp    %eax,%edx
80105b9b:	75 f3                	jne    80105b90 <acquire+0x80>
}
80105b9d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ba0:	c9                   	leave  
80105ba1:	c3                   	ret    
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105ba8:	8b 5b 08             	mov    0x8(%ebx),%ebx
80105bab:	e8 c0 e2 ff ff       	call   80103e70 <mycpu>
80105bb0:	39 c3                	cmp    %eax,%ebx
80105bb2:	0f 85 72 ff ff ff    	jne    80105b2a <acquire+0x1a>
  popcli();
80105bb8:	e8 53 fe ff ff       	call   80105a10 <popcli>
    panic("acquire");
80105bbd:	83 ec 0c             	sub    $0xc,%esp
80105bc0:	68 71 93 10 80       	push   $0x80109371
80105bc5:	e8 b6 a7 ff ff       	call   80100380 <panic>
80105bca:	66 90                	xchg   %ax,%ax
80105bcc:	66 90                	xchg   %ax,%ax
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	8b 55 08             	mov    0x8(%ebp),%edx
80105bd7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105bda:	53                   	push   %ebx
80105bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105bde:	89 d7                	mov    %edx,%edi
80105be0:	09 cf                	or     %ecx,%edi
80105be2:	83 e7 03             	and    $0x3,%edi
80105be5:	75 29                	jne    80105c10 <memset+0x40>
    c &= 0xFF;
80105be7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105bea:	c1 e0 18             	shl    $0x18,%eax
80105bed:	89 fb                	mov    %edi,%ebx
80105bef:	c1 e9 02             	shr    $0x2,%ecx
80105bf2:	c1 e3 10             	shl    $0x10,%ebx
80105bf5:	09 d8                	or     %ebx,%eax
80105bf7:	09 f8                	or     %edi,%eax
80105bf9:	c1 e7 08             	shl    $0x8,%edi
80105bfc:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80105bfe:	89 d7                	mov    %edx,%edi
80105c00:	fc                   	cld    
80105c01:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105c03:	5b                   	pop    %ebx
80105c04:	89 d0                	mov    %edx,%eax
80105c06:	5f                   	pop    %edi
80105c07:	5d                   	pop    %ebp
80105c08:	c3                   	ret    
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105c10:	89 d7                	mov    %edx,%edi
80105c12:	fc                   	cld    
80105c13:	f3 aa                	rep stos %al,%es:(%edi)
80105c15:	5b                   	pop    %ebx
80105c16:	89 d0                	mov    %edx,%eax
80105c18:	5f                   	pop    %edi
80105c19:	5d                   	pop    %ebp
80105c1a:	c3                   	ret    
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	56                   	push   %esi
80105c24:	8b 75 10             	mov    0x10(%ebp),%esi
80105c27:	8b 55 08             	mov    0x8(%ebp),%edx
80105c2a:	53                   	push   %ebx
80105c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105c2e:	85 f6                	test   %esi,%esi
80105c30:	74 2e                	je     80105c60 <memcmp+0x40>
80105c32:	01 c6                	add    %eax,%esi
80105c34:	eb 14                	jmp    80105c4a <memcmp+0x2a>
80105c36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105c40:	83 c0 01             	add    $0x1,%eax
80105c43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105c46:	39 f0                	cmp    %esi,%eax
80105c48:	74 16                	je     80105c60 <memcmp+0x40>
    if(*s1 != *s2)
80105c4a:	0f b6 0a             	movzbl (%edx),%ecx
80105c4d:	0f b6 18             	movzbl (%eax),%ebx
80105c50:	38 d9                	cmp    %bl,%cl
80105c52:	74 ec                	je     80105c40 <memcmp+0x20>
      return *s1 - *s2;
80105c54:	0f b6 c1             	movzbl %cl,%eax
80105c57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105c59:	5b                   	pop    %ebx
80105c5a:	5e                   	pop    %esi
80105c5b:	5d                   	pop    %ebp
80105c5c:	c3                   	ret    
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi
80105c60:	5b                   	pop    %ebx
  return 0;
80105c61:	31 c0                	xor    %eax,%eax
}
80105c63:	5e                   	pop    %esi
80105c64:	5d                   	pop    %ebp
80105c65:	c3                   	ret    
80105c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6d:	8d 76 00             	lea    0x0(%esi),%esi

80105c70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	8b 55 08             	mov    0x8(%ebp),%edx
80105c77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105c7a:	56                   	push   %esi
80105c7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105c7e:	39 d6                	cmp    %edx,%esi
80105c80:	73 26                	jae    80105ca8 <memmove+0x38>
80105c82:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105c85:	39 fa                	cmp    %edi,%edx
80105c87:	73 1f                	jae    80105ca8 <memmove+0x38>
80105c89:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105c8c:	85 c9                	test   %ecx,%ecx
80105c8e:	74 0c                	je     80105c9c <memmove+0x2c>
      *--d = *--s;
80105c90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105c94:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105c97:	83 e8 01             	sub    $0x1,%eax
80105c9a:	73 f4                	jae    80105c90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105c9c:	5e                   	pop    %esi
80105c9d:	89 d0                	mov    %edx,%eax
80105c9f:	5f                   	pop    %edi
80105ca0:	5d                   	pop    %ebp
80105ca1:	c3                   	ret    
80105ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105ca8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105cab:	89 d7                	mov    %edx,%edi
80105cad:	85 c9                	test   %ecx,%ecx
80105caf:	74 eb                	je     80105c9c <memmove+0x2c>
80105cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105cb8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105cb9:	39 c6                	cmp    %eax,%esi
80105cbb:	75 fb                	jne    80105cb8 <memmove+0x48>
}
80105cbd:	5e                   	pop    %esi
80105cbe:	89 d0                	mov    %edx,%eax
80105cc0:	5f                   	pop    %edi
80105cc1:	5d                   	pop    %ebp
80105cc2:	c3                   	ret    
80105cc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105cd0:	eb 9e                	jmp    80105c70 <memmove>
80105cd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	56                   	push   %esi
80105ce4:	8b 75 10             	mov    0x10(%ebp),%esi
80105ce7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105cea:	53                   	push   %ebx
80105ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80105cee:	85 f6                	test   %esi,%esi
80105cf0:	74 2e                	je     80105d20 <strncmp+0x40>
80105cf2:	01 d6                	add    %edx,%esi
80105cf4:	eb 18                	jmp    80105d0e <strncmp+0x2e>
80105cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi
80105d00:	38 d8                	cmp    %bl,%al
80105d02:	75 14                	jne    80105d18 <strncmp+0x38>
    n--, p++, q++;
80105d04:	83 c2 01             	add    $0x1,%edx
80105d07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105d0a:	39 f2                	cmp    %esi,%edx
80105d0c:	74 12                	je     80105d20 <strncmp+0x40>
80105d0e:	0f b6 01             	movzbl (%ecx),%eax
80105d11:	0f b6 1a             	movzbl (%edx),%ebx
80105d14:	84 c0                	test   %al,%al
80105d16:	75 e8                	jne    80105d00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105d18:	29 d8                	sub    %ebx,%eax
}
80105d1a:	5b                   	pop    %ebx
80105d1b:	5e                   	pop    %esi
80105d1c:	5d                   	pop    %ebp
80105d1d:	c3                   	ret    
80105d1e:	66 90                	xchg   %ax,%ax
80105d20:	5b                   	pop    %ebx
    return 0;
80105d21:	31 c0                	xor    %eax,%eax
}
80105d23:	5e                   	pop    %esi
80105d24:	5d                   	pop    %ebp
80105d25:	c3                   	ret    
80105d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi

80105d30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	8b 75 08             	mov    0x8(%ebp),%esi
80105d38:	53                   	push   %ebx
80105d39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105d3c:	89 f0                	mov    %esi,%eax
80105d3e:	eb 15                	jmp    80105d55 <strncpy+0x25>
80105d40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105d44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105d47:	83 c0 01             	add    $0x1,%eax
80105d4a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80105d4e:	88 50 ff             	mov    %dl,-0x1(%eax)
80105d51:	84 d2                	test   %dl,%dl
80105d53:	74 09                	je     80105d5e <strncpy+0x2e>
80105d55:	89 cb                	mov    %ecx,%ebx
80105d57:	83 e9 01             	sub    $0x1,%ecx
80105d5a:	85 db                	test   %ebx,%ebx
80105d5c:	7f e2                	jg     80105d40 <strncpy+0x10>
    ;
  while(n-- > 0)
80105d5e:	89 c2                	mov    %eax,%edx
80105d60:	85 c9                	test   %ecx,%ecx
80105d62:	7e 17                	jle    80105d7b <strncpy+0x4b>
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105d68:	83 c2 01             	add    $0x1,%edx
80105d6b:	89 c1                	mov    %eax,%ecx
80105d6d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80105d71:	29 d1                	sub    %edx,%ecx
80105d73:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80105d77:	85 c9                	test   %ecx,%ecx
80105d79:	7f ed                	jg     80105d68 <strncpy+0x38>
  return os;
}
80105d7b:	5b                   	pop    %ebx
80105d7c:	89 f0                	mov    %esi,%eax
80105d7e:	5e                   	pop    %esi
80105d7f:	5f                   	pop    %edi
80105d80:	5d                   	pop    %ebp
80105d81:	c3                   	ret    
80105d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	56                   	push   %esi
80105d94:	8b 55 10             	mov    0x10(%ebp),%edx
80105d97:	8b 75 08             	mov    0x8(%ebp),%esi
80105d9a:	53                   	push   %ebx
80105d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105d9e:	85 d2                	test   %edx,%edx
80105da0:	7e 25                	jle    80105dc7 <safestrcpy+0x37>
80105da2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105da6:	89 f2                	mov    %esi,%edx
80105da8:	eb 16                	jmp    80105dc0 <safestrcpy+0x30>
80105daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105db0:	0f b6 08             	movzbl (%eax),%ecx
80105db3:	83 c0 01             	add    $0x1,%eax
80105db6:	83 c2 01             	add    $0x1,%edx
80105db9:	88 4a ff             	mov    %cl,-0x1(%edx)
80105dbc:	84 c9                	test   %cl,%cl
80105dbe:	74 04                	je     80105dc4 <safestrcpy+0x34>
80105dc0:	39 d8                	cmp    %ebx,%eax
80105dc2:	75 ec                	jne    80105db0 <safestrcpy+0x20>
    ;
  *s = 0;
80105dc4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105dc7:	89 f0                	mov    %esi,%eax
80105dc9:	5b                   	pop    %ebx
80105dca:	5e                   	pop    %esi
80105dcb:	5d                   	pop    %ebp
80105dcc:	c3                   	ret    
80105dcd:	8d 76 00             	lea    0x0(%esi),%esi

80105dd0 <strlen>:

int
strlen(const char *s)
{
80105dd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105dd1:	31 c0                	xor    %eax,%eax
{
80105dd3:	89 e5                	mov    %esp,%ebp
80105dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105dd8:	80 3a 00             	cmpb   $0x0,(%edx)
80105ddb:	74 0c                	je     80105de9 <strlen+0x19>
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
80105de0:	83 c0 01             	add    $0x1,%eax
80105de3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105de7:	75 f7                	jne    80105de0 <strlen+0x10>
    ;
  return n;
}
80105de9:	5d                   	pop    %ebp
80105dea:	c3                   	ret    

80105deb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105deb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105def:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105df3:	55                   	push   %ebp
  pushl %ebx
80105df4:	53                   	push   %ebx
  pushl %esi
80105df5:	56                   	push   %esi
  pushl %edi
80105df6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105df7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105df9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105dfb:	5f                   	pop    %edi
  popl %esi
80105dfc:	5e                   	pop    %esi
  popl %ebx
80105dfd:	5b                   	pop    %ebx
  popl %ebp
80105dfe:	5d                   	pop    %ebp
  ret
80105dff:	c3                   	ret    

80105e00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
80105e04:	83 ec 04             	sub    $0x4,%esp
80105e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105e0a:	e8 e1 e0 ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105e0f:	8b 00                	mov    (%eax),%eax
80105e11:	39 d8                	cmp    %ebx,%eax
80105e13:	76 1b                	jbe    80105e30 <fetchint+0x30>
80105e15:	8d 53 04             	lea    0x4(%ebx),%edx
80105e18:	39 d0                	cmp    %edx,%eax
80105e1a:	72 14                	jb     80105e30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e1f:	8b 13                	mov    (%ebx),%edx
80105e21:	89 10                	mov    %edx,(%eax)
  return 0;
80105e23:	31 c0                	xor    %eax,%eax
}
80105e25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e28:	c9                   	leave  
80105e29:	c3                   	ret    
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e35:	eb ee                	jmp    80105e25 <fetchint+0x25>
80105e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	53                   	push   %ebx
80105e44:	83 ec 04             	sub    $0x4,%esp
80105e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80105e4a:	e8 a1 e0 ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz)
80105e4f:	39 18                	cmp    %ebx,(%eax)
80105e51:	76 2d                	jbe    80105e80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80105e53:	8b 55 0c             	mov    0xc(%ebp),%edx
80105e56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105e58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105e5a:	39 d3                	cmp    %edx,%ebx
80105e5c:	73 22                	jae    80105e80 <fetchstr+0x40>
80105e5e:	89 d8                	mov    %ebx,%eax
80105e60:	eb 0d                	jmp    80105e6f <fetchstr+0x2f>
80105e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e68:	83 c0 01             	add    $0x1,%eax
80105e6b:	39 c2                	cmp    %eax,%edx
80105e6d:	76 11                	jbe    80105e80 <fetchstr+0x40>
    if(*s == 0)
80105e6f:	80 38 00             	cmpb   $0x0,(%eax)
80105e72:	75 f4                	jne    80105e68 <fetchstr+0x28>
      return s - *pp;
80105e74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105e76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e79:	c9                   	leave  
80105e7a:	c3                   	ret    
80105e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e7f:	90                   	nop
80105e80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105e83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e88:	c9                   	leave  
80105e89:	c3                   	ret    
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	56                   	push   %esi
80105e94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105e95:	e8 56 e0 ff ff       	call   80103ef0 <myproc>
80105e9a:	8b 55 08             	mov    0x8(%ebp),%edx
80105e9d:	8b 40 18             	mov    0x18(%eax),%eax
80105ea0:	8b 40 44             	mov    0x44(%eax),%eax
80105ea3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105ea6:	e8 45 e0 ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105eab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105eae:	8b 00                	mov    (%eax),%eax
80105eb0:	39 c6                	cmp    %eax,%esi
80105eb2:	73 1c                	jae    80105ed0 <argint+0x40>
80105eb4:	8d 53 08             	lea    0x8(%ebx),%edx
80105eb7:	39 d0                	cmp    %edx,%eax
80105eb9:	72 15                	jb     80105ed0 <argint+0x40>
  *ip = *(int*)(addr);
80105ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ebe:	8b 53 04             	mov    0x4(%ebx),%edx
80105ec1:	89 10                	mov    %edx,(%eax)
  return 0;
80105ec3:	31 c0                	xor    %eax,%eax
}
80105ec5:	5b                   	pop    %ebx
80105ec6:	5e                   	pop    %esi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ed5:	eb ee                	jmp    80105ec5 <argint+0x35>
80105ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ede:	66 90                	xchg   %ax,%ax

80105ee0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
80105ee5:	53                   	push   %ebx
80105ee6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105ee9:	e8 02 e0 ff ff       	call   80103ef0 <myproc>
80105eee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105ef0:	e8 fb df ff ff       	call   80103ef0 <myproc>
80105ef5:	8b 55 08             	mov    0x8(%ebp),%edx
80105ef8:	8b 40 18             	mov    0x18(%eax),%eax
80105efb:	8b 40 44             	mov    0x44(%eax),%eax
80105efe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105f01:	e8 ea df ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f09:	8b 00                	mov    (%eax),%eax
80105f0b:	39 c7                	cmp    %eax,%edi
80105f0d:	73 31                	jae    80105f40 <argptr+0x60>
80105f0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105f12:	39 c8                	cmp    %ecx,%eax
80105f14:	72 2a                	jb     80105f40 <argptr+0x60>

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105f16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105f19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105f1c:	85 d2                	test   %edx,%edx
80105f1e:	78 20                	js     80105f40 <argptr+0x60>
80105f20:	8b 16                	mov    (%esi),%edx
80105f22:	39 c2                	cmp    %eax,%edx
80105f24:	76 1a                	jbe    80105f40 <argptr+0x60>
80105f26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105f29:	01 c3                	add    %eax,%ebx
80105f2b:	39 da                	cmp    %ebx,%edx
80105f2d:	72 11                	jb     80105f40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80105f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105f32:	89 02                	mov    %eax,(%edx)
  return 0;
80105f34:	31 c0                	xor    %eax,%eax
}
80105f36:	83 c4 0c             	add    $0xc,%esp
80105f39:	5b                   	pop    %ebx
80105f3a:	5e                   	pop    %esi
80105f3b:	5f                   	pop    %edi
80105f3c:	5d                   	pop    %ebp
80105f3d:	c3                   	ret    
80105f3e:	66 90                	xchg   %ax,%ax
    return -1;
80105f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f45:	eb ef                	jmp    80105f36 <argptr+0x56>
80105f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4e:	66 90                	xchg   %ax,%ax

80105f50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	56                   	push   %esi
80105f54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f55:	e8 96 df ff ff       	call   80103ef0 <myproc>
80105f5a:	8b 55 08             	mov    0x8(%ebp),%edx
80105f5d:	8b 40 18             	mov    0x18(%eax),%eax
80105f60:	8b 40 44             	mov    0x44(%eax),%eax
80105f63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105f66:	e8 85 df ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105f6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105f6e:	8b 00                	mov    (%eax),%eax
80105f70:	39 c6                	cmp    %eax,%esi
80105f72:	73 44                	jae    80105fb8 <argstr+0x68>
80105f74:	8d 53 08             	lea    0x8(%ebx),%edx
80105f77:	39 d0                	cmp    %edx,%eax
80105f79:	72 3d                	jb     80105fb8 <argstr+0x68>
  *ip = *(int*)(addr);
80105f7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80105f7e:	e8 6d df ff ff       	call   80103ef0 <myproc>
  if(addr >= curproc->sz)
80105f83:	3b 18                	cmp    (%eax),%ebx
80105f85:	73 31                	jae    80105fb8 <argstr+0x68>
  *pp = (char*)addr;
80105f87:	8b 55 0c             	mov    0xc(%ebp),%edx
80105f8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105f8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105f8e:	39 d3                	cmp    %edx,%ebx
80105f90:	73 26                	jae    80105fb8 <argstr+0x68>
80105f92:	89 d8                	mov    %ebx,%eax
80105f94:	eb 11                	jmp    80105fa7 <argstr+0x57>
80105f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f9d:	8d 76 00             	lea    0x0(%esi),%esi
80105fa0:	83 c0 01             	add    $0x1,%eax
80105fa3:	39 c2                	cmp    %eax,%edx
80105fa5:	76 11                	jbe    80105fb8 <argstr+0x68>
    if(*s == 0)
80105fa7:	80 38 00             	cmpb   $0x0,(%eax)
80105faa:	75 f4                	jne    80105fa0 <argstr+0x50>
      return s - *pp;
80105fac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105fae:	5b                   	pop    %ebx
80105faf:	5e                   	pop    %esi
80105fb0:	5d                   	pop    %ebp
80105fb1:	c3                   	ret    
80105fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fb8:	5b                   	pop    %ebx
    return -1;
80105fb9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fbe:	5e                   	pop    %esi
80105fbf:	5d                   	pop    %ebp
80105fc0:	c3                   	ret    
80105fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fcf:	90                   	nop

80105fd0 <syscall>:
};


void
syscall(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	56                   	push   %esi
80105fd4:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105fd5:	e8 16 df ff ff       	call   80103ef0 <myproc>
80105fda:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105fdc:	8b 40 18             	mov    0x18(%eax),%eax
80105fdf:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105fe2:	8d 50 ff             	lea    -0x1(%eax),%edx
80105fe5:	83 fa 24             	cmp    $0x24,%edx
80105fe8:	77 2e                	ja     80106018 <syscall+0x48>
80105fea:	8b 34 85 a0 93 10 80 	mov    -0x7fef6c60(,%eax,4),%esi
80105ff1:	85 f6                	test   %esi,%esi
80105ff3:	74 23                	je     80106018 <syscall+0x48>
    // increase the count of how many times a system call, has been called by one.
    update_syscalls_count(num);
80105ff5:	83 ec 0c             	sub    $0xc,%esp
80105ff8:	50                   	push   %eax
80105ff9:	e8 32 ed ff ff       	call   80104d30 <update_syscalls_count>
    curproc->tf->eax = syscalls[num]();
80105ffe:	ff d6                	call   *%esi
80106000:	83 c4 10             	add    $0x10,%esp
80106003:	89 c2                	mov    %eax,%edx
80106005:	8b 43 18             	mov    0x18(%ebx),%eax
80106008:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010600b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010600e:	5b                   	pop    %ebx
8010600f:	5e                   	pop    %esi
80106010:	5d                   	pop    %ebp
80106011:	c3                   	ret    
80106012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80106018:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106019:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010601c:	50                   	push   %eax
8010601d:	ff 73 10             	push   0x10(%ebx)
80106020:	68 79 93 10 80       	push   $0x80109379
80106025:	e8 c6 a6 ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
8010602a:	8b 43 18             	mov    0x18(%ebx),%eax
8010602d:	83 c4 10             	add    $0x10,%esp
80106030:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80106037:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010603a:	5b                   	pop    %ebx
8010603b:	5e                   	pop    %esi
8010603c:	5d                   	pop    %ebp
8010603d:	c3                   	ret    
8010603e:	66 90                	xchg   %ax,%ax

80106040 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	57                   	push   %edi
80106044:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106045:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106048:	53                   	push   %ebx
80106049:	83 ec 34             	sub    $0x34,%esp
8010604c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010604f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80106052:	57                   	push   %edi
80106053:	50                   	push   %eax
{
80106054:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106057:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010605a:	e8 01 c5 ff ff       	call   80102560 <nameiparent>
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	85 c0                	test   %eax,%eax
80106064:	0f 84 46 01 00 00    	je     801061b0 <create+0x170>
    return 0;
  ilock(dp);
8010606a:	83 ec 0c             	sub    $0xc,%esp
8010606d:	89 c3                	mov    %eax,%ebx
8010606f:	50                   	push   %eax
80106070:	e8 ab bb ff ff       	call   80101c20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80106075:	83 c4 0c             	add    $0xc,%esp
80106078:	6a 00                	push   $0x0
8010607a:	57                   	push   %edi
8010607b:	53                   	push   %ebx
8010607c:	e8 ff c0 ff ff       	call   80102180 <dirlookup>
80106081:	83 c4 10             	add    $0x10,%esp
80106084:	89 c6                	mov    %eax,%esi
80106086:	85 c0                	test   %eax,%eax
80106088:	74 56                	je     801060e0 <create+0xa0>
    iunlockput(dp);
8010608a:	83 ec 0c             	sub    $0xc,%esp
8010608d:	53                   	push   %ebx
8010608e:	e8 1d be ff ff       	call   80101eb0 <iunlockput>
    ilock(ip);
80106093:	89 34 24             	mov    %esi,(%esp)
80106096:	e8 85 bb ff ff       	call   80101c20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010609b:	83 c4 10             	add    $0x10,%esp
8010609e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801060a3:	75 1b                	jne    801060c0 <create+0x80>
801060a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801060aa:	75 14                	jne    801060c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801060ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060af:	89 f0                	mov    %esi,%eax
801060b1:	5b                   	pop    %ebx
801060b2:	5e                   	pop    %esi
801060b3:	5f                   	pop    %edi
801060b4:	5d                   	pop    %ebp
801060b5:	c3                   	ret    
801060b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801060c0:	83 ec 0c             	sub    $0xc,%esp
801060c3:	56                   	push   %esi
    return 0;
801060c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801060c6:	e8 e5 bd ff ff       	call   80101eb0 <iunlockput>
    return 0;
801060cb:	83 c4 10             	add    $0x10,%esp
}
801060ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060d1:	89 f0                	mov    %esi,%eax
801060d3:	5b                   	pop    %ebx
801060d4:	5e                   	pop    %esi
801060d5:	5f                   	pop    %edi
801060d6:	5d                   	pop    %ebp
801060d7:	c3                   	ret    
801060d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801060e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801060e4:	83 ec 08             	sub    $0x8,%esp
801060e7:	50                   	push   %eax
801060e8:	ff 33                	push   (%ebx)
801060ea:	e8 c1 b9 ff ff       	call   80101ab0 <ialloc>
801060ef:	83 c4 10             	add    $0x10,%esp
801060f2:	89 c6                	mov    %eax,%esi
801060f4:	85 c0                	test   %eax,%eax
801060f6:	0f 84 cd 00 00 00    	je     801061c9 <create+0x189>
  ilock(ip);
801060fc:	83 ec 0c             	sub    $0xc,%esp
801060ff:	50                   	push   %eax
80106100:	e8 1b bb ff ff       	call   80101c20 <ilock>
  ip->major = major;
80106105:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106109:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010610d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106111:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106115:	b8 01 00 00 00       	mov    $0x1,%eax
8010611a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010611e:	89 34 24             	mov    %esi,(%esp)
80106121:	e8 4a ba ff ff       	call   80101b70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106126:	83 c4 10             	add    $0x10,%esp
80106129:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010612e:	74 30                	je     80106160 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106130:	83 ec 04             	sub    $0x4,%esp
80106133:	ff 76 04             	push   0x4(%esi)
80106136:	57                   	push   %edi
80106137:	53                   	push   %ebx
80106138:	e8 43 c3 ff ff       	call   80102480 <dirlink>
8010613d:	83 c4 10             	add    $0x10,%esp
80106140:	85 c0                	test   %eax,%eax
80106142:	78 78                	js     801061bc <create+0x17c>
  iunlockput(dp);
80106144:	83 ec 0c             	sub    $0xc,%esp
80106147:	53                   	push   %ebx
80106148:	e8 63 bd ff ff       	call   80101eb0 <iunlockput>
  return ip;
8010614d:	83 c4 10             	add    $0x10,%esp
}
80106150:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106153:	89 f0                	mov    %esi,%eax
80106155:	5b                   	pop    %ebx
80106156:	5e                   	pop    %esi
80106157:	5f                   	pop    %edi
80106158:	5d                   	pop    %ebp
80106159:	c3                   	ret    
8010615a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106160:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80106163:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106168:	53                   	push   %ebx
80106169:	e8 02 ba ff ff       	call   80101b70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010616e:	83 c4 0c             	add    $0xc,%esp
80106171:	ff 76 04             	push   0x4(%esi)
80106174:	68 54 94 10 80       	push   $0x80109454
80106179:	56                   	push   %esi
8010617a:	e8 01 c3 ff ff       	call   80102480 <dirlink>
8010617f:	83 c4 10             	add    $0x10,%esp
80106182:	85 c0                	test   %eax,%eax
80106184:	78 18                	js     8010619e <create+0x15e>
80106186:	83 ec 04             	sub    $0x4,%esp
80106189:	ff 73 04             	push   0x4(%ebx)
8010618c:	68 53 94 10 80       	push   $0x80109453
80106191:	56                   	push   %esi
80106192:	e8 e9 c2 ff ff       	call   80102480 <dirlink>
80106197:	83 c4 10             	add    $0x10,%esp
8010619a:	85 c0                	test   %eax,%eax
8010619c:	79 92                	jns    80106130 <create+0xf0>
      panic("create dots");
8010619e:	83 ec 0c             	sub    $0xc,%esp
801061a1:	68 47 94 10 80       	push   $0x80109447
801061a6:	e8 d5 a1 ff ff       	call   80100380 <panic>
801061ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061af:	90                   	nop
}
801061b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801061b3:	31 f6                	xor    %esi,%esi
}
801061b5:	5b                   	pop    %ebx
801061b6:	89 f0                	mov    %esi,%eax
801061b8:	5e                   	pop    %esi
801061b9:	5f                   	pop    %edi
801061ba:	5d                   	pop    %ebp
801061bb:	c3                   	ret    
    panic("create: dirlink");
801061bc:	83 ec 0c             	sub    $0xc,%esp
801061bf:	68 56 94 10 80       	push   $0x80109456
801061c4:	e8 b7 a1 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
801061c9:	83 ec 0c             	sub    $0xc,%esp
801061cc:	68 38 94 10 80       	push   $0x80109438
801061d1:	e8 aa a1 ff ff       	call   80100380 <panic>
801061d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061dd:	8d 76 00             	lea    0x0(%esi),%esi

801061e0 <sys_dup>:
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	56                   	push   %esi
801061e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801061e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801061eb:	50                   	push   %eax
801061ec:	6a 00                	push   $0x0
801061ee:	e8 9d fc ff ff       	call   80105e90 <argint>
801061f3:	83 c4 10             	add    $0x10,%esp
801061f6:	85 c0                	test   %eax,%eax
801061f8:	78 36                	js     80106230 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801061fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801061fe:	77 30                	ja     80106230 <sys_dup+0x50>
80106200:	e8 eb dc ff ff       	call   80103ef0 <myproc>
80106205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106208:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010620c:	85 f6                	test   %esi,%esi
8010620e:	74 20                	je     80106230 <sys_dup+0x50>
  struct proc *curproc = myproc();
80106210:	e8 db dc ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106215:	31 db                	xor    %ebx,%ebx
80106217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106220:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106224:	85 d2                	test   %edx,%edx
80106226:	74 18                	je     80106240 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80106228:	83 c3 01             	add    $0x1,%ebx
8010622b:	83 fb 10             	cmp    $0x10,%ebx
8010622e:	75 f0                	jne    80106220 <sys_dup+0x40>
}
80106230:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80106233:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106238:	89 d8                	mov    %ebx,%eax
8010623a:	5b                   	pop    %ebx
8010623b:	5e                   	pop    %esi
8010623c:	5d                   	pop    %ebp
8010623d:	c3                   	ret    
8010623e:	66 90                	xchg   %ax,%ax
  filedup(f);
80106240:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106243:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106247:	56                   	push   %esi
80106248:	e8 f3 b0 ff ff       	call   80101340 <filedup>
  return fd;
8010624d:	83 c4 10             	add    $0x10,%esp
}
80106250:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106253:	89 d8                	mov    %ebx,%eax
80106255:	5b                   	pop    %ebx
80106256:	5e                   	pop    %esi
80106257:	5d                   	pop    %ebp
80106258:	c3                   	ret    
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106260 <sys_read>:
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	56                   	push   %esi
80106264:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106265:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80106268:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010626b:	53                   	push   %ebx
8010626c:	6a 00                	push   $0x0
8010626e:	e8 1d fc ff ff       	call   80105e90 <argint>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	85 c0                	test   %eax,%eax
80106278:	78 5e                	js     801062d8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010627a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010627e:	77 58                	ja     801062d8 <sys_read+0x78>
80106280:	e8 6b dc ff ff       	call   80103ef0 <myproc>
80106285:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106288:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010628c:	85 f6                	test   %esi,%esi
8010628e:	74 48                	je     801062d8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106290:	83 ec 08             	sub    $0x8,%esp
80106293:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106296:	50                   	push   %eax
80106297:	6a 02                	push   $0x2
80106299:	e8 f2 fb ff ff       	call   80105e90 <argint>
8010629e:	83 c4 10             	add    $0x10,%esp
801062a1:	85 c0                	test   %eax,%eax
801062a3:	78 33                	js     801062d8 <sys_read+0x78>
801062a5:	83 ec 04             	sub    $0x4,%esp
801062a8:	ff 75 f0             	push   -0x10(%ebp)
801062ab:	53                   	push   %ebx
801062ac:	6a 01                	push   $0x1
801062ae:	e8 2d fc ff ff       	call   80105ee0 <argptr>
801062b3:	83 c4 10             	add    $0x10,%esp
801062b6:	85 c0                	test   %eax,%eax
801062b8:	78 1e                	js     801062d8 <sys_read+0x78>
  return fileread(f, p, n);
801062ba:	83 ec 04             	sub    $0x4,%esp
801062bd:	ff 75 f0             	push   -0x10(%ebp)
801062c0:	ff 75 f4             	push   -0xc(%ebp)
801062c3:	56                   	push   %esi
801062c4:	e8 f7 b1 ff ff       	call   801014c0 <fileread>
801062c9:	83 c4 10             	add    $0x10,%esp
}
801062cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801062cf:	5b                   	pop    %ebx
801062d0:	5e                   	pop    %esi
801062d1:	5d                   	pop    %ebp
801062d2:	c3                   	ret    
801062d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062d7:	90                   	nop
    return -1;
801062d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062dd:	eb ed                	jmp    801062cc <sys_read+0x6c>
801062df:	90                   	nop

801062e0 <sys_write>:
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	56                   	push   %esi
801062e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801062e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801062e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801062eb:	53                   	push   %ebx
801062ec:	6a 00                	push   $0x0
801062ee:	e8 9d fb ff ff       	call   80105e90 <argint>
801062f3:	83 c4 10             	add    $0x10,%esp
801062f6:	85 c0                	test   %eax,%eax
801062f8:	78 5e                	js     80106358 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801062fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801062fe:	77 58                	ja     80106358 <sys_write+0x78>
80106300:	e8 eb db ff ff       	call   80103ef0 <myproc>
80106305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106308:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010630c:	85 f6                	test   %esi,%esi
8010630e:	74 48                	je     80106358 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106310:	83 ec 08             	sub    $0x8,%esp
80106313:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106316:	50                   	push   %eax
80106317:	6a 02                	push   $0x2
80106319:	e8 72 fb ff ff       	call   80105e90 <argint>
8010631e:	83 c4 10             	add    $0x10,%esp
80106321:	85 c0                	test   %eax,%eax
80106323:	78 33                	js     80106358 <sys_write+0x78>
80106325:	83 ec 04             	sub    $0x4,%esp
80106328:	ff 75 f0             	push   -0x10(%ebp)
8010632b:	53                   	push   %ebx
8010632c:	6a 01                	push   $0x1
8010632e:	e8 ad fb ff ff       	call   80105ee0 <argptr>
80106333:	83 c4 10             	add    $0x10,%esp
80106336:	85 c0                	test   %eax,%eax
80106338:	78 1e                	js     80106358 <sys_write+0x78>
  return filewrite(f, p, n);
8010633a:	83 ec 04             	sub    $0x4,%esp
8010633d:	ff 75 f0             	push   -0x10(%ebp)
80106340:	ff 75 f4             	push   -0xc(%ebp)
80106343:	56                   	push   %esi
80106344:	e8 07 b2 ff ff       	call   80101550 <filewrite>
80106349:	83 c4 10             	add    $0x10,%esp
}
8010634c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010634f:	5b                   	pop    %ebx
80106350:	5e                   	pop    %esi
80106351:	5d                   	pop    %ebp
80106352:	c3                   	ret    
80106353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106357:	90                   	nop
    return -1;
80106358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635d:	eb ed                	jmp    8010634c <sys_write+0x6c>
8010635f:	90                   	nop

80106360 <sys_close>:
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	56                   	push   %esi
80106364:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80106365:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106368:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010636b:	50                   	push   %eax
8010636c:	6a 00                	push   $0x0
8010636e:	e8 1d fb ff ff       	call   80105e90 <argint>
80106373:	83 c4 10             	add    $0x10,%esp
80106376:	85 c0                	test   %eax,%eax
80106378:	78 3e                	js     801063b8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010637a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010637e:	77 38                	ja     801063b8 <sys_close+0x58>
80106380:	e8 6b db ff ff       	call   80103ef0 <myproc>
80106385:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106388:	8d 5a 08             	lea    0x8(%edx),%ebx
8010638b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010638f:	85 f6                	test   %esi,%esi
80106391:	74 25                	je     801063b8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80106393:	e8 58 db ff ff       	call   80103ef0 <myproc>
  fileclose(f);
80106398:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010639b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801063a2:	00 
  fileclose(f);
801063a3:	56                   	push   %esi
801063a4:	e8 e7 af ff ff       	call   80101390 <fileclose>
  return 0;
801063a9:	83 c4 10             	add    $0x10,%esp
801063ac:	31 c0                	xor    %eax,%eax
}
801063ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063b1:	5b                   	pop    %ebx
801063b2:	5e                   	pop    %esi
801063b3:	5d                   	pop    %ebp
801063b4:	c3                   	ret    
801063b5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801063b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063bd:	eb ef                	jmp    801063ae <sys_close+0x4e>
801063bf:	90                   	nop

801063c0 <sys_fstat>:
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	56                   	push   %esi
801063c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801063c5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801063c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801063cb:	53                   	push   %ebx
801063cc:	6a 00                	push   $0x0
801063ce:	e8 bd fa ff ff       	call   80105e90 <argint>
801063d3:	83 c4 10             	add    $0x10,%esp
801063d6:	85 c0                	test   %eax,%eax
801063d8:	78 46                	js     80106420 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801063da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801063de:	77 40                	ja     80106420 <sys_fstat+0x60>
801063e0:	e8 0b db ff ff       	call   80103ef0 <myproc>
801063e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063e8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801063ec:	85 f6                	test   %esi,%esi
801063ee:	74 30                	je     80106420 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801063f0:	83 ec 04             	sub    $0x4,%esp
801063f3:	6a 14                	push   $0x14
801063f5:	53                   	push   %ebx
801063f6:	6a 01                	push   $0x1
801063f8:	e8 e3 fa ff ff       	call   80105ee0 <argptr>
801063fd:	83 c4 10             	add    $0x10,%esp
80106400:	85 c0                	test   %eax,%eax
80106402:	78 1c                	js     80106420 <sys_fstat+0x60>
  return filestat(f, st);
80106404:	83 ec 08             	sub    $0x8,%esp
80106407:	ff 75 f4             	push   -0xc(%ebp)
8010640a:	56                   	push   %esi
8010640b:	e8 60 b0 ff ff       	call   80101470 <filestat>
80106410:	83 c4 10             	add    $0x10,%esp
}
80106413:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106416:	5b                   	pop    %ebx
80106417:	5e                   	pop    %esi
80106418:	5d                   	pop    %ebp
80106419:	c3                   	ret    
8010641a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80106420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106425:	eb ec                	jmp    80106413 <sys_fstat+0x53>
80106427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010642e:	66 90                	xchg   %ax,%ax

80106430 <sys_link>:
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	57                   	push   %edi
80106434:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106435:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80106438:	53                   	push   %ebx
80106439:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010643c:	50                   	push   %eax
8010643d:	6a 00                	push   $0x0
8010643f:	e8 0c fb ff ff       	call   80105f50 <argstr>
80106444:	83 c4 10             	add    $0x10,%esp
80106447:	85 c0                	test   %eax,%eax
80106449:	0f 88 fb 00 00 00    	js     8010654a <sys_link+0x11a>
8010644f:	83 ec 08             	sub    $0x8,%esp
80106452:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106455:	50                   	push   %eax
80106456:	6a 01                	push   $0x1
80106458:	e8 f3 fa ff ff       	call   80105f50 <argstr>
8010645d:	83 c4 10             	add    $0x10,%esp
80106460:	85 c0                	test   %eax,%eax
80106462:	0f 88 e2 00 00 00    	js     8010654a <sys_link+0x11a>
  begin_op();
80106468:	e8 93 cd ff ff       	call   80103200 <begin_op>
  if((ip = namei(old)) == 0){
8010646d:	83 ec 0c             	sub    $0xc,%esp
80106470:	ff 75 d4             	push   -0x2c(%ebp)
80106473:	e8 c8 c0 ff ff       	call   80102540 <namei>
80106478:	83 c4 10             	add    $0x10,%esp
8010647b:	89 c3                	mov    %eax,%ebx
8010647d:	85 c0                	test   %eax,%eax
8010647f:	0f 84 e4 00 00 00    	je     80106569 <sys_link+0x139>
  ilock(ip);
80106485:	83 ec 0c             	sub    $0xc,%esp
80106488:	50                   	push   %eax
80106489:	e8 92 b7 ff ff       	call   80101c20 <ilock>
  if(ip->type == T_DIR){
8010648e:	83 c4 10             	add    $0x10,%esp
80106491:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106496:	0f 84 b5 00 00 00    	je     80106551 <sys_link+0x121>
  iupdate(ip);
8010649c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010649f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801064a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801064a7:	53                   	push   %ebx
801064a8:	e8 c3 b6 ff ff       	call   80101b70 <iupdate>
  iunlock(ip);
801064ad:	89 1c 24             	mov    %ebx,(%esp)
801064b0:	e8 4b b8 ff ff       	call   80101d00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801064b5:	58                   	pop    %eax
801064b6:	5a                   	pop    %edx
801064b7:	57                   	push   %edi
801064b8:	ff 75 d0             	push   -0x30(%ebp)
801064bb:	e8 a0 c0 ff ff       	call   80102560 <nameiparent>
801064c0:	83 c4 10             	add    $0x10,%esp
801064c3:	89 c6                	mov    %eax,%esi
801064c5:	85 c0                	test   %eax,%eax
801064c7:	74 5b                	je     80106524 <sys_link+0xf4>
  ilock(dp);
801064c9:	83 ec 0c             	sub    $0xc,%esp
801064cc:	50                   	push   %eax
801064cd:	e8 4e b7 ff ff       	call   80101c20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801064d2:	8b 03                	mov    (%ebx),%eax
801064d4:	83 c4 10             	add    $0x10,%esp
801064d7:	39 06                	cmp    %eax,(%esi)
801064d9:	75 3d                	jne    80106518 <sys_link+0xe8>
801064db:	83 ec 04             	sub    $0x4,%esp
801064de:	ff 73 04             	push   0x4(%ebx)
801064e1:	57                   	push   %edi
801064e2:	56                   	push   %esi
801064e3:	e8 98 bf ff ff       	call   80102480 <dirlink>
801064e8:	83 c4 10             	add    $0x10,%esp
801064eb:	85 c0                	test   %eax,%eax
801064ed:	78 29                	js     80106518 <sys_link+0xe8>
  iunlockput(dp);
801064ef:	83 ec 0c             	sub    $0xc,%esp
801064f2:	56                   	push   %esi
801064f3:	e8 b8 b9 ff ff       	call   80101eb0 <iunlockput>
  iput(ip);
801064f8:	89 1c 24             	mov    %ebx,(%esp)
801064fb:	e8 50 b8 ff ff       	call   80101d50 <iput>
  end_op();
80106500:	e8 6b cd ff ff       	call   80103270 <end_op>
  return 0;
80106505:	83 c4 10             	add    $0x10,%esp
80106508:	31 c0                	xor    %eax,%eax
}
8010650a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010650d:	5b                   	pop    %ebx
8010650e:	5e                   	pop    %esi
8010650f:	5f                   	pop    %edi
80106510:	5d                   	pop    %ebp
80106511:	c3                   	ret    
80106512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80106518:	83 ec 0c             	sub    $0xc,%esp
8010651b:	56                   	push   %esi
8010651c:	e8 8f b9 ff ff       	call   80101eb0 <iunlockput>
    goto bad;
80106521:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80106524:	83 ec 0c             	sub    $0xc,%esp
80106527:	53                   	push   %ebx
80106528:	e8 f3 b6 ff ff       	call   80101c20 <ilock>
  ip->nlink--;
8010652d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106532:	89 1c 24             	mov    %ebx,(%esp)
80106535:	e8 36 b6 ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
8010653a:	89 1c 24             	mov    %ebx,(%esp)
8010653d:	e8 6e b9 ff ff       	call   80101eb0 <iunlockput>
  end_op();
80106542:	e8 29 cd ff ff       	call   80103270 <end_op>
  return -1;
80106547:	83 c4 10             	add    $0x10,%esp
8010654a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010654f:	eb b9                	jmp    8010650a <sys_link+0xda>
    iunlockput(ip);
80106551:	83 ec 0c             	sub    $0xc,%esp
80106554:	53                   	push   %ebx
80106555:	e8 56 b9 ff ff       	call   80101eb0 <iunlockput>
    end_op();
8010655a:	e8 11 cd ff ff       	call   80103270 <end_op>
    return -1;
8010655f:	83 c4 10             	add    $0x10,%esp
80106562:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106567:	eb a1                	jmp    8010650a <sys_link+0xda>
    end_op();
80106569:	e8 02 cd ff ff       	call   80103270 <end_op>
    return -1;
8010656e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106573:	eb 95                	jmp    8010650a <sys_link+0xda>
80106575:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106580 <sys_unlink>:
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	57                   	push   %edi
80106584:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106585:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106588:	53                   	push   %ebx
80106589:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010658c:	50                   	push   %eax
8010658d:	6a 00                	push   $0x0
8010658f:	e8 bc f9 ff ff       	call   80105f50 <argstr>
80106594:	83 c4 10             	add    $0x10,%esp
80106597:	85 c0                	test   %eax,%eax
80106599:	0f 88 7a 01 00 00    	js     80106719 <sys_unlink+0x199>
  begin_op();
8010659f:	e8 5c cc ff ff       	call   80103200 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801065a4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801065a7:	83 ec 08             	sub    $0x8,%esp
801065aa:	53                   	push   %ebx
801065ab:	ff 75 c0             	push   -0x40(%ebp)
801065ae:	e8 ad bf ff ff       	call   80102560 <nameiparent>
801065b3:	83 c4 10             	add    $0x10,%esp
801065b6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801065b9:	85 c0                	test   %eax,%eax
801065bb:	0f 84 62 01 00 00    	je     80106723 <sys_unlink+0x1a3>
  ilock(dp);
801065c1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801065c4:	83 ec 0c             	sub    $0xc,%esp
801065c7:	57                   	push   %edi
801065c8:	e8 53 b6 ff ff       	call   80101c20 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801065cd:	58                   	pop    %eax
801065ce:	5a                   	pop    %edx
801065cf:	68 54 94 10 80       	push   $0x80109454
801065d4:	53                   	push   %ebx
801065d5:	e8 86 bb ff ff       	call   80102160 <namecmp>
801065da:	83 c4 10             	add    $0x10,%esp
801065dd:	85 c0                	test   %eax,%eax
801065df:	0f 84 fb 00 00 00    	je     801066e0 <sys_unlink+0x160>
801065e5:	83 ec 08             	sub    $0x8,%esp
801065e8:	68 53 94 10 80       	push   $0x80109453
801065ed:	53                   	push   %ebx
801065ee:	e8 6d bb ff ff       	call   80102160 <namecmp>
801065f3:	83 c4 10             	add    $0x10,%esp
801065f6:	85 c0                	test   %eax,%eax
801065f8:	0f 84 e2 00 00 00    	je     801066e0 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
801065fe:	83 ec 04             	sub    $0x4,%esp
80106601:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106604:	50                   	push   %eax
80106605:	53                   	push   %ebx
80106606:	57                   	push   %edi
80106607:	e8 74 bb ff ff       	call   80102180 <dirlookup>
8010660c:	83 c4 10             	add    $0x10,%esp
8010660f:	89 c3                	mov    %eax,%ebx
80106611:	85 c0                	test   %eax,%eax
80106613:	0f 84 c7 00 00 00    	je     801066e0 <sys_unlink+0x160>
  ilock(ip);
80106619:	83 ec 0c             	sub    $0xc,%esp
8010661c:	50                   	push   %eax
8010661d:	e8 fe b5 ff ff       	call   80101c20 <ilock>
  if(ip->nlink < 1)
80106622:	83 c4 10             	add    $0x10,%esp
80106625:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010662a:	0f 8e 1c 01 00 00    	jle    8010674c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106630:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106635:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106638:	74 66                	je     801066a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010663a:	83 ec 04             	sub    $0x4,%esp
8010663d:	6a 10                	push   $0x10
8010663f:	6a 00                	push   $0x0
80106641:	57                   	push   %edi
80106642:	e8 89 f5 ff ff       	call   80105bd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106647:	6a 10                	push   $0x10
80106649:	ff 75 c4             	push   -0x3c(%ebp)
8010664c:	57                   	push   %edi
8010664d:	ff 75 b4             	push   -0x4c(%ebp)
80106650:	e8 db b9 ff ff       	call   80102030 <writei>
80106655:	83 c4 20             	add    $0x20,%esp
80106658:	83 f8 10             	cmp    $0x10,%eax
8010665b:	0f 85 de 00 00 00    	jne    8010673f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80106661:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106666:	0f 84 94 00 00 00    	je     80106700 <sys_unlink+0x180>
  iunlockput(dp);
8010666c:	83 ec 0c             	sub    $0xc,%esp
8010666f:	ff 75 b4             	push   -0x4c(%ebp)
80106672:	e8 39 b8 ff ff       	call   80101eb0 <iunlockput>
  ip->nlink--;
80106677:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010667c:	89 1c 24             	mov    %ebx,(%esp)
8010667f:	e8 ec b4 ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
80106684:	89 1c 24             	mov    %ebx,(%esp)
80106687:	e8 24 b8 ff ff       	call   80101eb0 <iunlockput>
  end_op();
8010668c:	e8 df cb ff ff       	call   80103270 <end_op>
  return 0;
80106691:	83 c4 10             	add    $0x10,%esp
80106694:	31 c0                	xor    %eax,%eax
}
80106696:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106699:	5b                   	pop    %ebx
8010669a:	5e                   	pop    %esi
8010669b:	5f                   	pop    %edi
8010669c:	5d                   	pop    %ebp
8010669d:	c3                   	ret    
8010669e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801066a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801066a4:	76 94                	jbe    8010663a <sys_unlink+0xba>
801066a6:	be 20 00 00 00       	mov    $0x20,%esi
801066ab:	eb 0b                	jmp    801066b8 <sys_unlink+0x138>
801066ad:	8d 76 00             	lea    0x0(%esi),%esi
801066b0:	83 c6 10             	add    $0x10,%esi
801066b3:	3b 73 58             	cmp    0x58(%ebx),%esi
801066b6:	73 82                	jae    8010663a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801066b8:	6a 10                	push   $0x10
801066ba:	56                   	push   %esi
801066bb:	57                   	push   %edi
801066bc:	53                   	push   %ebx
801066bd:	e8 6e b8 ff ff       	call   80101f30 <readi>
801066c2:	83 c4 10             	add    $0x10,%esp
801066c5:	83 f8 10             	cmp    $0x10,%eax
801066c8:	75 68                	jne    80106732 <sys_unlink+0x1b2>
    if(de.inum != 0)
801066ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801066cf:	74 df                	je     801066b0 <sys_unlink+0x130>
    iunlockput(ip);
801066d1:	83 ec 0c             	sub    $0xc,%esp
801066d4:	53                   	push   %ebx
801066d5:	e8 d6 b7 ff ff       	call   80101eb0 <iunlockput>
    goto bad;
801066da:	83 c4 10             	add    $0x10,%esp
801066dd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
801066e0:	83 ec 0c             	sub    $0xc,%esp
801066e3:	ff 75 b4             	push   -0x4c(%ebp)
801066e6:	e8 c5 b7 ff ff       	call   80101eb0 <iunlockput>
  end_op();
801066eb:	e8 80 cb ff ff       	call   80103270 <end_op>
  return -1;
801066f0:	83 c4 10             	add    $0x10,%esp
801066f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066f8:	eb 9c                	jmp    80106696 <sys_unlink+0x116>
801066fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106700:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106703:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106706:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010670b:	50                   	push   %eax
8010670c:	e8 5f b4 ff ff       	call   80101b70 <iupdate>
80106711:	83 c4 10             	add    $0x10,%esp
80106714:	e9 53 ff ff ff       	jmp    8010666c <sys_unlink+0xec>
    return -1;
80106719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671e:	e9 73 ff ff ff       	jmp    80106696 <sys_unlink+0x116>
    end_op();
80106723:	e8 48 cb ff ff       	call   80103270 <end_op>
    return -1;
80106728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010672d:	e9 64 ff ff ff       	jmp    80106696 <sys_unlink+0x116>
      panic("isdirempty: readi");
80106732:	83 ec 0c             	sub    $0xc,%esp
80106735:	68 78 94 10 80       	push   $0x80109478
8010673a:	e8 41 9c ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010673f:	83 ec 0c             	sub    $0xc,%esp
80106742:	68 8a 94 10 80       	push   $0x8010948a
80106747:	e8 34 9c ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010674c:	83 ec 0c             	sub    $0xc,%esp
8010674f:	68 66 94 10 80       	push   $0x80109466
80106754:	e8 27 9c ff ff       	call   80100380 <panic>
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106760 <sys_open>:

int
sys_open(void)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106765:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80106768:	53                   	push   %ebx
80106769:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010676c:	50                   	push   %eax
8010676d:	6a 00                	push   $0x0
8010676f:	e8 dc f7 ff ff       	call   80105f50 <argstr>
80106774:	83 c4 10             	add    $0x10,%esp
80106777:	85 c0                	test   %eax,%eax
80106779:	0f 88 8e 00 00 00    	js     8010680d <sys_open+0xad>
8010677f:	83 ec 08             	sub    $0x8,%esp
80106782:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106785:	50                   	push   %eax
80106786:	6a 01                	push   $0x1
80106788:	e8 03 f7 ff ff       	call   80105e90 <argint>
8010678d:	83 c4 10             	add    $0x10,%esp
80106790:	85 c0                	test   %eax,%eax
80106792:	78 79                	js     8010680d <sys_open+0xad>
    return -1;

  begin_op();
80106794:	e8 67 ca ff ff       	call   80103200 <begin_op>

  if(omode & O_CREATE){
80106799:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010679d:	75 79                	jne    80106818 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010679f:	83 ec 0c             	sub    $0xc,%esp
801067a2:	ff 75 e0             	push   -0x20(%ebp)
801067a5:	e8 96 bd ff ff       	call   80102540 <namei>
801067aa:	83 c4 10             	add    $0x10,%esp
801067ad:	89 c6                	mov    %eax,%esi
801067af:	85 c0                	test   %eax,%eax
801067b1:	0f 84 7e 00 00 00    	je     80106835 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801067b7:	83 ec 0c             	sub    $0xc,%esp
801067ba:	50                   	push   %eax
801067bb:	e8 60 b4 ff ff       	call   80101c20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801067c0:	83 c4 10             	add    $0x10,%esp
801067c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801067c8:	0f 84 c2 00 00 00    	je     80106890 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801067ce:	e8 fd aa ff ff       	call   801012d0 <filealloc>
801067d3:	89 c7                	mov    %eax,%edi
801067d5:	85 c0                	test   %eax,%eax
801067d7:	74 23                	je     801067fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801067d9:	e8 12 d7 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801067de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801067e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801067e4:	85 d2                	test   %edx,%edx
801067e6:	74 60                	je     80106848 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801067e8:	83 c3 01             	add    $0x1,%ebx
801067eb:	83 fb 10             	cmp    $0x10,%ebx
801067ee:	75 f0                	jne    801067e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801067f0:	83 ec 0c             	sub    $0xc,%esp
801067f3:	57                   	push   %edi
801067f4:	e8 97 ab ff ff       	call   80101390 <fileclose>
801067f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801067fc:	83 ec 0c             	sub    $0xc,%esp
801067ff:	56                   	push   %esi
80106800:	e8 ab b6 ff ff       	call   80101eb0 <iunlockput>
    end_op();
80106805:	e8 66 ca ff ff       	call   80103270 <end_op>
    return -1;
8010680a:	83 c4 10             	add    $0x10,%esp
8010680d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106812:	eb 6d                	jmp    80106881 <sys_open+0x121>
80106814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106818:	83 ec 0c             	sub    $0xc,%esp
8010681b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010681e:	31 c9                	xor    %ecx,%ecx
80106820:	ba 02 00 00 00       	mov    $0x2,%edx
80106825:	6a 00                	push   $0x0
80106827:	e8 14 f8 ff ff       	call   80106040 <create>
    if(ip == 0){
8010682c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010682f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106831:	85 c0                	test   %eax,%eax
80106833:	75 99                	jne    801067ce <sys_open+0x6e>
      end_op();
80106835:	e8 36 ca ff ff       	call   80103270 <end_op>
      return -1;
8010683a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010683f:	eb 40                	jmp    80106881 <sys_open+0x121>
80106841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106848:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010684b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010684f:	56                   	push   %esi
80106850:	e8 ab b4 ff ff       	call   80101d00 <iunlock>
  end_op();
80106855:	e8 16 ca ff ff       	call   80103270 <end_op>

  f->type = FD_INODE;
8010685a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106863:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106866:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106869:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010686b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106872:	f7 d0                	not    %eax
80106874:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106877:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010687a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010687d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106884:	89 d8                	mov    %ebx,%eax
80106886:	5b                   	pop    %ebx
80106887:	5e                   	pop    %esi
80106888:	5f                   	pop    %edi
80106889:	5d                   	pop    %ebp
8010688a:	c3                   	ret    
8010688b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010688f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106893:	85 c9                	test   %ecx,%ecx
80106895:	0f 84 33 ff ff ff    	je     801067ce <sys_open+0x6e>
8010689b:	e9 5c ff ff ff       	jmp    801067fc <sys_open+0x9c>

801068a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801068a6:	e8 55 c9 ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801068ab:	83 ec 08             	sub    $0x8,%esp
801068ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
801068b1:	50                   	push   %eax
801068b2:	6a 00                	push   $0x0
801068b4:	e8 97 f6 ff ff       	call   80105f50 <argstr>
801068b9:	83 c4 10             	add    $0x10,%esp
801068bc:	85 c0                	test   %eax,%eax
801068be:	78 30                	js     801068f0 <sys_mkdir+0x50>
801068c0:	83 ec 0c             	sub    $0xc,%esp
801068c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c6:	31 c9                	xor    %ecx,%ecx
801068c8:	ba 01 00 00 00       	mov    $0x1,%edx
801068cd:	6a 00                	push   $0x0
801068cf:	e8 6c f7 ff ff       	call   80106040 <create>
801068d4:	83 c4 10             	add    $0x10,%esp
801068d7:	85 c0                	test   %eax,%eax
801068d9:	74 15                	je     801068f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801068db:	83 ec 0c             	sub    $0xc,%esp
801068de:	50                   	push   %eax
801068df:	e8 cc b5 ff ff       	call   80101eb0 <iunlockput>
  end_op();
801068e4:	e8 87 c9 ff ff       	call   80103270 <end_op>
  return 0;
801068e9:	83 c4 10             	add    $0x10,%esp
801068ec:	31 c0                	xor    %eax,%eax
}
801068ee:	c9                   	leave  
801068ef:	c3                   	ret    
    end_op();
801068f0:	e8 7b c9 ff ff       	call   80103270 <end_op>
    return -1;
801068f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068fa:	c9                   	leave  
801068fb:	c3                   	ret    
801068fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106900 <sys_mknod>:

int
sys_mknod(void)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106906:	e8 f5 c8 ff ff       	call   80103200 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010690b:	83 ec 08             	sub    $0x8,%esp
8010690e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106911:	50                   	push   %eax
80106912:	6a 00                	push   $0x0
80106914:	e8 37 f6 ff ff       	call   80105f50 <argstr>
80106919:	83 c4 10             	add    $0x10,%esp
8010691c:	85 c0                	test   %eax,%eax
8010691e:	78 60                	js     80106980 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106920:	83 ec 08             	sub    $0x8,%esp
80106923:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106926:	50                   	push   %eax
80106927:	6a 01                	push   $0x1
80106929:	e8 62 f5 ff ff       	call   80105e90 <argint>
  if((argstr(0, &path)) < 0 ||
8010692e:	83 c4 10             	add    $0x10,%esp
80106931:	85 c0                	test   %eax,%eax
80106933:	78 4b                	js     80106980 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106935:	83 ec 08             	sub    $0x8,%esp
80106938:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010693b:	50                   	push   %eax
8010693c:	6a 02                	push   $0x2
8010693e:	e8 4d f5 ff ff       	call   80105e90 <argint>
     argint(1, &major) < 0 ||
80106943:	83 c4 10             	add    $0x10,%esp
80106946:	85 c0                	test   %eax,%eax
80106948:	78 36                	js     80106980 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010694a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010694e:	83 ec 0c             	sub    $0xc,%esp
80106951:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106955:	ba 03 00 00 00       	mov    $0x3,%edx
8010695a:	50                   	push   %eax
8010695b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010695e:	e8 dd f6 ff ff       	call   80106040 <create>
     argint(2, &minor) < 0 ||
80106963:	83 c4 10             	add    $0x10,%esp
80106966:	85 c0                	test   %eax,%eax
80106968:	74 16                	je     80106980 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010696a:	83 ec 0c             	sub    $0xc,%esp
8010696d:	50                   	push   %eax
8010696e:	e8 3d b5 ff ff       	call   80101eb0 <iunlockput>
  end_op();
80106973:	e8 f8 c8 ff ff       	call   80103270 <end_op>
  return 0;
80106978:	83 c4 10             	add    $0x10,%esp
8010697b:	31 c0                	xor    %eax,%eax
}
8010697d:	c9                   	leave  
8010697e:	c3                   	ret    
8010697f:	90                   	nop
    end_op();
80106980:	e8 eb c8 ff ff       	call   80103270 <end_op>
    return -1;
80106985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010698a:	c9                   	leave  
8010698b:	c3                   	ret    
8010698c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106990 <sys_chdir>:

int
sys_chdir(void)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	56                   	push   %esi
80106994:	53                   	push   %ebx
80106995:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106998:	e8 53 d5 ff ff       	call   80103ef0 <myproc>
8010699d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010699f:	e8 5c c8 ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801069a4:	83 ec 08             	sub    $0x8,%esp
801069a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069aa:	50                   	push   %eax
801069ab:	6a 00                	push   $0x0
801069ad:	e8 9e f5 ff ff       	call   80105f50 <argstr>
801069b2:	83 c4 10             	add    $0x10,%esp
801069b5:	85 c0                	test   %eax,%eax
801069b7:	78 77                	js     80106a30 <sys_chdir+0xa0>
801069b9:	83 ec 0c             	sub    $0xc,%esp
801069bc:	ff 75 f4             	push   -0xc(%ebp)
801069bf:	e8 7c bb ff ff       	call   80102540 <namei>
801069c4:	83 c4 10             	add    $0x10,%esp
801069c7:	89 c3                	mov    %eax,%ebx
801069c9:	85 c0                	test   %eax,%eax
801069cb:	74 63                	je     80106a30 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801069cd:	83 ec 0c             	sub    $0xc,%esp
801069d0:	50                   	push   %eax
801069d1:	e8 4a b2 ff ff       	call   80101c20 <ilock>
  if(ip->type != T_DIR){
801069d6:	83 c4 10             	add    $0x10,%esp
801069d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801069de:	75 30                	jne    80106a10 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801069e0:	83 ec 0c             	sub    $0xc,%esp
801069e3:	53                   	push   %ebx
801069e4:	e8 17 b3 ff ff       	call   80101d00 <iunlock>
  iput(curproc->cwd);
801069e9:	58                   	pop    %eax
801069ea:	ff 76 68             	push   0x68(%esi)
801069ed:	e8 5e b3 ff ff       	call   80101d50 <iput>
  end_op();
801069f2:	e8 79 c8 ff ff       	call   80103270 <end_op>
  curproc->cwd = ip;
801069f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801069fa:	83 c4 10             	add    $0x10,%esp
801069fd:	31 c0                	xor    %eax,%eax
}
801069ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106a02:	5b                   	pop    %ebx
80106a03:	5e                   	pop    %esi
80106a04:	5d                   	pop    %ebp
80106a05:	c3                   	ret    
80106a06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106a10:	83 ec 0c             	sub    $0xc,%esp
80106a13:	53                   	push   %ebx
80106a14:	e8 97 b4 ff ff       	call   80101eb0 <iunlockput>
    end_op();
80106a19:	e8 52 c8 ff ff       	call   80103270 <end_op>
    return -1;
80106a1e:	83 c4 10             	add    $0x10,%esp
80106a21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a26:	eb d7                	jmp    801069ff <sys_chdir+0x6f>
80106a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a2f:	90                   	nop
    end_op();
80106a30:	e8 3b c8 ff ff       	call   80103270 <end_op>
    return -1;
80106a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3a:	eb c3                	jmp    801069ff <sys_chdir+0x6f>
80106a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a40 <sys_exec>:

int
sys_exec(void)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a45:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106a4b:	53                   	push   %ebx
80106a4c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a52:	50                   	push   %eax
80106a53:	6a 00                	push   $0x0
80106a55:	e8 f6 f4 ff ff       	call   80105f50 <argstr>
80106a5a:	83 c4 10             	add    $0x10,%esp
80106a5d:	85 c0                	test   %eax,%eax
80106a5f:	0f 88 87 00 00 00    	js     80106aec <sys_exec+0xac>
80106a65:	83 ec 08             	sub    $0x8,%esp
80106a68:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106a6e:	50                   	push   %eax
80106a6f:	6a 01                	push   $0x1
80106a71:	e8 1a f4 ff ff       	call   80105e90 <argint>
80106a76:	83 c4 10             	add    $0x10,%esp
80106a79:	85 c0                	test   %eax,%eax
80106a7b:	78 6f                	js     80106aec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106a7d:	83 ec 04             	sub    $0x4,%esp
80106a80:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106a86:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106a88:	68 80 00 00 00       	push   $0x80
80106a8d:	6a 00                	push   $0x0
80106a8f:	56                   	push   %esi
80106a90:	e8 3b f1 ff ff       	call   80105bd0 <memset>
80106a95:	83 c4 10             	add    $0x10,%esp
80106a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106aa0:	83 ec 08             	sub    $0x8,%esp
80106aa3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106aa9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106ab0:	50                   	push   %eax
80106ab1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106ab7:	01 f8                	add    %edi,%eax
80106ab9:	50                   	push   %eax
80106aba:	e8 41 f3 ff ff       	call   80105e00 <fetchint>
80106abf:	83 c4 10             	add    $0x10,%esp
80106ac2:	85 c0                	test   %eax,%eax
80106ac4:	78 26                	js     80106aec <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106ac6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106acc:	85 c0                	test   %eax,%eax
80106ace:	74 30                	je     80106b00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106ad0:	83 ec 08             	sub    $0x8,%esp
80106ad3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106ad6:	52                   	push   %edx
80106ad7:	50                   	push   %eax
80106ad8:	e8 63 f3 ff ff       	call   80105e40 <fetchstr>
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	85 c0                	test   %eax,%eax
80106ae2:	78 08                	js     80106aec <sys_exec+0xac>
  for(i=0;; i++){
80106ae4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106ae7:	83 fb 20             	cmp    $0x20,%ebx
80106aea:	75 b4                	jne    80106aa0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80106aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106aef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106af4:	5b                   	pop    %ebx
80106af5:	5e                   	pop    %esi
80106af6:	5f                   	pop    %edi
80106af7:	5d                   	pop    %ebp
80106af8:	c3                   	ret    
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106b00:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106b07:	00 00 00 00 
  return exec(path, argv);
80106b0b:	83 ec 08             	sub    $0x8,%esp
80106b0e:	56                   	push   %esi
80106b0f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106b15:	e8 36 a4 ff ff       	call   80100f50 <exec>
80106b1a:	83 c4 10             	add    $0x10,%esp
}
80106b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b20:	5b                   	pop    %ebx
80106b21:	5e                   	pop    %esi
80106b22:	5f                   	pop    %edi
80106b23:	5d                   	pop    %ebp
80106b24:	c3                   	ret    
80106b25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106b30 <sys_pipe>:

int
sys_pipe(void)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b35:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106b38:	53                   	push   %ebx
80106b39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b3c:	6a 08                	push   $0x8
80106b3e:	50                   	push   %eax
80106b3f:	6a 00                	push   $0x0
80106b41:	e8 9a f3 ff ff       	call   80105ee0 <argptr>
80106b46:	83 c4 10             	add    $0x10,%esp
80106b49:	85 c0                	test   %eax,%eax
80106b4b:	78 4a                	js     80106b97 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106b4d:	83 ec 08             	sub    $0x8,%esp
80106b50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b53:	50                   	push   %eax
80106b54:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106b57:	50                   	push   %eax
80106b58:	e8 73 cd ff ff       	call   801038d0 <pipealloc>
80106b5d:	83 c4 10             	add    $0x10,%esp
80106b60:	85 c0                	test   %eax,%eax
80106b62:	78 33                	js     80106b97 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b64:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106b67:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106b69:	e8 82 d3 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106b6e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80106b70:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106b74:	85 f6                	test   %esi,%esi
80106b76:	74 28                	je     80106ba0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80106b78:	83 c3 01             	add    $0x1,%ebx
80106b7b:	83 fb 10             	cmp    $0x10,%ebx
80106b7e:	75 f0                	jne    80106b70 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	ff 75 e0             	push   -0x20(%ebp)
80106b86:	e8 05 a8 ff ff       	call   80101390 <fileclose>
    fileclose(wf);
80106b8b:	58                   	pop    %eax
80106b8c:	ff 75 e4             	push   -0x1c(%ebp)
80106b8f:	e8 fc a7 ff ff       	call   80101390 <fileclose>
    return -1;
80106b94:	83 c4 10             	add    $0x10,%esp
80106b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b9c:	eb 53                	jmp    80106bf1 <sys_pipe+0xc1>
80106b9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106ba0:	8d 73 08             	lea    0x8(%ebx),%esi
80106ba3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106ba7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106baa:	e8 41 d3 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106baf:	31 d2                	xor    %edx,%edx
80106bb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106bb8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106bbc:	85 c9                	test   %ecx,%ecx
80106bbe:	74 20                	je     80106be0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106bc0:	83 c2 01             	add    $0x1,%edx
80106bc3:	83 fa 10             	cmp    $0x10,%edx
80106bc6:	75 f0                	jne    80106bb8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106bc8:	e8 23 d3 ff ff       	call   80103ef0 <myproc>
80106bcd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106bd4:	00 
80106bd5:	eb a9                	jmp    80106b80 <sys_pipe+0x50>
80106bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bde:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106be0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106be4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106be7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106be9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106bec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106bef:	31 c0                	xor    %eax,%eax
}
80106bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf4:	5b                   	pop    %ebx
80106bf5:	5e                   	pop    %esi
80106bf6:	5f                   	pop    %edi
80106bf7:	5d                   	pop    %ebp
80106bf8:	c3                   	ret    
80106bf9:	66 90                	xchg   %ax,%ax
80106bfb:	66 90                	xchg   %ax,%ax
80106bfd:	66 90                	xchg   %ax,%ax
80106bff:	90                   	nop

80106c00 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106c00:	e9 8b d4 ff ff       	jmp    80104090 <fork>
80106c05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c10 <sys_exit>:
}

int
sys_exit(void)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	83 ec 08             	sub    $0x8,%esp
  exit();
80106c16:	e8 85 d9 ff ff       	call   801045a0 <exit>
  return 0;  // not reached
}
80106c1b:	31 c0                	xor    %eax,%eax
80106c1d:	c9                   	leave  
80106c1e:	c3                   	ret    
80106c1f:	90                   	nop

80106c20 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80106c20:	e9 ab da ff ff       	jmp    801046d0 <wait>
80106c25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c30 <sys_kill>:
}

int
sys_kill(void)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c39:	50                   	push   %eax
80106c3a:	6a 00                	push   $0x0
80106c3c:	e8 4f f2 ff ff       	call   80105e90 <argint>
80106c41:	83 c4 10             	add    $0x10,%esp
80106c44:	85 c0                	test   %eax,%eax
80106c46:	78 18                	js     80106c60 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106c48:	83 ec 0c             	sub    $0xc,%esp
80106c4b:	ff 75 f4             	push   -0xc(%ebp)
80106c4e:	e8 1d dd ff ff       	call   80104970 <kill>
80106c53:	83 c4 10             	add    $0x10,%esp
}
80106c56:	c9                   	leave  
80106c57:	c3                   	ret    
80106c58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c5f:	90                   	nop
80106c60:	c9                   	leave  
    return -1;
80106c61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c66:	c3                   	ret    
80106c67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c6e:	66 90                	xchg   %ax,%ax

80106c70 <sys_getpid>:

int
sys_getpid(void)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106c76:	e8 75 d2 ff ff       	call   80103ef0 <myproc>
80106c7b:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c7e:	c9                   	leave  
80106c7f:	c3                   	ret    

80106c80 <sys_sbrk>:

int
sys_sbrk(void)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106c87:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106c8a:	50                   	push   %eax
80106c8b:	6a 00                	push   $0x0
80106c8d:	e8 fe f1 ff ff       	call   80105e90 <argint>
80106c92:	83 c4 10             	add    $0x10,%esp
80106c95:	85 c0                	test   %eax,%eax
80106c97:	78 27                	js     80106cc0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106c99:	e8 52 d2 ff ff       	call   80103ef0 <myproc>
  if(growproc(n) < 0)
80106c9e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106ca1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106ca3:	ff 75 f4             	push   -0xc(%ebp)
80106ca6:	e8 65 d3 ff ff       	call   80104010 <growproc>
80106cab:	83 c4 10             	add    $0x10,%esp
80106cae:	85 c0                	test   %eax,%eax
80106cb0:	78 0e                	js     80106cc0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106cb2:	89 d8                	mov    %ebx,%eax
80106cb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106cb7:	c9                   	leave  
80106cb8:	c3                   	ret    
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106cc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106cc5:	eb eb                	jmp    80106cb2 <sys_sbrk+0x32>
80106cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cce:	66 90                	xchg   %ax,%ax

80106cd0 <sys_sleep>:

int
sys_sleep(void)
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106cd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80106cda:	50                   	push   %eax
80106cdb:	6a 00                	push   $0x0
80106cdd:	e8 ae f1 ff ff       	call   80105e90 <argint>
80106ce2:	83 c4 10             	add    $0x10,%esp
80106ce5:	85 c0                	test   %eax,%eax
80106ce7:	0f 88 8a 00 00 00    	js     80106d77 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106ced:	83 ec 0c             	sub    $0xc,%esp
80106cf0:	68 00 67 11 80       	push   $0x80116700
80106cf5:	e8 16 ee ff ff       	call   80105b10 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106cfd:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
  while(ticks - ticks0 < n){
80106d03:	83 c4 10             	add    $0x10,%esp
80106d06:	85 d2                	test   %edx,%edx
80106d08:	75 27                	jne    80106d31 <sys_sleep+0x61>
80106d0a:	eb 54                	jmp    80106d60 <sys_sleep+0x90>
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106d10:	83 ec 08             	sub    $0x8,%esp
80106d13:	68 00 67 11 80       	push   $0x80116700
80106d18:	68 e0 66 11 80       	push   $0x801166e0
80106d1d:	e8 2e db ff ff       	call   80104850 <sleep>
  while(ticks - ticks0 < n){
80106d22:	a1 e0 66 11 80       	mov    0x801166e0,%eax
80106d27:	83 c4 10             	add    $0x10,%esp
80106d2a:	29 d8                	sub    %ebx,%eax
80106d2c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80106d2f:	73 2f                	jae    80106d60 <sys_sleep+0x90>
    if(myproc()->killed){
80106d31:	e8 ba d1 ff ff       	call   80103ef0 <myproc>
80106d36:	8b 40 24             	mov    0x24(%eax),%eax
80106d39:	85 c0                	test   %eax,%eax
80106d3b:	74 d3                	je     80106d10 <sys_sleep+0x40>
      release(&tickslock);
80106d3d:	83 ec 0c             	sub    $0xc,%esp
80106d40:	68 00 67 11 80       	push   $0x80116700
80106d45:	e8 66 ed ff ff       	call   80105ab0 <release>
  }
  release(&tickslock);
  return 0;
}
80106d4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80106d4d:	83 c4 10             	add    $0x10,%esp
80106d50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d55:	c9                   	leave  
80106d56:	c3                   	ret    
80106d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d5e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106d60:	83 ec 0c             	sub    $0xc,%esp
80106d63:	68 00 67 11 80       	push   $0x80116700
80106d68:	e8 43 ed ff ff       	call   80105ab0 <release>
  return 0;
80106d6d:	83 c4 10             	add    $0x10,%esp
80106d70:	31 c0                	xor    %eax,%eax
}
80106d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106d75:	c9                   	leave  
80106d76:	c3                   	ret    
    return -1;
80106d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d7c:	eb f4                	jmp    80106d72 <sys_sleep+0xa2>
80106d7e:	66 90                	xchg   %ax,%ax

80106d80 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	53                   	push   %ebx
80106d84:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106d87:	68 00 67 11 80       	push   $0x80116700
80106d8c:	e8 7f ed ff ff       	call   80105b10 <acquire>
  xticks = ticks;
80106d91:	8b 1d e0 66 11 80    	mov    0x801166e0,%ebx
  release(&tickslock);
80106d97:	c7 04 24 00 67 11 80 	movl   $0x80116700,(%esp)
80106d9e:	e8 0d ed ff ff       	call   80105ab0 <release>
  return xticks;
}
80106da3:	89 d8                	mov    %ebx,%eax
80106da5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106da8:	c9                   	leave  
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106db0 <sys_find_fibonacci_number>:

// system call to find the nth fibonacci number:

int sys_find_fibonacci_number(void){
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	53                   	push   %ebx
80106db4:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
80106db7:	e8 34 d1 ff ff       	call   80103ef0 <myproc>
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
80106dbc:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
80106dbf:	8b 40 18             	mov    0x18(%eax),%eax
80106dc2:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
80106dc5:	53                   	push   %ebx
80106dc6:	68 9c 94 10 80       	push   $0x8010949c
80106dcb:	e8 20 99 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling find_fibonacci_number(%d)\n", n);
80106dd0:	58                   	pop    %eax
80106dd1:	5a                   	pop    %edx
80106dd2:	53                   	push   %ebx
80106dd3:	68 d0 94 10 80       	push   $0x801094d0
80106dd8:	e8 13 99 ff ff       	call   801006f0 <cprintf>
  return find_fibonacci_number(n);
80106ddd:	89 1c 24             	mov    %ebx,(%esp)
80106de0:	e8 cb dc ff ff       	call   80104ab0 <find_fibonacci_number>
}
80106de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106de8:	c9                   	leave  
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106df0 <sys_find_most_callee>:

// system call to find the most used system call:

int sys_find_most_callee(void){
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_find_most_callee is called\n");
80106df6:	68 00 95 10 80       	push   $0x80109500
80106dfb:	e8 f0 98 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling find_most_callee\n");
80106e00:	c7 04 24 28 95 10 80 	movl   $0x80109528,(%esp)
80106e07:	e8 e4 98 ff ff       	call   801006f0 <cprintf>
  return find_most_callee();
80106e0c:	83 c4 10             	add    $0x10,%esp
}
80106e0f:	c9                   	leave  
  return find_most_callee();
80106e10:	e9 2b df ff ff       	jmp    80104d40 <find_most_callee>
80106e15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e20 <sys_get_children_count>:

// system call to get children count of current process:

int sys_get_children_count(void){
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_get_children_count is called\n");
80106e26:	68 50 95 10 80       	push   $0x80109550
80106e2b:	e8 c0 98 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling get_children_count\n");
80106e30:	c7 04 24 7c 95 10 80 	movl   $0x8010957c,(%esp)
80106e37:	e8 b4 98 ff ff       	call   801006f0 <cprintf>
  return get_children_count();
80106e3c:	83 c4 10             	add    $0x10,%esp
}
80106e3f:	c9                   	leave  
  return get_children_count();
80106e40:	e9 2b df ff ff       	jmp    80104d70 <get_children_count>
80106e45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e50 <sys_kill_first_child_process>:

// system call to kill the first child of a process:

int sys_kill_first_child_process(void){
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_kill_first_child_process is called\n");
80106e56:	68 a4 95 10 80       	push   $0x801095a4
80106e5b:	e8 90 98 ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling kill_first_child_process\n");
80106e60:	c7 04 24 d4 95 10 80 	movl   $0x801095d4,(%esp)
80106e67:	e8 84 98 ff ff       	call   801006f0 <cprintf>
  return kill_first_child_process();
80106e6c:	83 c4 10             	add    $0x10,%esp
}
80106e6f:	c9                   	leave  
  return kill_first_child_process();
80106e70:	e9 6b df ff ff       	jmp    80104de0 <kill_first_child_process>
80106e75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <sys_set_proc_queue>:

void
sys_set_proc_queue(void)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	83 ec 20             	sub    $0x20,%esp
  int pid, queue;
  argint(0, &pid);
80106e86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106e89:	50                   	push   %eax
80106e8a:	6a 00                	push   $0x0
80106e8c:	e8 ff ef ff ff       	call   80105e90 <argint>
  argint(1, &queue);
80106e91:	58                   	pop    %eax
80106e92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e95:	5a                   	pop    %edx
80106e96:	50                   	push   %eax
80106e97:	6a 01                	push   $0x1
80106e99:	e8 f2 ef ff ff       	call   80105e90 <argint>
  set_proc_queue(pid, queue);
80106e9e:	59                   	pop    %ecx
80106e9f:	58                   	pop    %eax
80106ea0:	ff 75 f4             	push   -0xc(%ebp)
80106ea3:	ff 75 f0             	push   -0x10(%ebp)
80106ea6:	e8 a5 df ff ff       	call   80104e50 <set_proc_queue>
}
80106eab:	83 c4 10             	add    $0x10,%esp
80106eae:	c9                   	leave  
80106eaf:	c3                   	ret    

80106eb0 <sys_set_lottery_params>:

void
sys_set_lottery_params(void)
{
80106eb0:	55                   	push   %ebp
80106eb1:	89 e5                	mov    %esp,%ebp
80106eb3:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket_chance;
  argint(0, &pid);
80106eb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106eb9:	50                   	push   %eax
80106eba:	6a 00                	push   $0x0
80106ebc:	e8 cf ef ff ff       	call   80105e90 <argint>
  argint(1, &ticket_chance);
80106ec1:	58                   	pop    %eax
80106ec2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ec5:	5a                   	pop    %edx
80106ec6:	50                   	push   %eax
80106ec7:	6a 01                	push   $0x1
80106ec9:	e8 c2 ef ff ff       	call   80105e90 <argint>
  set_lottery_params(pid, ticket_chance);
80106ece:	59                   	pop    %ecx
80106ecf:	58                   	pop    %eax
80106ed0:	ff 75 f4             	push   -0xc(%ebp)
80106ed3:	ff 75 f0             	push   -0x10(%ebp)
80106ed6:	e8 c5 df ff ff       	call   80104ea0 <set_lottery_params>
}
80106edb:	83 c4 10             	add    $0x10,%esp
80106ede:	c9                   	leave  
80106edf:	c3                   	ret    

80106ee0 <sys_print_all_procs>:

void
sys_print_all_procs(void)
{
  print_all_procs();
80106ee0:	e9 4b e0 ff ff       	jmp    80104f30 <print_all_procs>
80106ee5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ef0 <sys_sem_init>:
}

void sys_sem_init(void)
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	83 ec 20             	sub    $0x20,%esp
  int i, v, m;
  if (argint(0, &i) < 0)
80106ef6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ef9:	50                   	push   %eax
80106efa:	6a 00                	push   $0x0
80106efc:	e8 8f ef ff ff       	call   80105e90 <argint>
80106f01:	83 c4 10             	add    $0x10,%esp
80106f04:	85 c0                	test   %eax,%eax
80106f06:	78 3e                	js     80106f46 <sys_sem_init+0x56>
    return;
  if (argint(1, &v) < 0)
80106f08:	83 ec 08             	sub    $0x8,%esp
80106f0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f0e:	50                   	push   %eax
80106f0f:	6a 01                	push   $0x1
80106f11:	e8 7a ef ff ff       	call   80105e90 <argint>
80106f16:	83 c4 10             	add    $0x10,%esp
80106f19:	85 c0                	test   %eax,%eax
80106f1b:	78 29                	js     80106f46 <sys_sem_init+0x56>
    return;
  if (argint(2, &m) < 0)
80106f1d:	83 ec 08             	sub    $0x8,%esp
80106f20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f23:	50                   	push   %eax
80106f24:	6a 02                	push   $0x2
80106f26:	e8 65 ef ff ff       	call   80105e90 <argint>
80106f2b:	83 c4 10             	add    $0x10,%esp
80106f2e:	85 c0                	test   %eax,%eax
80106f30:	78 14                	js     80106f46 <sys_sem_init+0x56>
    return;
  sem_init(i, v, m);
80106f32:	83 ec 04             	sub    $0x4,%esp
80106f35:	ff 75 f4             	push   -0xc(%ebp)
80106f38:	ff 75 f0             	push   -0x10(%ebp)
80106f3b:	ff 75 ec             	push   -0x14(%ebp)
80106f3e:	e8 4d e3 ff ff       	call   80105290 <sem_init>
  return;
80106f43:	83 c4 10             	add    $0x10,%esp
}
80106f46:	c9                   	leave  
80106f47:	c3                   	ret    
80106f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4f:	90                   	nop

80106f50 <sys_sem_acquire>:

void sys_sem_acquire(void)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0)
80106f56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f59:	50                   	push   %eax
80106f5a:	6a 00                	push   $0x0
80106f5c:	e8 2f ef ff ff       	call   80105e90 <argint>
80106f61:	83 c4 10             	add    $0x10,%esp
80106f64:	85 c0                	test   %eax,%eax
80106f66:	78 0e                	js     80106f76 <sys_sem_acquire+0x26>
    return;
  sem_acquire(i);
80106f68:	83 ec 0c             	sub    $0xc,%esp
80106f6b:	ff 75 f4             	push   -0xc(%ebp)
80106f6e:	e8 6d e3 ff ff       	call   801052e0 <sem_acquire>
  return;
80106f73:	83 c4 10             	add    $0x10,%esp
}
80106f76:	c9                   	leave  
80106f77:	c3                   	ret    
80106f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f7f:	90                   	nop

80106f80 <sys_sem_release>:

void sys_sem_release(void)
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0)
80106f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f89:	50                   	push   %eax
80106f8a:	6a 00                	push   $0x0
80106f8c:	e8 ff ee ff ff       	call   80105e90 <argint>
80106f91:	83 c4 10             	add    $0x10,%esp
80106f94:	85 c0                	test   %eax,%eax
80106f96:	78 0e                	js     80106fa6 <sys_sem_release+0x26>
    return;
  sem_release(i);
80106f98:	83 ec 0c             	sub    $0xc,%esp
80106f9b:	ff 75 f4             	push   -0xc(%ebp)
80106f9e:	e8 fd e3 ff ff       	call   801053a0 <sem_release>
  return;
80106fa3:	83 c4 10             	add    $0x10,%esp
}
80106fa6:	c9                   	leave  
80106fa7:	c3                   	ret    
80106fa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106faf:	90                   	nop

80106fb0 <sys_producer>:

void sys_producer(void)
{
80106fb0:	55                   	push   %ebp
80106fb1:	89 e5                	mov    %esp,%ebp
80106fb3:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0)
80106fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fb9:	50                   	push   %eax
80106fba:	6a 00                	push   $0x0
80106fbc:	e8 cf ee ff ff       	call   80105e90 <argint>
80106fc1:	83 c4 10             	add    $0x10,%esp
80106fc4:	85 c0                	test   %eax,%eax
80106fc6:	78 0e                	js     80106fd6 <sys_producer+0x26>
    return;
  producer(i);
80106fc8:	83 ec 0c             	sub    $0xc,%esp
80106fcb:	ff 75 f4             	push   -0xc(%ebp)
80106fce:	e8 ad e4 ff ff       	call   80105480 <producer>
80106fd3:	83 c4 10             	add    $0x10,%esp
}
80106fd6:	c9                   	leave  
80106fd7:	c3                   	ret    
80106fd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fdf:	90                   	nop

80106fe0 <sys_consumer>:

void sys_consumer(void)
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	83 ec 20             	sub    $0x20,%esp
  int i;
  if (argint(0, &i) < 0)
80106fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fe9:	50                   	push   %eax
80106fea:	6a 00                	push   $0x0
80106fec:	e8 9f ee ff ff       	call   80105e90 <argint>
80106ff1:	83 c4 10             	add    $0x10,%esp
80106ff4:	85 c0                	test   %eax,%eax
80106ff6:	78 0e                	js     80107006 <sys_consumer+0x26>
    return;
  consumer(i);
80106ff8:	83 ec 0c             	sub    $0xc,%esp
80106ffb:	ff 75 f4             	push   -0xc(%ebp)
80106ffe:	e8 ed e4 ff ff       	call   801054f0 <consumer>
80107003:	83 c4 10             	add    $0x10,%esp
}
80107006:	c9                   	leave  
80107007:	c3                   	ret    
80107008:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010700f:	90                   	nop

80107010 <sys_cv_wait>:

void sys_cv_wait(void)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	83 ec 1c             	sub    $0x1c,%esp
  struct condvar *c;
  if (argptr(0, (void *)&c, sizeof(c)) < 0)
80107016:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107019:	6a 04                	push   $0x4
8010701b:	50                   	push   %eax
8010701c:	6a 00                	push   $0x0
8010701e:	e8 bd ee ff ff       	call   80105ee0 <argptr>
80107023:	83 c4 10             	add    $0x10,%esp
80107026:	85 c0                	test   %eax,%eax
80107028:	78 0e                	js     80107038 <sys_cv_wait+0x28>
    return;
  cv_wait(c);
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	ff 75 f4             	push   -0xc(%ebp)
80107030:	e8 9b e5 ff ff       	call   801055d0 <cv_wait>
80107035:	83 c4 10             	add    $0x10,%esp
}
80107038:	c9                   	leave  
80107039:	c3                   	ret    
8010703a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107040 <sys_cv_signal>:

void sys_cv_signal(void)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	83 ec 1c             	sub    $0x1c,%esp
  struct condvar *c;
  if (argptr(0, (void *)&c, sizeof(c)) < 0)
80107046:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107049:	6a 04                	push   $0x4
8010704b:	50                   	push   %eax
8010704c:	6a 00                	push   $0x0
8010704e:	e8 8d ee ff ff       	call   80105ee0 <argptr>
80107053:	83 c4 10             	add    $0x10,%esp
80107056:	85 c0                	test   %eax,%eax
80107058:	78 0e                	js     80107068 <sys_cv_signal+0x28>
    return;
  cv_signal(c);
8010705a:	83 ec 0c             	sub    $0xc,%esp
8010705d:	ff 75 f4             	push   -0xc(%ebp)
80107060:	e8 7b e5 ff ff       	call   801055e0 <cv_signal>
80107065:	83 c4 10             	add    $0x10,%esp
}
80107068:	c9                   	leave  
80107069:	c3                   	ret    
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107070 <sys_reader>:

void sys_reader(void)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	83 ec 20             	sub    $0x20,%esp
  struct condvar *condvar;
  int i;
  if (argint(0, &i) < 0)
80107076:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107079:	50                   	push   %eax
8010707a:	6a 00                	push   $0x0
8010707c:	e8 0f ee ff ff       	call   80105e90 <argint>
80107081:	83 c4 10             	add    $0x10,%esp
80107084:	85 c0                	test   %eax,%eax
80107086:	78 28                	js     801070b0 <sys_reader+0x40>
    return;
  if (argptr(1, (void *)&condvar, sizeof(condvar)) < 0)
80107088:	83 ec 04             	sub    $0x4,%esp
8010708b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010708e:	6a 04                	push   $0x4
80107090:	50                   	push   %eax
80107091:	6a 01                	push   $0x1
80107093:	e8 48 ee ff ff       	call   80105ee0 <argptr>
80107098:	83 c4 10             	add    $0x10,%esp
8010709b:	85 c0                	test   %eax,%eax
8010709d:	78 11                	js     801070b0 <sys_reader+0x40>
    return;
  reader(i, condvar);
8010709f:	83 ec 08             	sub    $0x8,%esp
801070a2:	ff 75 f0             	push   -0x10(%ebp)
801070a5:	ff 75 f4             	push   -0xc(%ebp)
801070a8:	e8 93 e5 ff ff       	call   80105640 <reader>
801070ad:	83 c4 10             	add    $0x10,%esp
}
801070b0:	c9                   	leave  
801070b1:	c3                   	ret    
801070b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070c0 <sys_writer>:

void sys_writer(void)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	83 ec 20             	sub    $0x20,%esp
  struct condvar *condvar;
  int i;
  if (argint(0, &i) < 0)
801070c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070c9:	50                   	push   %eax
801070ca:	6a 00                	push   $0x0
801070cc:	e8 bf ed ff ff       	call   80105e90 <argint>
801070d1:	83 c4 10             	add    $0x10,%esp
801070d4:	85 c0                	test   %eax,%eax
801070d6:	78 28                	js     80107100 <sys_writer+0x40>
    return;
  if (argptr(1, (void *)&condvar, sizeof(condvar)) < 0)
801070d8:	83 ec 04             	sub    $0x4,%esp
801070db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070de:	6a 04                	push   $0x4
801070e0:	50                   	push   %eax
801070e1:	6a 01                	push   $0x1
801070e3:	e8 f8 ed ff ff       	call   80105ee0 <argptr>
801070e8:	83 c4 10             	add    $0x10,%esp
801070eb:	85 c0                	test   %eax,%eax
801070ed:	78 11                	js     80107100 <sys_writer+0x40>
    return;
  writer(i, condvar);
801070ef:	83 ec 08             	sub    $0x8,%esp
801070f2:	ff 75 f0             	push   -0x10(%ebp)
801070f5:	ff 75 f4             	push   -0xc(%ebp)
801070f8:	e8 13 e6 ff ff       	call   80105710 <writer>
801070fd:	83 c4 10             	add    $0x10,%esp
}
80107100:	c9                   	leave  
80107101:	c3                   	ret    

80107102 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107102:	1e                   	push   %ds
  pushl %es
80107103:	06                   	push   %es
  pushl %fs
80107104:	0f a0                	push   %fs
  pushl %gs
80107106:	0f a8                	push   %gs
  pushal
80107108:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80107109:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010710d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010710f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80107111:	54                   	push   %esp
  call trap
80107112:	e8 c9 00 00 00       	call   801071e0 <trap>
  addl $4, %esp
80107117:	83 c4 04             	add    $0x4,%esp

8010711a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010711a:	61                   	popa   
  popl %gs
8010711b:	0f a9                	pop    %gs
  popl %fs
8010711d:	0f a1                	pop    %fs
  popl %es
8010711f:	07                   	pop    %es
  popl %ds
80107120:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107121:	83 c4 08             	add    $0x8,%esp
  iret
80107124:	cf                   	iret   
80107125:	66 90                	xchg   %ax,%ax
80107127:	66 90                	xchg   %ax,%ax
80107129:	66 90                	xchg   %ax,%ax
8010712b:	66 90                	xchg   %ax,%ax
8010712d:	66 90                	xchg   %ax,%ax
8010712f:	90                   	nop

80107130 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107130:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107131:	31 c0                	xor    %eax,%eax
{
80107133:	89 e5                	mov    %esp,%ebp
80107135:	83 ec 08             	sub    $0x8,%esp
80107138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010713f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107140:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80107147:	c7 04 c5 42 67 11 80 	movl   $0x8e000008,-0x7fee98be(,%eax,8)
8010714e:	08 00 00 8e 
80107152:	66 89 14 c5 40 67 11 	mov    %dx,-0x7fee98c0(,%eax,8)
80107159:	80 
8010715a:	c1 ea 10             	shr    $0x10,%edx
8010715d:	66 89 14 c5 46 67 11 	mov    %dx,-0x7fee98ba(,%eax,8)
80107164:	80 
  for(i = 0; i < 256; i++)
80107165:	83 c0 01             	add    $0x1,%eax
80107168:	3d 00 01 00 00       	cmp    $0x100,%eax
8010716d:	75 d1                	jne    80107140 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010716f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107172:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107177:	c7 05 42 69 11 80 08 	movl   $0xef000008,0x80116942
8010717e:	00 00 ef 
  initlock(&tickslock, "time");
80107181:	68 02 96 10 80       	push   $0x80109602
80107186:	68 00 67 11 80       	push   $0x80116700
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010718b:	66 a3 40 69 11 80    	mov    %ax,0x80116940
80107191:	c1 e8 10             	shr    $0x10,%eax
80107194:	66 a3 46 69 11 80    	mov    %ax,0x80116946
  initlock(&tickslock, "time");
8010719a:	e8 a1 e7 ff ff       	call   80105940 <initlock>
}
8010719f:	83 c4 10             	add    $0x10,%esp
801071a2:	c9                   	leave  
801071a3:	c3                   	ret    
801071a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071af:	90                   	nop

801071b0 <idtinit>:

void
idtinit(void)
{
801071b0:	55                   	push   %ebp
  pd[0] = size-1;
801071b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801071b6:	89 e5                	mov    %esp,%ebp
801071b8:	83 ec 10             	sub    $0x10,%esp
801071bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801071bf:	b8 40 67 11 80       	mov    $0x80116740,%eax
801071c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801071c8:	c1 e8 10             	shr    $0x10,%eax
801071cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801071cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801071d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801071d5:	c9                   	leave  
801071d6:	c3                   	ret    
801071d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071de:	66 90                	xchg   %ax,%ax

801071e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
801071e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801071ec:	8b 43 30             	mov    0x30(%ebx),%eax
801071ef:	83 f8 40             	cmp    $0x40,%eax
801071f2:	0f 84 68 01 00 00    	je     80107360 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801071f8:	83 e8 20             	sub    $0x20,%eax
801071fb:	83 f8 1f             	cmp    $0x1f,%eax
801071fe:	0f 87 8c 00 00 00    	ja     80107290 <trap+0xb0>
80107204:	ff 24 85 a8 96 10 80 	jmp    *-0x7fef6958(,%eax,4)
8010720b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010720f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107210:	e8 cb b4 ff ff       	call   801026e0 <ideintr>
    lapiceoi();
80107215:	e8 96 bb ff ff       	call   80102db0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010721a:	e8 d1 cc ff ff       	call   80103ef0 <myproc>
8010721f:	85 c0                	test   %eax,%eax
80107221:	74 1d                	je     80107240 <trap+0x60>
80107223:	e8 c8 cc ff ff       	call   80103ef0 <myproc>
80107228:	8b 50 24             	mov    0x24(%eax),%edx
8010722b:	85 d2                	test   %edx,%edx
8010722d:	74 11                	je     80107240 <trap+0x60>
8010722f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107233:	83 e0 03             	and    $0x3,%eax
80107236:	66 83 f8 03          	cmp    $0x3,%ax
8010723a:	0f 84 e8 01 00 00    	je     80107428 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107240:	e8 ab cc ff ff       	call   80103ef0 <myproc>
80107245:	85 c0                	test   %eax,%eax
80107247:	74 0f                	je     80107258 <trap+0x78>
80107249:	e8 a2 cc ff ff       	call   80103ef0 <myproc>
8010724e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107252:	0f 84 b8 00 00 00    	je     80107310 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107258:	e8 93 cc ff ff       	call   80103ef0 <myproc>
8010725d:	85 c0                	test   %eax,%eax
8010725f:	74 1d                	je     8010727e <trap+0x9e>
80107261:	e8 8a cc ff ff       	call   80103ef0 <myproc>
80107266:	8b 40 24             	mov    0x24(%eax),%eax
80107269:	85 c0                	test   %eax,%eax
8010726b:	74 11                	je     8010727e <trap+0x9e>
8010726d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107271:	83 e0 03             	and    $0x3,%eax
80107274:	66 83 f8 03          	cmp    $0x3,%ax
80107278:	0f 84 0f 01 00 00    	je     8010738d <trap+0x1ad>
    exit();
}
8010727e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107281:	5b                   	pop    %ebx
80107282:	5e                   	pop    %esi
80107283:	5f                   	pop    %edi
80107284:	5d                   	pop    %ebp
80107285:	c3                   	ret    
80107286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80107290:	e8 5b cc ff ff       	call   80103ef0 <myproc>
80107295:	8b 7b 38             	mov    0x38(%ebx),%edi
80107298:	85 c0                	test   %eax,%eax
8010729a:	0f 84 a2 01 00 00    	je     80107442 <trap+0x262>
801072a0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801072a4:	0f 84 98 01 00 00    	je     80107442 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801072aa:	0f 20 d1             	mov    %cr2,%ecx
801072ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801072b0:	e8 1b cc ff ff       	call   80103ed0 <cpuid>
801072b5:	8b 73 30             	mov    0x30(%ebx),%esi
801072b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801072bb:	8b 43 34             	mov    0x34(%ebx),%eax
801072be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801072c1:	e8 2a cc ff ff       	call   80103ef0 <myproc>
801072c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072c9:	e8 22 cc ff ff       	call   80103ef0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801072ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801072d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801072d4:	51                   	push   %ecx
801072d5:	57                   	push   %edi
801072d6:	52                   	push   %edx
801072d7:	ff 75 e4             	push   -0x1c(%ebp)
801072da:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
801072db:	8b 75 e0             	mov    -0x20(%ebp),%esi
801072de:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801072e1:	56                   	push   %esi
801072e2:	ff 70 10             	push   0x10(%eax)
801072e5:	68 64 96 10 80       	push   $0x80109664
801072ea:	e8 01 94 ff ff       	call   801006f0 <cprintf>
    myproc()->killed = 1;
801072ef:	83 c4 20             	add    $0x20,%esp
801072f2:	e8 f9 cb ff ff       	call   80103ef0 <myproc>
801072f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801072fe:	e8 ed cb ff ff       	call   80103ef0 <myproc>
80107303:	85 c0                	test   %eax,%eax
80107305:	0f 85 18 ff ff ff    	jne    80107223 <trap+0x43>
8010730b:	e9 30 ff ff ff       	jmp    80107240 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80107310:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107314:	0f 85 3e ff ff ff    	jne    80107258 <trap+0x78>
    yield();
8010731a:	e8 e1 d4 ff ff       	call   80104800 <yield>
8010731f:	e9 34 ff ff ff       	jmp    80107258 <trap+0x78>
80107324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107328:	8b 7b 38             	mov    0x38(%ebx),%edi
8010732b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010732f:	e8 9c cb ff ff       	call   80103ed0 <cpuid>
80107334:	57                   	push   %edi
80107335:	56                   	push   %esi
80107336:	50                   	push   %eax
80107337:	68 0c 96 10 80       	push   $0x8010960c
8010733c:	e8 af 93 ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80107341:	e8 6a ba ff ff       	call   80102db0 <lapiceoi>
    break;
80107346:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107349:	e8 a2 cb ff ff       	call   80103ef0 <myproc>
8010734e:	85 c0                	test   %eax,%eax
80107350:	0f 85 cd fe ff ff    	jne    80107223 <trap+0x43>
80107356:	e9 e5 fe ff ff       	jmp    80107240 <trap+0x60>
8010735b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010735f:	90                   	nop
    if(myproc()->killed)
80107360:	e8 8b cb ff ff       	call   80103ef0 <myproc>
80107365:	8b 70 24             	mov    0x24(%eax),%esi
80107368:	85 f6                	test   %esi,%esi
8010736a:	0f 85 c8 00 00 00    	jne    80107438 <trap+0x258>
    myproc()->tf = tf;
80107370:	e8 7b cb ff ff       	call   80103ef0 <myproc>
80107375:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80107378:	e8 53 ec ff ff       	call   80105fd0 <syscall>
    if(myproc()->killed)
8010737d:	e8 6e cb ff ff       	call   80103ef0 <myproc>
80107382:	8b 48 24             	mov    0x24(%eax),%ecx
80107385:	85 c9                	test   %ecx,%ecx
80107387:	0f 84 f1 fe ff ff    	je     8010727e <trap+0x9e>
}
8010738d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107390:	5b                   	pop    %ebx
80107391:	5e                   	pop    %esi
80107392:	5f                   	pop    %edi
80107393:	5d                   	pop    %ebp
      exit();
80107394:	e9 07 d2 ff ff       	jmp    801045a0 <exit>
80107399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
801073a0:	e8 3b 02 00 00       	call   801075e0 <uartintr>
    lapiceoi();
801073a5:	e8 06 ba ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801073aa:	e8 41 cb ff ff       	call   80103ef0 <myproc>
801073af:	85 c0                	test   %eax,%eax
801073b1:	0f 85 6c fe ff ff    	jne    80107223 <trap+0x43>
801073b7:	e9 84 fe ff ff       	jmp    80107240 <trap+0x60>
801073bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801073c0:	e8 ab b8 ff ff       	call   80102c70 <kbdintr>
    lapiceoi();
801073c5:	e8 e6 b9 ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801073ca:	e8 21 cb ff ff       	call   80103ef0 <myproc>
801073cf:	85 c0                	test   %eax,%eax
801073d1:	0f 85 4c fe ff ff    	jne    80107223 <trap+0x43>
801073d7:	e9 64 fe ff ff       	jmp    80107240 <trap+0x60>
801073dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801073e0:	e8 eb ca ff ff       	call   80103ed0 <cpuid>
801073e5:	85 c0                	test   %eax,%eax
801073e7:	0f 85 28 fe ff ff    	jne    80107215 <trap+0x35>
      acquire(&tickslock);
801073ed:	83 ec 0c             	sub    $0xc,%esp
801073f0:	68 00 67 11 80       	push   $0x80116700
801073f5:	e8 16 e7 ff ff       	call   80105b10 <acquire>
      wakeup(&ticks);
801073fa:	c7 04 24 e0 66 11 80 	movl   $0x801166e0,(%esp)
      ticks++;
80107401:	83 05 e0 66 11 80 01 	addl   $0x1,0x801166e0
      wakeup(&ticks);
80107408:	e8 03 d5 ff ff       	call   80104910 <wakeup>
      release(&tickslock);
8010740d:	c7 04 24 00 67 11 80 	movl   $0x80116700,(%esp)
80107414:	e8 97 e6 ff ff       	call   80105ab0 <release>
80107419:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010741c:	e9 f4 fd ff ff       	jmp    80107215 <trap+0x35>
80107421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80107428:	e8 73 d1 ff ff       	call   801045a0 <exit>
8010742d:	e9 0e fe ff ff       	jmp    80107240 <trap+0x60>
80107432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107438:	e8 63 d1 ff ff       	call   801045a0 <exit>
8010743d:	e9 2e ff ff ff       	jmp    80107370 <trap+0x190>
80107442:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107445:	e8 86 ca ff ff       	call   80103ed0 <cpuid>
8010744a:	83 ec 0c             	sub    $0xc,%esp
8010744d:	56                   	push   %esi
8010744e:	57                   	push   %edi
8010744f:	50                   	push   %eax
80107450:	ff 73 30             	push   0x30(%ebx)
80107453:	68 30 96 10 80       	push   $0x80109630
80107458:	e8 93 92 ff ff       	call   801006f0 <cprintf>
      panic("trap");
8010745d:	83 c4 14             	add    $0x14,%esp
80107460:	68 07 96 10 80       	push   $0x80109607
80107465:	e8 16 8f ff ff       	call   80100380 <panic>
8010746a:	66 90                	xchg   %ax,%ax
8010746c:	66 90                	xchg   %ax,%ax
8010746e:	66 90                	xchg   %ax,%ax

80107470 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80107470:	a1 40 6f 11 80       	mov    0x80116f40,%eax
80107475:	85 c0                	test   %eax,%eax
80107477:	74 17                	je     80107490 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107479:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010747e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010747f:	a8 01                	test   $0x1,%al
80107481:	74 0d                	je     80107490 <uartgetc+0x20>
80107483:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107488:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80107489:	0f b6 c0             	movzbl %al,%eax
8010748c:	c3                   	ret    
8010748d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107495:	c3                   	ret    
80107496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749d:	8d 76 00             	lea    0x0(%esi),%esi

801074a0 <uartinit>:
{
801074a0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801074a1:	31 c9                	xor    %ecx,%ecx
801074a3:	89 c8                	mov    %ecx,%eax
801074a5:	89 e5                	mov    %esp,%ebp
801074a7:	57                   	push   %edi
801074a8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801074ad:	56                   	push   %esi
801074ae:	89 fa                	mov    %edi,%edx
801074b0:	53                   	push   %ebx
801074b1:	83 ec 1c             	sub    $0x1c,%esp
801074b4:	ee                   	out    %al,(%dx)
801074b5:	be fb 03 00 00       	mov    $0x3fb,%esi
801074ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801074bf:	89 f2                	mov    %esi,%edx
801074c1:	ee                   	out    %al,(%dx)
801074c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801074c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801074cc:	ee                   	out    %al,(%dx)
801074cd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801074d2:	89 c8                	mov    %ecx,%eax
801074d4:	89 da                	mov    %ebx,%edx
801074d6:	ee                   	out    %al,(%dx)
801074d7:	b8 03 00 00 00       	mov    $0x3,%eax
801074dc:	89 f2                	mov    %esi,%edx
801074de:	ee                   	out    %al,(%dx)
801074df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801074e4:	89 c8                	mov    %ecx,%eax
801074e6:	ee                   	out    %al,(%dx)
801074e7:	b8 01 00 00 00       	mov    $0x1,%eax
801074ec:	89 da                	mov    %ebx,%edx
801074ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801074ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801074f4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801074f5:	3c ff                	cmp    $0xff,%al
801074f7:	74 78                	je     80107571 <uartinit+0xd1>
  uart = 1;
801074f9:	c7 05 40 6f 11 80 01 	movl   $0x1,0x80116f40
80107500:	00 00 00 
80107503:	89 fa                	mov    %edi,%edx
80107505:	ec                   	in     (%dx),%al
80107506:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010750b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010750c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010750f:	bf 28 97 10 80       	mov    $0x80109728,%edi
80107514:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80107519:	6a 00                	push   $0x0
8010751b:	6a 04                	push   $0x4
8010751d:	e8 fe b3 ff ff       	call   80102920 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80107522:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80107526:	83 c4 10             	add    $0x10,%esp
80107529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80107530:	a1 40 6f 11 80       	mov    0x80116f40,%eax
80107535:	bb 80 00 00 00       	mov    $0x80,%ebx
8010753a:	85 c0                	test   %eax,%eax
8010753c:	75 14                	jne    80107552 <uartinit+0xb2>
8010753e:	eb 23                	jmp    80107563 <uartinit+0xc3>
    microdelay(10);
80107540:	83 ec 0c             	sub    $0xc,%esp
80107543:	6a 0a                	push   $0xa
80107545:	e8 86 b8 ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010754a:	83 c4 10             	add    $0x10,%esp
8010754d:	83 eb 01             	sub    $0x1,%ebx
80107550:	74 07                	je     80107559 <uartinit+0xb9>
80107552:	89 f2                	mov    %esi,%edx
80107554:	ec                   	in     (%dx),%al
80107555:	a8 20                	test   $0x20,%al
80107557:	74 e7                	je     80107540 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107559:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010755d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107562:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80107563:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80107567:	83 c7 01             	add    $0x1,%edi
8010756a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010756d:	84 c0                	test   %al,%al
8010756f:	75 bf                	jne    80107530 <uartinit+0x90>
}
80107571:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107574:	5b                   	pop    %ebx
80107575:	5e                   	pop    %esi
80107576:	5f                   	pop    %edi
80107577:	5d                   	pop    %ebp
80107578:	c3                   	ret    
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107580 <uartputc>:
  if(!uart)
80107580:	a1 40 6f 11 80       	mov    0x80116f40,%eax
80107585:	85 c0                	test   %eax,%eax
80107587:	74 47                	je     801075d0 <uartputc+0x50>
{
80107589:	55                   	push   %ebp
8010758a:	89 e5                	mov    %esp,%ebp
8010758c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010758d:	be fd 03 00 00       	mov    $0x3fd,%esi
80107592:	53                   	push   %ebx
80107593:	bb 80 00 00 00       	mov    $0x80,%ebx
80107598:	eb 18                	jmp    801075b2 <uartputc+0x32>
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
801075a0:	83 ec 0c             	sub    $0xc,%esp
801075a3:	6a 0a                	push   $0xa
801075a5:	e8 26 b8 ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801075aa:	83 c4 10             	add    $0x10,%esp
801075ad:	83 eb 01             	sub    $0x1,%ebx
801075b0:	74 07                	je     801075b9 <uartputc+0x39>
801075b2:	89 f2                	mov    %esi,%edx
801075b4:	ec                   	in     (%dx),%al
801075b5:	a8 20                	test   $0x20,%al
801075b7:	74 e7                	je     801075a0 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801075b9:	8b 45 08             	mov    0x8(%ebp),%eax
801075bc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801075c1:	ee                   	out    %al,(%dx)
}
801075c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801075c5:	5b                   	pop    %ebx
801075c6:	5e                   	pop    %esi
801075c7:	5d                   	pop    %ebp
801075c8:	c3                   	ret    
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075d0:	c3                   	ret    
801075d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075df:	90                   	nop

801075e0 <uartintr>:

void
uartintr(void)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801075e6:	68 70 74 10 80       	push   $0x80107470
801075eb:	e8 40 96 ff ff       	call   80100c30 <consoleintr>
}
801075f0:	83 c4 10             	add    $0x10,%esp
801075f3:	c9                   	leave  
801075f4:	c3                   	ret    

801075f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801075f5:	6a 00                	push   $0x0
  pushl $0
801075f7:	6a 00                	push   $0x0
  jmp alltraps
801075f9:	e9 04 fb ff ff       	jmp    80107102 <alltraps>

801075fe <vector1>:
.globl vector1
vector1:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $1
80107600:	6a 01                	push   $0x1
  jmp alltraps
80107602:	e9 fb fa ff ff       	jmp    80107102 <alltraps>

80107607 <vector2>:
.globl vector2
vector2:
  pushl $0
80107607:	6a 00                	push   $0x0
  pushl $2
80107609:	6a 02                	push   $0x2
  jmp alltraps
8010760b:	e9 f2 fa ff ff       	jmp    80107102 <alltraps>

80107610 <vector3>:
.globl vector3
vector3:
  pushl $0
80107610:	6a 00                	push   $0x0
  pushl $3
80107612:	6a 03                	push   $0x3
  jmp alltraps
80107614:	e9 e9 fa ff ff       	jmp    80107102 <alltraps>

80107619 <vector4>:
.globl vector4
vector4:
  pushl $0
80107619:	6a 00                	push   $0x0
  pushl $4
8010761b:	6a 04                	push   $0x4
  jmp alltraps
8010761d:	e9 e0 fa ff ff       	jmp    80107102 <alltraps>

80107622 <vector5>:
.globl vector5
vector5:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $5
80107624:	6a 05                	push   $0x5
  jmp alltraps
80107626:	e9 d7 fa ff ff       	jmp    80107102 <alltraps>

8010762b <vector6>:
.globl vector6
vector6:
  pushl $0
8010762b:	6a 00                	push   $0x0
  pushl $6
8010762d:	6a 06                	push   $0x6
  jmp alltraps
8010762f:	e9 ce fa ff ff       	jmp    80107102 <alltraps>

80107634 <vector7>:
.globl vector7
vector7:
  pushl $0
80107634:	6a 00                	push   $0x0
  pushl $7
80107636:	6a 07                	push   $0x7
  jmp alltraps
80107638:	e9 c5 fa ff ff       	jmp    80107102 <alltraps>

8010763d <vector8>:
.globl vector8
vector8:
  pushl $8
8010763d:	6a 08                	push   $0x8
  jmp alltraps
8010763f:	e9 be fa ff ff       	jmp    80107102 <alltraps>

80107644 <vector9>:
.globl vector9
vector9:
  pushl $0
80107644:	6a 00                	push   $0x0
  pushl $9
80107646:	6a 09                	push   $0x9
  jmp alltraps
80107648:	e9 b5 fa ff ff       	jmp    80107102 <alltraps>

8010764d <vector10>:
.globl vector10
vector10:
  pushl $10
8010764d:	6a 0a                	push   $0xa
  jmp alltraps
8010764f:	e9 ae fa ff ff       	jmp    80107102 <alltraps>

80107654 <vector11>:
.globl vector11
vector11:
  pushl $11
80107654:	6a 0b                	push   $0xb
  jmp alltraps
80107656:	e9 a7 fa ff ff       	jmp    80107102 <alltraps>

8010765b <vector12>:
.globl vector12
vector12:
  pushl $12
8010765b:	6a 0c                	push   $0xc
  jmp alltraps
8010765d:	e9 a0 fa ff ff       	jmp    80107102 <alltraps>

80107662 <vector13>:
.globl vector13
vector13:
  pushl $13
80107662:	6a 0d                	push   $0xd
  jmp alltraps
80107664:	e9 99 fa ff ff       	jmp    80107102 <alltraps>

80107669 <vector14>:
.globl vector14
vector14:
  pushl $14
80107669:	6a 0e                	push   $0xe
  jmp alltraps
8010766b:	e9 92 fa ff ff       	jmp    80107102 <alltraps>

80107670 <vector15>:
.globl vector15
vector15:
  pushl $0
80107670:	6a 00                	push   $0x0
  pushl $15
80107672:	6a 0f                	push   $0xf
  jmp alltraps
80107674:	e9 89 fa ff ff       	jmp    80107102 <alltraps>

80107679 <vector16>:
.globl vector16
vector16:
  pushl $0
80107679:	6a 00                	push   $0x0
  pushl $16
8010767b:	6a 10                	push   $0x10
  jmp alltraps
8010767d:	e9 80 fa ff ff       	jmp    80107102 <alltraps>

80107682 <vector17>:
.globl vector17
vector17:
  pushl $17
80107682:	6a 11                	push   $0x11
  jmp alltraps
80107684:	e9 79 fa ff ff       	jmp    80107102 <alltraps>

80107689 <vector18>:
.globl vector18
vector18:
  pushl $0
80107689:	6a 00                	push   $0x0
  pushl $18
8010768b:	6a 12                	push   $0x12
  jmp alltraps
8010768d:	e9 70 fa ff ff       	jmp    80107102 <alltraps>

80107692 <vector19>:
.globl vector19
vector19:
  pushl $0
80107692:	6a 00                	push   $0x0
  pushl $19
80107694:	6a 13                	push   $0x13
  jmp alltraps
80107696:	e9 67 fa ff ff       	jmp    80107102 <alltraps>

8010769b <vector20>:
.globl vector20
vector20:
  pushl $0
8010769b:	6a 00                	push   $0x0
  pushl $20
8010769d:	6a 14                	push   $0x14
  jmp alltraps
8010769f:	e9 5e fa ff ff       	jmp    80107102 <alltraps>

801076a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801076a4:	6a 00                	push   $0x0
  pushl $21
801076a6:	6a 15                	push   $0x15
  jmp alltraps
801076a8:	e9 55 fa ff ff       	jmp    80107102 <alltraps>

801076ad <vector22>:
.globl vector22
vector22:
  pushl $0
801076ad:	6a 00                	push   $0x0
  pushl $22
801076af:	6a 16                	push   $0x16
  jmp alltraps
801076b1:	e9 4c fa ff ff       	jmp    80107102 <alltraps>

801076b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801076b6:	6a 00                	push   $0x0
  pushl $23
801076b8:	6a 17                	push   $0x17
  jmp alltraps
801076ba:	e9 43 fa ff ff       	jmp    80107102 <alltraps>

801076bf <vector24>:
.globl vector24
vector24:
  pushl $0
801076bf:	6a 00                	push   $0x0
  pushl $24
801076c1:	6a 18                	push   $0x18
  jmp alltraps
801076c3:	e9 3a fa ff ff       	jmp    80107102 <alltraps>

801076c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801076c8:	6a 00                	push   $0x0
  pushl $25
801076ca:	6a 19                	push   $0x19
  jmp alltraps
801076cc:	e9 31 fa ff ff       	jmp    80107102 <alltraps>

801076d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801076d1:	6a 00                	push   $0x0
  pushl $26
801076d3:	6a 1a                	push   $0x1a
  jmp alltraps
801076d5:	e9 28 fa ff ff       	jmp    80107102 <alltraps>

801076da <vector27>:
.globl vector27
vector27:
  pushl $0
801076da:	6a 00                	push   $0x0
  pushl $27
801076dc:	6a 1b                	push   $0x1b
  jmp alltraps
801076de:	e9 1f fa ff ff       	jmp    80107102 <alltraps>

801076e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801076e3:	6a 00                	push   $0x0
  pushl $28
801076e5:	6a 1c                	push   $0x1c
  jmp alltraps
801076e7:	e9 16 fa ff ff       	jmp    80107102 <alltraps>

801076ec <vector29>:
.globl vector29
vector29:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $29
801076ee:	6a 1d                	push   $0x1d
  jmp alltraps
801076f0:	e9 0d fa ff ff       	jmp    80107102 <alltraps>

801076f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801076f5:	6a 00                	push   $0x0
  pushl $30
801076f7:	6a 1e                	push   $0x1e
  jmp alltraps
801076f9:	e9 04 fa ff ff       	jmp    80107102 <alltraps>

801076fe <vector31>:
.globl vector31
vector31:
  pushl $0
801076fe:	6a 00                	push   $0x0
  pushl $31
80107700:	6a 1f                	push   $0x1f
  jmp alltraps
80107702:	e9 fb f9 ff ff       	jmp    80107102 <alltraps>

80107707 <vector32>:
.globl vector32
vector32:
  pushl $0
80107707:	6a 00                	push   $0x0
  pushl $32
80107709:	6a 20                	push   $0x20
  jmp alltraps
8010770b:	e9 f2 f9 ff ff       	jmp    80107102 <alltraps>

80107710 <vector33>:
.globl vector33
vector33:
  pushl $0
80107710:	6a 00                	push   $0x0
  pushl $33
80107712:	6a 21                	push   $0x21
  jmp alltraps
80107714:	e9 e9 f9 ff ff       	jmp    80107102 <alltraps>

80107719 <vector34>:
.globl vector34
vector34:
  pushl $0
80107719:	6a 00                	push   $0x0
  pushl $34
8010771b:	6a 22                	push   $0x22
  jmp alltraps
8010771d:	e9 e0 f9 ff ff       	jmp    80107102 <alltraps>

80107722 <vector35>:
.globl vector35
vector35:
  pushl $0
80107722:	6a 00                	push   $0x0
  pushl $35
80107724:	6a 23                	push   $0x23
  jmp alltraps
80107726:	e9 d7 f9 ff ff       	jmp    80107102 <alltraps>

8010772b <vector36>:
.globl vector36
vector36:
  pushl $0
8010772b:	6a 00                	push   $0x0
  pushl $36
8010772d:	6a 24                	push   $0x24
  jmp alltraps
8010772f:	e9 ce f9 ff ff       	jmp    80107102 <alltraps>

80107734 <vector37>:
.globl vector37
vector37:
  pushl $0
80107734:	6a 00                	push   $0x0
  pushl $37
80107736:	6a 25                	push   $0x25
  jmp alltraps
80107738:	e9 c5 f9 ff ff       	jmp    80107102 <alltraps>

8010773d <vector38>:
.globl vector38
vector38:
  pushl $0
8010773d:	6a 00                	push   $0x0
  pushl $38
8010773f:	6a 26                	push   $0x26
  jmp alltraps
80107741:	e9 bc f9 ff ff       	jmp    80107102 <alltraps>

80107746 <vector39>:
.globl vector39
vector39:
  pushl $0
80107746:	6a 00                	push   $0x0
  pushl $39
80107748:	6a 27                	push   $0x27
  jmp alltraps
8010774a:	e9 b3 f9 ff ff       	jmp    80107102 <alltraps>

8010774f <vector40>:
.globl vector40
vector40:
  pushl $0
8010774f:	6a 00                	push   $0x0
  pushl $40
80107751:	6a 28                	push   $0x28
  jmp alltraps
80107753:	e9 aa f9 ff ff       	jmp    80107102 <alltraps>

80107758 <vector41>:
.globl vector41
vector41:
  pushl $0
80107758:	6a 00                	push   $0x0
  pushl $41
8010775a:	6a 29                	push   $0x29
  jmp alltraps
8010775c:	e9 a1 f9 ff ff       	jmp    80107102 <alltraps>

80107761 <vector42>:
.globl vector42
vector42:
  pushl $0
80107761:	6a 00                	push   $0x0
  pushl $42
80107763:	6a 2a                	push   $0x2a
  jmp alltraps
80107765:	e9 98 f9 ff ff       	jmp    80107102 <alltraps>

8010776a <vector43>:
.globl vector43
vector43:
  pushl $0
8010776a:	6a 00                	push   $0x0
  pushl $43
8010776c:	6a 2b                	push   $0x2b
  jmp alltraps
8010776e:	e9 8f f9 ff ff       	jmp    80107102 <alltraps>

80107773 <vector44>:
.globl vector44
vector44:
  pushl $0
80107773:	6a 00                	push   $0x0
  pushl $44
80107775:	6a 2c                	push   $0x2c
  jmp alltraps
80107777:	e9 86 f9 ff ff       	jmp    80107102 <alltraps>

8010777c <vector45>:
.globl vector45
vector45:
  pushl $0
8010777c:	6a 00                	push   $0x0
  pushl $45
8010777e:	6a 2d                	push   $0x2d
  jmp alltraps
80107780:	e9 7d f9 ff ff       	jmp    80107102 <alltraps>

80107785 <vector46>:
.globl vector46
vector46:
  pushl $0
80107785:	6a 00                	push   $0x0
  pushl $46
80107787:	6a 2e                	push   $0x2e
  jmp alltraps
80107789:	e9 74 f9 ff ff       	jmp    80107102 <alltraps>

8010778e <vector47>:
.globl vector47
vector47:
  pushl $0
8010778e:	6a 00                	push   $0x0
  pushl $47
80107790:	6a 2f                	push   $0x2f
  jmp alltraps
80107792:	e9 6b f9 ff ff       	jmp    80107102 <alltraps>

80107797 <vector48>:
.globl vector48
vector48:
  pushl $0
80107797:	6a 00                	push   $0x0
  pushl $48
80107799:	6a 30                	push   $0x30
  jmp alltraps
8010779b:	e9 62 f9 ff ff       	jmp    80107102 <alltraps>

801077a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801077a0:	6a 00                	push   $0x0
  pushl $49
801077a2:	6a 31                	push   $0x31
  jmp alltraps
801077a4:	e9 59 f9 ff ff       	jmp    80107102 <alltraps>

801077a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801077a9:	6a 00                	push   $0x0
  pushl $50
801077ab:	6a 32                	push   $0x32
  jmp alltraps
801077ad:	e9 50 f9 ff ff       	jmp    80107102 <alltraps>

801077b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801077b2:	6a 00                	push   $0x0
  pushl $51
801077b4:	6a 33                	push   $0x33
  jmp alltraps
801077b6:	e9 47 f9 ff ff       	jmp    80107102 <alltraps>

801077bb <vector52>:
.globl vector52
vector52:
  pushl $0
801077bb:	6a 00                	push   $0x0
  pushl $52
801077bd:	6a 34                	push   $0x34
  jmp alltraps
801077bf:	e9 3e f9 ff ff       	jmp    80107102 <alltraps>

801077c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801077c4:	6a 00                	push   $0x0
  pushl $53
801077c6:	6a 35                	push   $0x35
  jmp alltraps
801077c8:	e9 35 f9 ff ff       	jmp    80107102 <alltraps>

801077cd <vector54>:
.globl vector54
vector54:
  pushl $0
801077cd:	6a 00                	push   $0x0
  pushl $54
801077cf:	6a 36                	push   $0x36
  jmp alltraps
801077d1:	e9 2c f9 ff ff       	jmp    80107102 <alltraps>

801077d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801077d6:	6a 00                	push   $0x0
  pushl $55
801077d8:	6a 37                	push   $0x37
  jmp alltraps
801077da:	e9 23 f9 ff ff       	jmp    80107102 <alltraps>

801077df <vector56>:
.globl vector56
vector56:
  pushl $0
801077df:	6a 00                	push   $0x0
  pushl $56
801077e1:	6a 38                	push   $0x38
  jmp alltraps
801077e3:	e9 1a f9 ff ff       	jmp    80107102 <alltraps>

801077e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801077e8:	6a 00                	push   $0x0
  pushl $57
801077ea:	6a 39                	push   $0x39
  jmp alltraps
801077ec:	e9 11 f9 ff ff       	jmp    80107102 <alltraps>

801077f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801077f1:	6a 00                	push   $0x0
  pushl $58
801077f3:	6a 3a                	push   $0x3a
  jmp alltraps
801077f5:	e9 08 f9 ff ff       	jmp    80107102 <alltraps>

801077fa <vector59>:
.globl vector59
vector59:
  pushl $0
801077fa:	6a 00                	push   $0x0
  pushl $59
801077fc:	6a 3b                	push   $0x3b
  jmp alltraps
801077fe:	e9 ff f8 ff ff       	jmp    80107102 <alltraps>

80107803 <vector60>:
.globl vector60
vector60:
  pushl $0
80107803:	6a 00                	push   $0x0
  pushl $60
80107805:	6a 3c                	push   $0x3c
  jmp alltraps
80107807:	e9 f6 f8 ff ff       	jmp    80107102 <alltraps>

8010780c <vector61>:
.globl vector61
vector61:
  pushl $0
8010780c:	6a 00                	push   $0x0
  pushl $61
8010780e:	6a 3d                	push   $0x3d
  jmp alltraps
80107810:	e9 ed f8 ff ff       	jmp    80107102 <alltraps>

80107815 <vector62>:
.globl vector62
vector62:
  pushl $0
80107815:	6a 00                	push   $0x0
  pushl $62
80107817:	6a 3e                	push   $0x3e
  jmp alltraps
80107819:	e9 e4 f8 ff ff       	jmp    80107102 <alltraps>

8010781e <vector63>:
.globl vector63
vector63:
  pushl $0
8010781e:	6a 00                	push   $0x0
  pushl $63
80107820:	6a 3f                	push   $0x3f
  jmp alltraps
80107822:	e9 db f8 ff ff       	jmp    80107102 <alltraps>

80107827 <vector64>:
.globl vector64
vector64:
  pushl $0
80107827:	6a 00                	push   $0x0
  pushl $64
80107829:	6a 40                	push   $0x40
  jmp alltraps
8010782b:	e9 d2 f8 ff ff       	jmp    80107102 <alltraps>

80107830 <vector65>:
.globl vector65
vector65:
  pushl $0
80107830:	6a 00                	push   $0x0
  pushl $65
80107832:	6a 41                	push   $0x41
  jmp alltraps
80107834:	e9 c9 f8 ff ff       	jmp    80107102 <alltraps>

80107839 <vector66>:
.globl vector66
vector66:
  pushl $0
80107839:	6a 00                	push   $0x0
  pushl $66
8010783b:	6a 42                	push   $0x42
  jmp alltraps
8010783d:	e9 c0 f8 ff ff       	jmp    80107102 <alltraps>

80107842 <vector67>:
.globl vector67
vector67:
  pushl $0
80107842:	6a 00                	push   $0x0
  pushl $67
80107844:	6a 43                	push   $0x43
  jmp alltraps
80107846:	e9 b7 f8 ff ff       	jmp    80107102 <alltraps>

8010784b <vector68>:
.globl vector68
vector68:
  pushl $0
8010784b:	6a 00                	push   $0x0
  pushl $68
8010784d:	6a 44                	push   $0x44
  jmp alltraps
8010784f:	e9 ae f8 ff ff       	jmp    80107102 <alltraps>

80107854 <vector69>:
.globl vector69
vector69:
  pushl $0
80107854:	6a 00                	push   $0x0
  pushl $69
80107856:	6a 45                	push   $0x45
  jmp alltraps
80107858:	e9 a5 f8 ff ff       	jmp    80107102 <alltraps>

8010785d <vector70>:
.globl vector70
vector70:
  pushl $0
8010785d:	6a 00                	push   $0x0
  pushl $70
8010785f:	6a 46                	push   $0x46
  jmp alltraps
80107861:	e9 9c f8 ff ff       	jmp    80107102 <alltraps>

80107866 <vector71>:
.globl vector71
vector71:
  pushl $0
80107866:	6a 00                	push   $0x0
  pushl $71
80107868:	6a 47                	push   $0x47
  jmp alltraps
8010786a:	e9 93 f8 ff ff       	jmp    80107102 <alltraps>

8010786f <vector72>:
.globl vector72
vector72:
  pushl $0
8010786f:	6a 00                	push   $0x0
  pushl $72
80107871:	6a 48                	push   $0x48
  jmp alltraps
80107873:	e9 8a f8 ff ff       	jmp    80107102 <alltraps>

80107878 <vector73>:
.globl vector73
vector73:
  pushl $0
80107878:	6a 00                	push   $0x0
  pushl $73
8010787a:	6a 49                	push   $0x49
  jmp alltraps
8010787c:	e9 81 f8 ff ff       	jmp    80107102 <alltraps>

80107881 <vector74>:
.globl vector74
vector74:
  pushl $0
80107881:	6a 00                	push   $0x0
  pushl $74
80107883:	6a 4a                	push   $0x4a
  jmp alltraps
80107885:	e9 78 f8 ff ff       	jmp    80107102 <alltraps>

8010788a <vector75>:
.globl vector75
vector75:
  pushl $0
8010788a:	6a 00                	push   $0x0
  pushl $75
8010788c:	6a 4b                	push   $0x4b
  jmp alltraps
8010788e:	e9 6f f8 ff ff       	jmp    80107102 <alltraps>

80107893 <vector76>:
.globl vector76
vector76:
  pushl $0
80107893:	6a 00                	push   $0x0
  pushl $76
80107895:	6a 4c                	push   $0x4c
  jmp alltraps
80107897:	e9 66 f8 ff ff       	jmp    80107102 <alltraps>

8010789c <vector77>:
.globl vector77
vector77:
  pushl $0
8010789c:	6a 00                	push   $0x0
  pushl $77
8010789e:	6a 4d                	push   $0x4d
  jmp alltraps
801078a0:	e9 5d f8 ff ff       	jmp    80107102 <alltraps>

801078a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801078a5:	6a 00                	push   $0x0
  pushl $78
801078a7:	6a 4e                	push   $0x4e
  jmp alltraps
801078a9:	e9 54 f8 ff ff       	jmp    80107102 <alltraps>

801078ae <vector79>:
.globl vector79
vector79:
  pushl $0
801078ae:	6a 00                	push   $0x0
  pushl $79
801078b0:	6a 4f                	push   $0x4f
  jmp alltraps
801078b2:	e9 4b f8 ff ff       	jmp    80107102 <alltraps>

801078b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801078b7:	6a 00                	push   $0x0
  pushl $80
801078b9:	6a 50                	push   $0x50
  jmp alltraps
801078bb:	e9 42 f8 ff ff       	jmp    80107102 <alltraps>

801078c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801078c0:	6a 00                	push   $0x0
  pushl $81
801078c2:	6a 51                	push   $0x51
  jmp alltraps
801078c4:	e9 39 f8 ff ff       	jmp    80107102 <alltraps>

801078c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801078c9:	6a 00                	push   $0x0
  pushl $82
801078cb:	6a 52                	push   $0x52
  jmp alltraps
801078cd:	e9 30 f8 ff ff       	jmp    80107102 <alltraps>

801078d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801078d2:	6a 00                	push   $0x0
  pushl $83
801078d4:	6a 53                	push   $0x53
  jmp alltraps
801078d6:	e9 27 f8 ff ff       	jmp    80107102 <alltraps>

801078db <vector84>:
.globl vector84
vector84:
  pushl $0
801078db:	6a 00                	push   $0x0
  pushl $84
801078dd:	6a 54                	push   $0x54
  jmp alltraps
801078df:	e9 1e f8 ff ff       	jmp    80107102 <alltraps>

801078e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801078e4:	6a 00                	push   $0x0
  pushl $85
801078e6:	6a 55                	push   $0x55
  jmp alltraps
801078e8:	e9 15 f8 ff ff       	jmp    80107102 <alltraps>

801078ed <vector86>:
.globl vector86
vector86:
  pushl $0
801078ed:	6a 00                	push   $0x0
  pushl $86
801078ef:	6a 56                	push   $0x56
  jmp alltraps
801078f1:	e9 0c f8 ff ff       	jmp    80107102 <alltraps>

801078f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801078f6:	6a 00                	push   $0x0
  pushl $87
801078f8:	6a 57                	push   $0x57
  jmp alltraps
801078fa:	e9 03 f8 ff ff       	jmp    80107102 <alltraps>

801078ff <vector88>:
.globl vector88
vector88:
  pushl $0
801078ff:	6a 00                	push   $0x0
  pushl $88
80107901:	6a 58                	push   $0x58
  jmp alltraps
80107903:	e9 fa f7 ff ff       	jmp    80107102 <alltraps>

80107908 <vector89>:
.globl vector89
vector89:
  pushl $0
80107908:	6a 00                	push   $0x0
  pushl $89
8010790a:	6a 59                	push   $0x59
  jmp alltraps
8010790c:	e9 f1 f7 ff ff       	jmp    80107102 <alltraps>

80107911 <vector90>:
.globl vector90
vector90:
  pushl $0
80107911:	6a 00                	push   $0x0
  pushl $90
80107913:	6a 5a                	push   $0x5a
  jmp alltraps
80107915:	e9 e8 f7 ff ff       	jmp    80107102 <alltraps>

8010791a <vector91>:
.globl vector91
vector91:
  pushl $0
8010791a:	6a 00                	push   $0x0
  pushl $91
8010791c:	6a 5b                	push   $0x5b
  jmp alltraps
8010791e:	e9 df f7 ff ff       	jmp    80107102 <alltraps>

80107923 <vector92>:
.globl vector92
vector92:
  pushl $0
80107923:	6a 00                	push   $0x0
  pushl $92
80107925:	6a 5c                	push   $0x5c
  jmp alltraps
80107927:	e9 d6 f7 ff ff       	jmp    80107102 <alltraps>

8010792c <vector93>:
.globl vector93
vector93:
  pushl $0
8010792c:	6a 00                	push   $0x0
  pushl $93
8010792e:	6a 5d                	push   $0x5d
  jmp alltraps
80107930:	e9 cd f7 ff ff       	jmp    80107102 <alltraps>

80107935 <vector94>:
.globl vector94
vector94:
  pushl $0
80107935:	6a 00                	push   $0x0
  pushl $94
80107937:	6a 5e                	push   $0x5e
  jmp alltraps
80107939:	e9 c4 f7 ff ff       	jmp    80107102 <alltraps>

8010793e <vector95>:
.globl vector95
vector95:
  pushl $0
8010793e:	6a 00                	push   $0x0
  pushl $95
80107940:	6a 5f                	push   $0x5f
  jmp alltraps
80107942:	e9 bb f7 ff ff       	jmp    80107102 <alltraps>

80107947 <vector96>:
.globl vector96
vector96:
  pushl $0
80107947:	6a 00                	push   $0x0
  pushl $96
80107949:	6a 60                	push   $0x60
  jmp alltraps
8010794b:	e9 b2 f7 ff ff       	jmp    80107102 <alltraps>

80107950 <vector97>:
.globl vector97
vector97:
  pushl $0
80107950:	6a 00                	push   $0x0
  pushl $97
80107952:	6a 61                	push   $0x61
  jmp alltraps
80107954:	e9 a9 f7 ff ff       	jmp    80107102 <alltraps>

80107959 <vector98>:
.globl vector98
vector98:
  pushl $0
80107959:	6a 00                	push   $0x0
  pushl $98
8010795b:	6a 62                	push   $0x62
  jmp alltraps
8010795d:	e9 a0 f7 ff ff       	jmp    80107102 <alltraps>

80107962 <vector99>:
.globl vector99
vector99:
  pushl $0
80107962:	6a 00                	push   $0x0
  pushl $99
80107964:	6a 63                	push   $0x63
  jmp alltraps
80107966:	e9 97 f7 ff ff       	jmp    80107102 <alltraps>

8010796b <vector100>:
.globl vector100
vector100:
  pushl $0
8010796b:	6a 00                	push   $0x0
  pushl $100
8010796d:	6a 64                	push   $0x64
  jmp alltraps
8010796f:	e9 8e f7 ff ff       	jmp    80107102 <alltraps>

80107974 <vector101>:
.globl vector101
vector101:
  pushl $0
80107974:	6a 00                	push   $0x0
  pushl $101
80107976:	6a 65                	push   $0x65
  jmp alltraps
80107978:	e9 85 f7 ff ff       	jmp    80107102 <alltraps>

8010797d <vector102>:
.globl vector102
vector102:
  pushl $0
8010797d:	6a 00                	push   $0x0
  pushl $102
8010797f:	6a 66                	push   $0x66
  jmp alltraps
80107981:	e9 7c f7 ff ff       	jmp    80107102 <alltraps>

80107986 <vector103>:
.globl vector103
vector103:
  pushl $0
80107986:	6a 00                	push   $0x0
  pushl $103
80107988:	6a 67                	push   $0x67
  jmp alltraps
8010798a:	e9 73 f7 ff ff       	jmp    80107102 <alltraps>

8010798f <vector104>:
.globl vector104
vector104:
  pushl $0
8010798f:	6a 00                	push   $0x0
  pushl $104
80107991:	6a 68                	push   $0x68
  jmp alltraps
80107993:	e9 6a f7 ff ff       	jmp    80107102 <alltraps>

80107998 <vector105>:
.globl vector105
vector105:
  pushl $0
80107998:	6a 00                	push   $0x0
  pushl $105
8010799a:	6a 69                	push   $0x69
  jmp alltraps
8010799c:	e9 61 f7 ff ff       	jmp    80107102 <alltraps>

801079a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801079a1:	6a 00                	push   $0x0
  pushl $106
801079a3:	6a 6a                	push   $0x6a
  jmp alltraps
801079a5:	e9 58 f7 ff ff       	jmp    80107102 <alltraps>

801079aa <vector107>:
.globl vector107
vector107:
  pushl $0
801079aa:	6a 00                	push   $0x0
  pushl $107
801079ac:	6a 6b                	push   $0x6b
  jmp alltraps
801079ae:	e9 4f f7 ff ff       	jmp    80107102 <alltraps>

801079b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801079b3:	6a 00                	push   $0x0
  pushl $108
801079b5:	6a 6c                	push   $0x6c
  jmp alltraps
801079b7:	e9 46 f7 ff ff       	jmp    80107102 <alltraps>

801079bc <vector109>:
.globl vector109
vector109:
  pushl $0
801079bc:	6a 00                	push   $0x0
  pushl $109
801079be:	6a 6d                	push   $0x6d
  jmp alltraps
801079c0:	e9 3d f7 ff ff       	jmp    80107102 <alltraps>

801079c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801079c5:	6a 00                	push   $0x0
  pushl $110
801079c7:	6a 6e                	push   $0x6e
  jmp alltraps
801079c9:	e9 34 f7 ff ff       	jmp    80107102 <alltraps>

801079ce <vector111>:
.globl vector111
vector111:
  pushl $0
801079ce:	6a 00                	push   $0x0
  pushl $111
801079d0:	6a 6f                	push   $0x6f
  jmp alltraps
801079d2:	e9 2b f7 ff ff       	jmp    80107102 <alltraps>

801079d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801079d7:	6a 00                	push   $0x0
  pushl $112
801079d9:	6a 70                	push   $0x70
  jmp alltraps
801079db:	e9 22 f7 ff ff       	jmp    80107102 <alltraps>

801079e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801079e0:	6a 00                	push   $0x0
  pushl $113
801079e2:	6a 71                	push   $0x71
  jmp alltraps
801079e4:	e9 19 f7 ff ff       	jmp    80107102 <alltraps>

801079e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801079e9:	6a 00                	push   $0x0
  pushl $114
801079eb:	6a 72                	push   $0x72
  jmp alltraps
801079ed:	e9 10 f7 ff ff       	jmp    80107102 <alltraps>

801079f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801079f2:	6a 00                	push   $0x0
  pushl $115
801079f4:	6a 73                	push   $0x73
  jmp alltraps
801079f6:	e9 07 f7 ff ff       	jmp    80107102 <alltraps>

801079fb <vector116>:
.globl vector116
vector116:
  pushl $0
801079fb:	6a 00                	push   $0x0
  pushl $116
801079fd:	6a 74                	push   $0x74
  jmp alltraps
801079ff:	e9 fe f6 ff ff       	jmp    80107102 <alltraps>

80107a04 <vector117>:
.globl vector117
vector117:
  pushl $0
80107a04:	6a 00                	push   $0x0
  pushl $117
80107a06:	6a 75                	push   $0x75
  jmp alltraps
80107a08:	e9 f5 f6 ff ff       	jmp    80107102 <alltraps>

80107a0d <vector118>:
.globl vector118
vector118:
  pushl $0
80107a0d:	6a 00                	push   $0x0
  pushl $118
80107a0f:	6a 76                	push   $0x76
  jmp alltraps
80107a11:	e9 ec f6 ff ff       	jmp    80107102 <alltraps>

80107a16 <vector119>:
.globl vector119
vector119:
  pushl $0
80107a16:	6a 00                	push   $0x0
  pushl $119
80107a18:	6a 77                	push   $0x77
  jmp alltraps
80107a1a:	e9 e3 f6 ff ff       	jmp    80107102 <alltraps>

80107a1f <vector120>:
.globl vector120
vector120:
  pushl $0
80107a1f:	6a 00                	push   $0x0
  pushl $120
80107a21:	6a 78                	push   $0x78
  jmp alltraps
80107a23:	e9 da f6 ff ff       	jmp    80107102 <alltraps>

80107a28 <vector121>:
.globl vector121
vector121:
  pushl $0
80107a28:	6a 00                	push   $0x0
  pushl $121
80107a2a:	6a 79                	push   $0x79
  jmp alltraps
80107a2c:	e9 d1 f6 ff ff       	jmp    80107102 <alltraps>

80107a31 <vector122>:
.globl vector122
vector122:
  pushl $0
80107a31:	6a 00                	push   $0x0
  pushl $122
80107a33:	6a 7a                	push   $0x7a
  jmp alltraps
80107a35:	e9 c8 f6 ff ff       	jmp    80107102 <alltraps>

80107a3a <vector123>:
.globl vector123
vector123:
  pushl $0
80107a3a:	6a 00                	push   $0x0
  pushl $123
80107a3c:	6a 7b                	push   $0x7b
  jmp alltraps
80107a3e:	e9 bf f6 ff ff       	jmp    80107102 <alltraps>

80107a43 <vector124>:
.globl vector124
vector124:
  pushl $0
80107a43:	6a 00                	push   $0x0
  pushl $124
80107a45:	6a 7c                	push   $0x7c
  jmp alltraps
80107a47:	e9 b6 f6 ff ff       	jmp    80107102 <alltraps>

80107a4c <vector125>:
.globl vector125
vector125:
  pushl $0
80107a4c:	6a 00                	push   $0x0
  pushl $125
80107a4e:	6a 7d                	push   $0x7d
  jmp alltraps
80107a50:	e9 ad f6 ff ff       	jmp    80107102 <alltraps>

80107a55 <vector126>:
.globl vector126
vector126:
  pushl $0
80107a55:	6a 00                	push   $0x0
  pushl $126
80107a57:	6a 7e                	push   $0x7e
  jmp alltraps
80107a59:	e9 a4 f6 ff ff       	jmp    80107102 <alltraps>

80107a5e <vector127>:
.globl vector127
vector127:
  pushl $0
80107a5e:	6a 00                	push   $0x0
  pushl $127
80107a60:	6a 7f                	push   $0x7f
  jmp alltraps
80107a62:	e9 9b f6 ff ff       	jmp    80107102 <alltraps>

80107a67 <vector128>:
.globl vector128
vector128:
  pushl $0
80107a67:	6a 00                	push   $0x0
  pushl $128
80107a69:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107a6e:	e9 8f f6 ff ff       	jmp    80107102 <alltraps>

80107a73 <vector129>:
.globl vector129
vector129:
  pushl $0
80107a73:	6a 00                	push   $0x0
  pushl $129
80107a75:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107a7a:	e9 83 f6 ff ff       	jmp    80107102 <alltraps>

80107a7f <vector130>:
.globl vector130
vector130:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $130
80107a81:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107a86:	e9 77 f6 ff ff       	jmp    80107102 <alltraps>

80107a8b <vector131>:
.globl vector131
vector131:
  pushl $0
80107a8b:	6a 00                	push   $0x0
  pushl $131
80107a8d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107a92:	e9 6b f6 ff ff       	jmp    80107102 <alltraps>

80107a97 <vector132>:
.globl vector132
vector132:
  pushl $0
80107a97:	6a 00                	push   $0x0
  pushl $132
80107a99:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107a9e:	e9 5f f6 ff ff       	jmp    80107102 <alltraps>

80107aa3 <vector133>:
.globl vector133
vector133:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $133
80107aa5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107aaa:	e9 53 f6 ff ff       	jmp    80107102 <alltraps>

80107aaf <vector134>:
.globl vector134
vector134:
  pushl $0
80107aaf:	6a 00                	push   $0x0
  pushl $134
80107ab1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107ab6:	e9 47 f6 ff ff       	jmp    80107102 <alltraps>

80107abb <vector135>:
.globl vector135
vector135:
  pushl $0
80107abb:	6a 00                	push   $0x0
  pushl $135
80107abd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107ac2:	e9 3b f6 ff ff       	jmp    80107102 <alltraps>

80107ac7 <vector136>:
.globl vector136
vector136:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $136
80107ac9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107ace:	e9 2f f6 ff ff       	jmp    80107102 <alltraps>

80107ad3 <vector137>:
.globl vector137
vector137:
  pushl $0
80107ad3:	6a 00                	push   $0x0
  pushl $137
80107ad5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107ada:	e9 23 f6 ff ff       	jmp    80107102 <alltraps>

80107adf <vector138>:
.globl vector138
vector138:
  pushl $0
80107adf:	6a 00                	push   $0x0
  pushl $138
80107ae1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107ae6:	e9 17 f6 ff ff       	jmp    80107102 <alltraps>

80107aeb <vector139>:
.globl vector139
vector139:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $139
80107aed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107af2:	e9 0b f6 ff ff       	jmp    80107102 <alltraps>

80107af7 <vector140>:
.globl vector140
vector140:
  pushl $0
80107af7:	6a 00                	push   $0x0
  pushl $140
80107af9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107afe:	e9 ff f5 ff ff       	jmp    80107102 <alltraps>

80107b03 <vector141>:
.globl vector141
vector141:
  pushl $0
80107b03:	6a 00                	push   $0x0
  pushl $141
80107b05:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107b0a:	e9 f3 f5 ff ff       	jmp    80107102 <alltraps>

80107b0f <vector142>:
.globl vector142
vector142:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $142
80107b11:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107b16:	e9 e7 f5 ff ff       	jmp    80107102 <alltraps>

80107b1b <vector143>:
.globl vector143
vector143:
  pushl $0
80107b1b:	6a 00                	push   $0x0
  pushl $143
80107b1d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107b22:	e9 db f5 ff ff       	jmp    80107102 <alltraps>

80107b27 <vector144>:
.globl vector144
vector144:
  pushl $0
80107b27:	6a 00                	push   $0x0
  pushl $144
80107b29:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107b2e:	e9 cf f5 ff ff       	jmp    80107102 <alltraps>

80107b33 <vector145>:
.globl vector145
vector145:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $145
80107b35:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107b3a:	e9 c3 f5 ff ff       	jmp    80107102 <alltraps>

80107b3f <vector146>:
.globl vector146
vector146:
  pushl $0
80107b3f:	6a 00                	push   $0x0
  pushl $146
80107b41:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107b46:	e9 b7 f5 ff ff       	jmp    80107102 <alltraps>

80107b4b <vector147>:
.globl vector147
vector147:
  pushl $0
80107b4b:	6a 00                	push   $0x0
  pushl $147
80107b4d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107b52:	e9 ab f5 ff ff       	jmp    80107102 <alltraps>

80107b57 <vector148>:
.globl vector148
vector148:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $148
80107b59:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107b5e:	e9 9f f5 ff ff       	jmp    80107102 <alltraps>

80107b63 <vector149>:
.globl vector149
vector149:
  pushl $0
80107b63:	6a 00                	push   $0x0
  pushl $149
80107b65:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107b6a:	e9 93 f5 ff ff       	jmp    80107102 <alltraps>

80107b6f <vector150>:
.globl vector150
vector150:
  pushl $0
80107b6f:	6a 00                	push   $0x0
  pushl $150
80107b71:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107b76:	e9 87 f5 ff ff       	jmp    80107102 <alltraps>

80107b7b <vector151>:
.globl vector151
vector151:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $151
80107b7d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107b82:	e9 7b f5 ff ff       	jmp    80107102 <alltraps>

80107b87 <vector152>:
.globl vector152
vector152:
  pushl $0
80107b87:	6a 00                	push   $0x0
  pushl $152
80107b89:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107b8e:	e9 6f f5 ff ff       	jmp    80107102 <alltraps>

80107b93 <vector153>:
.globl vector153
vector153:
  pushl $0
80107b93:	6a 00                	push   $0x0
  pushl $153
80107b95:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107b9a:	e9 63 f5 ff ff       	jmp    80107102 <alltraps>

80107b9f <vector154>:
.globl vector154
vector154:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $154
80107ba1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107ba6:	e9 57 f5 ff ff       	jmp    80107102 <alltraps>

80107bab <vector155>:
.globl vector155
vector155:
  pushl $0
80107bab:	6a 00                	push   $0x0
  pushl $155
80107bad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107bb2:	e9 4b f5 ff ff       	jmp    80107102 <alltraps>

80107bb7 <vector156>:
.globl vector156
vector156:
  pushl $0
80107bb7:	6a 00                	push   $0x0
  pushl $156
80107bb9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107bbe:	e9 3f f5 ff ff       	jmp    80107102 <alltraps>

80107bc3 <vector157>:
.globl vector157
vector157:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $157
80107bc5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107bca:	e9 33 f5 ff ff       	jmp    80107102 <alltraps>

80107bcf <vector158>:
.globl vector158
vector158:
  pushl $0
80107bcf:	6a 00                	push   $0x0
  pushl $158
80107bd1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107bd6:	e9 27 f5 ff ff       	jmp    80107102 <alltraps>

80107bdb <vector159>:
.globl vector159
vector159:
  pushl $0
80107bdb:	6a 00                	push   $0x0
  pushl $159
80107bdd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107be2:	e9 1b f5 ff ff       	jmp    80107102 <alltraps>

80107be7 <vector160>:
.globl vector160
vector160:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $160
80107be9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107bee:	e9 0f f5 ff ff       	jmp    80107102 <alltraps>

80107bf3 <vector161>:
.globl vector161
vector161:
  pushl $0
80107bf3:	6a 00                	push   $0x0
  pushl $161
80107bf5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107bfa:	e9 03 f5 ff ff       	jmp    80107102 <alltraps>

80107bff <vector162>:
.globl vector162
vector162:
  pushl $0
80107bff:	6a 00                	push   $0x0
  pushl $162
80107c01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107c06:	e9 f7 f4 ff ff       	jmp    80107102 <alltraps>

80107c0b <vector163>:
.globl vector163
vector163:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $163
80107c0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107c12:	e9 eb f4 ff ff       	jmp    80107102 <alltraps>

80107c17 <vector164>:
.globl vector164
vector164:
  pushl $0
80107c17:	6a 00                	push   $0x0
  pushl $164
80107c19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107c1e:	e9 df f4 ff ff       	jmp    80107102 <alltraps>

80107c23 <vector165>:
.globl vector165
vector165:
  pushl $0
80107c23:	6a 00                	push   $0x0
  pushl $165
80107c25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107c2a:	e9 d3 f4 ff ff       	jmp    80107102 <alltraps>

80107c2f <vector166>:
.globl vector166
vector166:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $166
80107c31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107c36:	e9 c7 f4 ff ff       	jmp    80107102 <alltraps>

80107c3b <vector167>:
.globl vector167
vector167:
  pushl $0
80107c3b:	6a 00                	push   $0x0
  pushl $167
80107c3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107c42:	e9 bb f4 ff ff       	jmp    80107102 <alltraps>

80107c47 <vector168>:
.globl vector168
vector168:
  pushl $0
80107c47:	6a 00                	push   $0x0
  pushl $168
80107c49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107c4e:	e9 af f4 ff ff       	jmp    80107102 <alltraps>

80107c53 <vector169>:
.globl vector169
vector169:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $169
80107c55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107c5a:	e9 a3 f4 ff ff       	jmp    80107102 <alltraps>

80107c5f <vector170>:
.globl vector170
vector170:
  pushl $0
80107c5f:	6a 00                	push   $0x0
  pushl $170
80107c61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107c66:	e9 97 f4 ff ff       	jmp    80107102 <alltraps>

80107c6b <vector171>:
.globl vector171
vector171:
  pushl $0
80107c6b:	6a 00                	push   $0x0
  pushl $171
80107c6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107c72:	e9 8b f4 ff ff       	jmp    80107102 <alltraps>

80107c77 <vector172>:
.globl vector172
vector172:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $172
80107c79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107c7e:	e9 7f f4 ff ff       	jmp    80107102 <alltraps>

80107c83 <vector173>:
.globl vector173
vector173:
  pushl $0
80107c83:	6a 00                	push   $0x0
  pushl $173
80107c85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107c8a:	e9 73 f4 ff ff       	jmp    80107102 <alltraps>

80107c8f <vector174>:
.globl vector174
vector174:
  pushl $0
80107c8f:	6a 00                	push   $0x0
  pushl $174
80107c91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107c96:	e9 67 f4 ff ff       	jmp    80107102 <alltraps>

80107c9b <vector175>:
.globl vector175
vector175:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $175
80107c9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107ca2:	e9 5b f4 ff ff       	jmp    80107102 <alltraps>

80107ca7 <vector176>:
.globl vector176
vector176:
  pushl $0
80107ca7:	6a 00                	push   $0x0
  pushl $176
80107ca9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107cae:	e9 4f f4 ff ff       	jmp    80107102 <alltraps>

80107cb3 <vector177>:
.globl vector177
vector177:
  pushl $0
80107cb3:	6a 00                	push   $0x0
  pushl $177
80107cb5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107cba:	e9 43 f4 ff ff       	jmp    80107102 <alltraps>

80107cbf <vector178>:
.globl vector178
vector178:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $178
80107cc1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107cc6:	e9 37 f4 ff ff       	jmp    80107102 <alltraps>

80107ccb <vector179>:
.globl vector179
vector179:
  pushl $0
80107ccb:	6a 00                	push   $0x0
  pushl $179
80107ccd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107cd2:	e9 2b f4 ff ff       	jmp    80107102 <alltraps>

80107cd7 <vector180>:
.globl vector180
vector180:
  pushl $0
80107cd7:	6a 00                	push   $0x0
  pushl $180
80107cd9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107cde:	e9 1f f4 ff ff       	jmp    80107102 <alltraps>

80107ce3 <vector181>:
.globl vector181
vector181:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $181
80107ce5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107cea:	e9 13 f4 ff ff       	jmp    80107102 <alltraps>

80107cef <vector182>:
.globl vector182
vector182:
  pushl $0
80107cef:	6a 00                	push   $0x0
  pushl $182
80107cf1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107cf6:	e9 07 f4 ff ff       	jmp    80107102 <alltraps>

80107cfb <vector183>:
.globl vector183
vector183:
  pushl $0
80107cfb:	6a 00                	push   $0x0
  pushl $183
80107cfd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107d02:	e9 fb f3 ff ff       	jmp    80107102 <alltraps>

80107d07 <vector184>:
.globl vector184
vector184:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $184
80107d09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107d0e:	e9 ef f3 ff ff       	jmp    80107102 <alltraps>

80107d13 <vector185>:
.globl vector185
vector185:
  pushl $0
80107d13:	6a 00                	push   $0x0
  pushl $185
80107d15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107d1a:	e9 e3 f3 ff ff       	jmp    80107102 <alltraps>

80107d1f <vector186>:
.globl vector186
vector186:
  pushl $0
80107d1f:	6a 00                	push   $0x0
  pushl $186
80107d21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107d26:	e9 d7 f3 ff ff       	jmp    80107102 <alltraps>

80107d2b <vector187>:
.globl vector187
vector187:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $187
80107d2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107d32:	e9 cb f3 ff ff       	jmp    80107102 <alltraps>

80107d37 <vector188>:
.globl vector188
vector188:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $188
80107d39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107d3e:	e9 bf f3 ff ff       	jmp    80107102 <alltraps>

80107d43 <vector189>:
.globl vector189
vector189:
  pushl $0
80107d43:	6a 00                	push   $0x0
  pushl $189
80107d45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107d4a:	e9 b3 f3 ff ff       	jmp    80107102 <alltraps>

80107d4f <vector190>:
.globl vector190
vector190:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $190
80107d51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107d56:	e9 a7 f3 ff ff       	jmp    80107102 <alltraps>

80107d5b <vector191>:
.globl vector191
vector191:
  pushl $0
80107d5b:	6a 00                	push   $0x0
  pushl $191
80107d5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107d62:	e9 9b f3 ff ff       	jmp    80107102 <alltraps>

80107d67 <vector192>:
.globl vector192
vector192:
  pushl $0
80107d67:	6a 00                	push   $0x0
  pushl $192
80107d69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107d6e:	e9 8f f3 ff ff       	jmp    80107102 <alltraps>

80107d73 <vector193>:
.globl vector193
vector193:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $193
80107d75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107d7a:	e9 83 f3 ff ff       	jmp    80107102 <alltraps>

80107d7f <vector194>:
.globl vector194
vector194:
  pushl $0
80107d7f:	6a 00                	push   $0x0
  pushl $194
80107d81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107d86:	e9 77 f3 ff ff       	jmp    80107102 <alltraps>

80107d8b <vector195>:
.globl vector195
vector195:
  pushl $0
80107d8b:	6a 00                	push   $0x0
  pushl $195
80107d8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107d92:	e9 6b f3 ff ff       	jmp    80107102 <alltraps>

80107d97 <vector196>:
.globl vector196
vector196:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $196
80107d99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107d9e:	e9 5f f3 ff ff       	jmp    80107102 <alltraps>

80107da3 <vector197>:
.globl vector197
vector197:
  pushl $0
80107da3:	6a 00                	push   $0x0
  pushl $197
80107da5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107daa:	e9 53 f3 ff ff       	jmp    80107102 <alltraps>

80107daf <vector198>:
.globl vector198
vector198:
  pushl $0
80107daf:	6a 00                	push   $0x0
  pushl $198
80107db1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107db6:	e9 47 f3 ff ff       	jmp    80107102 <alltraps>

80107dbb <vector199>:
.globl vector199
vector199:
  pushl $0
80107dbb:	6a 00                	push   $0x0
  pushl $199
80107dbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107dc2:	e9 3b f3 ff ff       	jmp    80107102 <alltraps>

80107dc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80107dc7:	6a 00                	push   $0x0
  pushl $200
80107dc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107dce:	e9 2f f3 ff ff       	jmp    80107102 <alltraps>

80107dd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80107dd3:	6a 00                	push   $0x0
  pushl $201
80107dd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107dda:	e9 23 f3 ff ff       	jmp    80107102 <alltraps>

80107ddf <vector202>:
.globl vector202
vector202:
  pushl $0
80107ddf:	6a 00                	push   $0x0
  pushl $202
80107de1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107de6:	e9 17 f3 ff ff       	jmp    80107102 <alltraps>

80107deb <vector203>:
.globl vector203
vector203:
  pushl $0
80107deb:	6a 00                	push   $0x0
  pushl $203
80107ded:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107df2:	e9 0b f3 ff ff       	jmp    80107102 <alltraps>

80107df7 <vector204>:
.globl vector204
vector204:
  pushl $0
80107df7:	6a 00                	push   $0x0
  pushl $204
80107df9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107dfe:	e9 ff f2 ff ff       	jmp    80107102 <alltraps>

80107e03 <vector205>:
.globl vector205
vector205:
  pushl $0
80107e03:	6a 00                	push   $0x0
  pushl $205
80107e05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107e0a:	e9 f3 f2 ff ff       	jmp    80107102 <alltraps>

80107e0f <vector206>:
.globl vector206
vector206:
  pushl $0
80107e0f:	6a 00                	push   $0x0
  pushl $206
80107e11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107e16:	e9 e7 f2 ff ff       	jmp    80107102 <alltraps>

80107e1b <vector207>:
.globl vector207
vector207:
  pushl $0
80107e1b:	6a 00                	push   $0x0
  pushl $207
80107e1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107e22:	e9 db f2 ff ff       	jmp    80107102 <alltraps>

80107e27 <vector208>:
.globl vector208
vector208:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $208
80107e29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107e2e:	e9 cf f2 ff ff       	jmp    80107102 <alltraps>

80107e33 <vector209>:
.globl vector209
vector209:
  pushl $0
80107e33:	6a 00                	push   $0x0
  pushl $209
80107e35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107e3a:	e9 c3 f2 ff ff       	jmp    80107102 <alltraps>

80107e3f <vector210>:
.globl vector210
vector210:
  pushl $0
80107e3f:	6a 00                	push   $0x0
  pushl $210
80107e41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107e46:	e9 b7 f2 ff ff       	jmp    80107102 <alltraps>

80107e4b <vector211>:
.globl vector211
vector211:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $211
80107e4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107e52:	e9 ab f2 ff ff       	jmp    80107102 <alltraps>

80107e57 <vector212>:
.globl vector212
vector212:
  pushl $0
80107e57:	6a 00                	push   $0x0
  pushl $212
80107e59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107e5e:	e9 9f f2 ff ff       	jmp    80107102 <alltraps>

80107e63 <vector213>:
.globl vector213
vector213:
  pushl $0
80107e63:	6a 00                	push   $0x0
  pushl $213
80107e65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107e6a:	e9 93 f2 ff ff       	jmp    80107102 <alltraps>

80107e6f <vector214>:
.globl vector214
vector214:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $214
80107e71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107e76:	e9 87 f2 ff ff       	jmp    80107102 <alltraps>

80107e7b <vector215>:
.globl vector215
vector215:
  pushl $0
80107e7b:	6a 00                	push   $0x0
  pushl $215
80107e7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107e82:	e9 7b f2 ff ff       	jmp    80107102 <alltraps>

80107e87 <vector216>:
.globl vector216
vector216:
  pushl $0
80107e87:	6a 00                	push   $0x0
  pushl $216
80107e89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107e8e:	e9 6f f2 ff ff       	jmp    80107102 <alltraps>

80107e93 <vector217>:
.globl vector217
vector217:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $217
80107e95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107e9a:	e9 63 f2 ff ff       	jmp    80107102 <alltraps>

80107e9f <vector218>:
.globl vector218
vector218:
  pushl $0
80107e9f:	6a 00                	push   $0x0
  pushl $218
80107ea1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107ea6:	e9 57 f2 ff ff       	jmp    80107102 <alltraps>

80107eab <vector219>:
.globl vector219
vector219:
  pushl $0
80107eab:	6a 00                	push   $0x0
  pushl $219
80107ead:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107eb2:	e9 4b f2 ff ff       	jmp    80107102 <alltraps>

80107eb7 <vector220>:
.globl vector220
vector220:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $220
80107eb9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107ebe:	e9 3f f2 ff ff       	jmp    80107102 <alltraps>

80107ec3 <vector221>:
.globl vector221
vector221:
  pushl $0
80107ec3:	6a 00                	push   $0x0
  pushl $221
80107ec5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107eca:	e9 33 f2 ff ff       	jmp    80107102 <alltraps>

80107ecf <vector222>:
.globl vector222
vector222:
  pushl $0
80107ecf:	6a 00                	push   $0x0
  pushl $222
80107ed1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107ed6:	e9 27 f2 ff ff       	jmp    80107102 <alltraps>

80107edb <vector223>:
.globl vector223
vector223:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $223
80107edd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107ee2:	e9 1b f2 ff ff       	jmp    80107102 <alltraps>

80107ee7 <vector224>:
.globl vector224
vector224:
  pushl $0
80107ee7:	6a 00                	push   $0x0
  pushl $224
80107ee9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107eee:	e9 0f f2 ff ff       	jmp    80107102 <alltraps>

80107ef3 <vector225>:
.globl vector225
vector225:
  pushl $0
80107ef3:	6a 00                	push   $0x0
  pushl $225
80107ef5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107efa:	e9 03 f2 ff ff       	jmp    80107102 <alltraps>

80107eff <vector226>:
.globl vector226
vector226:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $226
80107f01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107f06:	e9 f7 f1 ff ff       	jmp    80107102 <alltraps>

80107f0b <vector227>:
.globl vector227
vector227:
  pushl $0
80107f0b:	6a 00                	push   $0x0
  pushl $227
80107f0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107f12:	e9 eb f1 ff ff       	jmp    80107102 <alltraps>

80107f17 <vector228>:
.globl vector228
vector228:
  pushl $0
80107f17:	6a 00                	push   $0x0
  pushl $228
80107f19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107f1e:	e9 df f1 ff ff       	jmp    80107102 <alltraps>

80107f23 <vector229>:
.globl vector229
vector229:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $229
80107f25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107f2a:	e9 d3 f1 ff ff       	jmp    80107102 <alltraps>

80107f2f <vector230>:
.globl vector230
vector230:
  pushl $0
80107f2f:	6a 00                	push   $0x0
  pushl $230
80107f31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107f36:	e9 c7 f1 ff ff       	jmp    80107102 <alltraps>

80107f3b <vector231>:
.globl vector231
vector231:
  pushl $0
80107f3b:	6a 00                	push   $0x0
  pushl $231
80107f3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107f42:	e9 bb f1 ff ff       	jmp    80107102 <alltraps>

80107f47 <vector232>:
.globl vector232
vector232:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $232
80107f49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107f4e:	e9 af f1 ff ff       	jmp    80107102 <alltraps>

80107f53 <vector233>:
.globl vector233
vector233:
  pushl $0
80107f53:	6a 00                	push   $0x0
  pushl $233
80107f55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107f5a:	e9 a3 f1 ff ff       	jmp    80107102 <alltraps>

80107f5f <vector234>:
.globl vector234
vector234:
  pushl $0
80107f5f:	6a 00                	push   $0x0
  pushl $234
80107f61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107f66:	e9 97 f1 ff ff       	jmp    80107102 <alltraps>

80107f6b <vector235>:
.globl vector235
vector235:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $235
80107f6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107f72:	e9 8b f1 ff ff       	jmp    80107102 <alltraps>

80107f77 <vector236>:
.globl vector236
vector236:
  pushl $0
80107f77:	6a 00                	push   $0x0
  pushl $236
80107f79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107f7e:	e9 7f f1 ff ff       	jmp    80107102 <alltraps>

80107f83 <vector237>:
.globl vector237
vector237:
  pushl $0
80107f83:	6a 00                	push   $0x0
  pushl $237
80107f85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107f8a:	e9 73 f1 ff ff       	jmp    80107102 <alltraps>

80107f8f <vector238>:
.globl vector238
vector238:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $238
80107f91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107f96:	e9 67 f1 ff ff       	jmp    80107102 <alltraps>

80107f9b <vector239>:
.globl vector239
vector239:
  pushl $0
80107f9b:	6a 00                	push   $0x0
  pushl $239
80107f9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107fa2:	e9 5b f1 ff ff       	jmp    80107102 <alltraps>

80107fa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80107fa7:	6a 00                	push   $0x0
  pushl $240
80107fa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107fae:	e9 4f f1 ff ff       	jmp    80107102 <alltraps>

80107fb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $241
80107fb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107fba:	e9 43 f1 ff ff       	jmp    80107102 <alltraps>

80107fbf <vector242>:
.globl vector242
vector242:
  pushl $0
80107fbf:	6a 00                	push   $0x0
  pushl $242
80107fc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107fc6:	e9 37 f1 ff ff       	jmp    80107102 <alltraps>

80107fcb <vector243>:
.globl vector243
vector243:
  pushl $0
80107fcb:	6a 00                	push   $0x0
  pushl $243
80107fcd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107fd2:	e9 2b f1 ff ff       	jmp    80107102 <alltraps>

80107fd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $244
80107fd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107fde:	e9 1f f1 ff ff       	jmp    80107102 <alltraps>

80107fe3 <vector245>:
.globl vector245
vector245:
  pushl $0
80107fe3:	6a 00                	push   $0x0
  pushl $245
80107fe5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107fea:	e9 13 f1 ff ff       	jmp    80107102 <alltraps>

80107fef <vector246>:
.globl vector246
vector246:
  pushl $0
80107fef:	6a 00                	push   $0x0
  pushl $246
80107ff1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107ff6:	e9 07 f1 ff ff       	jmp    80107102 <alltraps>

80107ffb <vector247>:
.globl vector247
vector247:
  pushl $0
80107ffb:	6a 00                	push   $0x0
  pushl $247
80107ffd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108002:	e9 fb f0 ff ff       	jmp    80107102 <alltraps>

80108007 <vector248>:
.globl vector248
vector248:
  pushl $0
80108007:	6a 00                	push   $0x0
  pushl $248
80108009:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010800e:	e9 ef f0 ff ff       	jmp    80107102 <alltraps>

80108013 <vector249>:
.globl vector249
vector249:
  pushl $0
80108013:	6a 00                	push   $0x0
  pushl $249
80108015:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010801a:	e9 e3 f0 ff ff       	jmp    80107102 <alltraps>

8010801f <vector250>:
.globl vector250
vector250:
  pushl $0
8010801f:	6a 00                	push   $0x0
  pushl $250
80108021:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108026:	e9 d7 f0 ff ff       	jmp    80107102 <alltraps>

8010802b <vector251>:
.globl vector251
vector251:
  pushl $0
8010802b:	6a 00                	push   $0x0
  pushl $251
8010802d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108032:	e9 cb f0 ff ff       	jmp    80107102 <alltraps>

80108037 <vector252>:
.globl vector252
vector252:
  pushl $0
80108037:	6a 00                	push   $0x0
  pushl $252
80108039:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010803e:	e9 bf f0 ff ff       	jmp    80107102 <alltraps>

80108043 <vector253>:
.globl vector253
vector253:
  pushl $0
80108043:	6a 00                	push   $0x0
  pushl $253
80108045:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010804a:	e9 b3 f0 ff ff       	jmp    80107102 <alltraps>

8010804f <vector254>:
.globl vector254
vector254:
  pushl $0
8010804f:	6a 00                	push   $0x0
  pushl $254
80108051:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80108056:	e9 a7 f0 ff ff       	jmp    80107102 <alltraps>

8010805b <vector255>:
.globl vector255
vector255:
  pushl $0
8010805b:	6a 00                	push   $0x0
  pushl $255
8010805d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108062:	e9 9b f0 ff ff       	jmp    80107102 <alltraps>
80108067:	66 90                	xchg   %ax,%ax
80108069:	66 90                	xchg   %ax,%ax
8010806b:	66 90                	xchg   %ax,%ax
8010806d:	66 90                	xchg   %ax,%ax
8010806f:	90                   	nop

80108070 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108070:	55                   	push   %ebp
80108071:	89 e5                	mov    %esp,%ebp
80108073:	57                   	push   %edi
80108074:	56                   	push   %esi
80108075:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80108076:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010807c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108082:	83 ec 1c             	sub    $0x1c,%esp
80108085:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108088:	39 d3                	cmp    %edx,%ebx
8010808a:	73 49                	jae    801080d5 <deallocuvm.part.0+0x65>
8010808c:	89 c7                	mov    %eax,%edi
8010808e:	eb 0c                	jmp    8010809c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108090:	83 c0 01             	add    $0x1,%eax
80108093:	c1 e0 16             	shl    $0x16,%eax
80108096:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80108098:	39 da                	cmp    %ebx,%edx
8010809a:	76 39                	jbe    801080d5 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
8010809c:	89 d8                	mov    %ebx,%eax
8010809e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801080a1:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
801080a4:	f6 c1 01             	test   $0x1,%cl
801080a7:	74 e7                	je     80108090 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
801080a9:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801080ab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801080b1:	c1 ee 0a             	shr    $0xa,%esi
801080b4:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
801080ba:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
801080c1:	85 f6                	test   %esi,%esi
801080c3:	74 cb                	je     80108090 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
801080c5:	8b 06                	mov    (%esi),%eax
801080c7:	a8 01                	test   $0x1,%al
801080c9:	75 15                	jne    801080e0 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
801080cb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801080d1:	39 da                	cmp    %ebx,%edx
801080d3:	77 c7                	ja     8010809c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801080d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080db:	5b                   	pop    %ebx
801080dc:	5e                   	pop    %esi
801080dd:	5f                   	pop    %edi
801080de:	5d                   	pop    %ebp
801080df:	c3                   	ret    
      if(pa == 0)
801080e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080e5:	74 25                	je     8010810c <deallocuvm.part.0+0x9c>
      kfree(v);
801080e7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801080ea:	05 00 00 00 80       	add    $0x80000000,%eax
801080ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801080f2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
801080f8:	50                   	push   %eax
801080f9:	e8 62 a8 ff ff       	call   80102960 <kfree>
      *pte = 0;
801080fe:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80108104:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108107:	83 c4 10             	add    $0x10,%esp
8010810a:	eb 8c                	jmp    80108098 <deallocuvm.part.0+0x28>
        panic("kfree");
8010810c:	83 ec 0c             	sub    $0xc,%esp
8010810f:	68 c6 8c 10 80       	push   $0x80108cc6
80108114:	e8 67 82 ff ff       	call   80100380 <panic>
80108119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108120 <mappages>:
{
80108120:	55                   	push   %ebp
80108121:	89 e5                	mov    %esp,%ebp
80108123:	57                   	push   %edi
80108124:	56                   	push   %esi
80108125:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108126:	89 d3                	mov    %edx,%ebx
80108128:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010812e:	83 ec 1c             	sub    $0x1c,%esp
80108131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108134:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80108138:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010813d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108140:	8b 45 08             	mov    0x8(%ebp),%eax
80108143:	29 d8                	sub    %ebx,%eax
80108145:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108148:	eb 3d                	jmp    80108187 <mappages+0x67>
8010814a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108150:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108152:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108157:	c1 ea 0a             	shr    $0xa,%edx
8010815a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108160:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108167:	85 c0                	test   %eax,%eax
80108169:	74 75                	je     801081e0 <mappages+0xc0>
    if(*pte & PTE_P)
8010816b:	f6 00 01             	testb  $0x1,(%eax)
8010816e:	0f 85 86 00 00 00    	jne    801081fa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80108174:	0b 75 0c             	or     0xc(%ebp),%esi
80108177:	83 ce 01             	or     $0x1,%esi
8010817a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010817c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010817f:	74 6f                	je     801081f0 <mappages+0xd0>
    a += PGSIZE;
80108181:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80108187:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010818a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010818d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80108190:	89 d8                	mov    %ebx,%eax
80108192:	c1 e8 16             	shr    $0x16,%eax
80108195:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80108198:	8b 07                	mov    (%edi),%eax
8010819a:	a8 01                	test   $0x1,%al
8010819c:	75 b2                	jne    80108150 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010819e:	e8 7d a9 ff ff       	call   80102b20 <kalloc>
801081a3:	85 c0                	test   %eax,%eax
801081a5:	74 39                	je     801081e0 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801081a7:	83 ec 04             	sub    $0x4,%esp
801081aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
801081ad:	68 00 10 00 00       	push   $0x1000
801081b2:	6a 00                	push   $0x0
801081b4:	50                   	push   %eax
801081b5:	e8 16 da ff ff       	call   80105bd0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801081ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801081bd:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801081c0:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801081c6:	83 c8 07             	or     $0x7,%eax
801081c9:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801081cb:	89 d8                	mov    %ebx,%eax
801081cd:	c1 e8 0a             	shr    $0xa,%eax
801081d0:	25 fc 0f 00 00       	and    $0xffc,%eax
801081d5:	01 d0                	add    %edx,%eax
801081d7:	eb 92                	jmp    8010816b <mappages+0x4b>
801081d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801081e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801081e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801081e8:	5b                   	pop    %ebx
801081e9:	5e                   	pop    %esi
801081ea:	5f                   	pop    %edi
801081eb:	5d                   	pop    %ebp
801081ec:	c3                   	ret    
801081ed:	8d 76 00             	lea    0x0(%esi),%esi
801081f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801081f3:	31 c0                	xor    %eax,%eax
}
801081f5:	5b                   	pop    %ebx
801081f6:	5e                   	pop    %esi
801081f7:	5f                   	pop    %edi
801081f8:	5d                   	pop    %ebp
801081f9:	c3                   	ret    
      panic("remap");
801081fa:	83 ec 0c             	sub    $0xc,%esp
801081fd:	68 30 97 10 80       	push   $0x80109730
80108202:	e8 79 81 ff ff       	call   80100380 <panic>
80108207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010820e:	66 90                	xchg   %ax,%ax

80108210 <seginit>:
{
80108210:	55                   	push   %ebp
80108211:	89 e5                	mov    %esp,%ebp
80108213:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80108216:	e8 b5 bc ff ff       	call   80103ed0 <cpuid>
  pd[0] = size-1;
8010821b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80108220:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80108226:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010822a:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80108231:	ff 00 00 
80108234:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
8010823b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010823e:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80108245:	ff 00 00 
80108248:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
8010824f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108252:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80108259:	ff 00 00 
8010825c:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80108263:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108266:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
8010826d:	ff 00 00 
80108270:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80108277:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010827a:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
8010827f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108283:	c1 e8 10             	shr    $0x10,%eax
80108286:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010828a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010828d:	0f 01 10             	lgdtl  (%eax)
}
80108290:	c9                   	leave  
80108291:	c3                   	ret    
80108292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801082a0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801082a0:	a1 44 6f 11 80       	mov    0x80116f44,%eax
801082a5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801082aa:	0f 22 d8             	mov    %eax,%cr3
}
801082ad:	c3                   	ret    
801082ae:	66 90                	xchg   %ax,%ax

801082b0 <switchuvm>:
{
801082b0:	55                   	push   %ebp
801082b1:	89 e5                	mov    %esp,%ebp
801082b3:	57                   	push   %edi
801082b4:	56                   	push   %esi
801082b5:	53                   	push   %ebx
801082b6:	83 ec 1c             	sub    $0x1c,%esp
801082b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801082bc:	85 f6                	test   %esi,%esi
801082be:	0f 84 cb 00 00 00    	je     8010838f <switchuvm+0xdf>
  if(p->kstack == 0)
801082c4:	8b 46 08             	mov    0x8(%esi),%eax
801082c7:	85 c0                	test   %eax,%eax
801082c9:	0f 84 da 00 00 00    	je     801083a9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801082cf:	8b 46 04             	mov    0x4(%esi),%eax
801082d2:	85 c0                	test   %eax,%eax
801082d4:	0f 84 c2 00 00 00    	je     8010839c <switchuvm+0xec>
  pushcli();
801082da:	e8 e1 d6 ff ff       	call   801059c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801082df:	e8 8c bb ff ff       	call   80103e70 <mycpu>
801082e4:	89 c3                	mov    %eax,%ebx
801082e6:	e8 85 bb ff ff       	call   80103e70 <mycpu>
801082eb:	89 c7                	mov    %eax,%edi
801082ed:	e8 7e bb ff ff       	call   80103e70 <mycpu>
801082f2:	83 c7 08             	add    $0x8,%edi
801082f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801082f8:	e8 73 bb ff ff       	call   80103e70 <mycpu>
801082fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108300:	ba 67 00 00 00       	mov    $0x67,%edx
80108305:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010830c:	83 c0 08             	add    $0x8,%eax
8010830f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108316:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010831b:	83 c1 08             	add    $0x8,%ecx
8010831e:	c1 e8 18             	shr    $0x18,%eax
80108321:	c1 e9 10             	shr    $0x10,%ecx
80108324:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010832a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108330:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108335:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010833c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108341:	e8 2a bb ff ff       	call   80103e70 <mycpu>
80108346:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010834d:	e8 1e bb ff ff       	call   80103e70 <mycpu>
80108352:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80108356:	8b 5e 08             	mov    0x8(%esi),%ebx
80108359:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010835f:	e8 0c bb ff ff       	call   80103e70 <mycpu>
80108364:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80108367:	e8 04 bb ff ff       	call   80103e70 <mycpu>
8010836c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108370:	b8 28 00 00 00       	mov    $0x28,%eax
80108375:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80108378:	8b 46 04             	mov    0x4(%esi),%eax
8010837b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108380:	0f 22 d8             	mov    %eax,%cr3
}
80108383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108386:	5b                   	pop    %ebx
80108387:	5e                   	pop    %esi
80108388:	5f                   	pop    %edi
80108389:	5d                   	pop    %ebp
  popcli();
8010838a:	e9 81 d6 ff ff       	jmp    80105a10 <popcli>
    panic("switchuvm: no process");
8010838f:	83 ec 0c             	sub    $0xc,%esp
80108392:	68 36 97 10 80       	push   $0x80109736
80108397:	e8 e4 7f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010839c:	83 ec 0c             	sub    $0xc,%esp
8010839f:	68 61 97 10 80       	push   $0x80109761
801083a4:	e8 d7 7f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
801083a9:	83 ec 0c             	sub    $0xc,%esp
801083ac:	68 4c 97 10 80       	push   $0x8010974c
801083b1:	e8 ca 7f ff ff       	call   80100380 <panic>
801083b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083bd:	8d 76 00             	lea    0x0(%esi),%esi

801083c0 <inituvm>:
{
801083c0:	55                   	push   %ebp
801083c1:	89 e5                	mov    %esp,%ebp
801083c3:	57                   	push   %edi
801083c4:	56                   	push   %esi
801083c5:	53                   	push   %ebx
801083c6:	83 ec 1c             	sub    $0x1c,%esp
801083c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083cc:	8b 75 10             	mov    0x10(%ebp),%esi
801083cf:	8b 7d 08             	mov    0x8(%ebp),%edi
801083d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801083d5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801083db:	77 4b                	ja     80108428 <inituvm+0x68>
  mem = kalloc();
801083dd:	e8 3e a7 ff ff       	call   80102b20 <kalloc>
  memset(mem, 0, PGSIZE);
801083e2:	83 ec 04             	sub    $0x4,%esp
801083e5:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801083ea:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801083ec:	6a 00                	push   $0x0
801083ee:	50                   	push   %eax
801083ef:	e8 dc d7 ff ff       	call   80105bd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801083f4:	58                   	pop    %eax
801083f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801083fb:	5a                   	pop    %edx
801083fc:	6a 06                	push   $0x6
801083fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108403:	31 d2                	xor    %edx,%edx
80108405:	50                   	push   %eax
80108406:	89 f8                	mov    %edi,%eax
80108408:	e8 13 fd ff ff       	call   80108120 <mappages>
  memmove(mem, init, sz);
8010840d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108410:	89 75 10             	mov    %esi,0x10(%ebp)
80108413:	83 c4 10             	add    $0x10,%esp
80108416:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108419:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010841c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010841f:	5b                   	pop    %ebx
80108420:	5e                   	pop    %esi
80108421:	5f                   	pop    %edi
80108422:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108423:	e9 48 d8 ff ff       	jmp    80105c70 <memmove>
    panic("inituvm: more than a page");
80108428:	83 ec 0c             	sub    $0xc,%esp
8010842b:	68 75 97 10 80       	push   $0x80109775
80108430:	e8 4b 7f ff ff       	call   80100380 <panic>
80108435:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010843c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108440 <loaduvm>:
{
80108440:	55                   	push   %ebp
80108441:	89 e5                	mov    %esp,%ebp
80108443:	57                   	push   %edi
80108444:	56                   	push   %esi
80108445:	53                   	push   %ebx
80108446:	83 ec 1c             	sub    $0x1c,%esp
80108449:	8b 45 0c             	mov    0xc(%ebp),%eax
8010844c:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
8010844f:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108454:	0f 85 bb 00 00 00    	jne    80108515 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010845a:	01 f0                	add    %esi,%eax
8010845c:	89 f3                	mov    %esi,%ebx
8010845e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108461:	8b 45 14             	mov    0x14(%ebp),%eax
80108464:	01 f0                	add    %esi,%eax
80108466:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80108469:	85 f6                	test   %esi,%esi
8010846b:	0f 84 87 00 00 00    	je     801084f8 <loaduvm+0xb8>
80108471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80108478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010847b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010847e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80108480:	89 c2                	mov    %eax,%edx
80108482:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80108485:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80108488:	f6 c2 01             	test   $0x1,%dl
8010848b:	75 13                	jne    801084a0 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010848d:	83 ec 0c             	sub    $0xc,%esp
80108490:	68 8f 97 10 80       	push   $0x8010978f
80108495:	e8 e6 7e ff ff       	call   80100380 <panic>
8010849a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801084a0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801084a3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801084a9:	25 fc 0f 00 00       	and    $0xffc,%eax
801084ae:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801084b5:	85 c0                	test   %eax,%eax
801084b7:	74 d4                	je     8010848d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
801084b9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801084bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801084be:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801084c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801084c8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801084ce:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801084d1:	29 d9                	sub    %ebx,%ecx
801084d3:	05 00 00 00 80       	add    $0x80000000,%eax
801084d8:	57                   	push   %edi
801084d9:	51                   	push   %ecx
801084da:	50                   	push   %eax
801084db:	ff 75 10             	push   0x10(%ebp)
801084de:	e8 4d 9a ff ff       	call   80101f30 <readi>
801084e3:	83 c4 10             	add    $0x10,%esp
801084e6:	39 f8                	cmp    %edi,%eax
801084e8:	75 1e                	jne    80108508 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801084ea:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801084f0:	89 f0                	mov    %esi,%eax
801084f2:	29 d8                	sub    %ebx,%eax
801084f4:	39 c6                	cmp    %eax,%esi
801084f6:	77 80                	ja     80108478 <loaduvm+0x38>
}
801084f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801084fb:	31 c0                	xor    %eax,%eax
}
801084fd:	5b                   	pop    %ebx
801084fe:	5e                   	pop    %esi
801084ff:	5f                   	pop    %edi
80108500:	5d                   	pop    %ebp
80108501:	c3                   	ret    
80108502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108508:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010850b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108510:	5b                   	pop    %ebx
80108511:	5e                   	pop    %esi
80108512:	5f                   	pop    %edi
80108513:	5d                   	pop    %ebp
80108514:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80108515:	83 ec 0c             	sub    $0xc,%esp
80108518:	68 30 98 10 80       	push   $0x80109830
8010851d:	e8 5e 7e ff ff       	call   80100380 <panic>
80108522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108530 <allocuvm>:
{
80108530:	55                   	push   %ebp
80108531:	89 e5                	mov    %esp,%ebp
80108533:	57                   	push   %edi
80108534:	56                   	push   %esi
80108535:	53                   	push   %ebx
80108536:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80108539:	8b 45 10             	mov    0x10(%ebp),%eax
{
8010853c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
8010853f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108542:	85 c0                	test   %eax,%eax
80108544:	0f 88 b6 00 00 00    	js     80108600 <allocuvm+0xd0>
  if(newsz < oldsz)
8010854a:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
8010854d:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108550:	0f 82 9a 00 00 00    	jb     801085f0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80108556:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010855c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108562:	39 75 10             	cmp    %esi,0x10(%ebp)
80108565:	77 44                	ja     801085ab <allocuvm+0x7b>
80108567:	e9 87 00 00 00       	jmp    801085f3 <allocuvm+0xc3>
8010856c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80108570:	83 ec 04             	sub    $0x4,%esp
80108573:	68 00 10 00 00       	push   $0x1000
80108578:	6a 00                	push   $0x0
8010857a:	50                   	push   %eax
8010857b:	e8 50 d6 ff ff       	call   80105bd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108580:	58                   	pop    %eax
80108581:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108587:	5a                   	pop    %edx
80108588:	6a 06                	push   $0x6
8010858a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010858f:	89 f2                	mov    %esi,%edx
80108591:	50                   	push   %eax
80108592:	89 f8                	mov    %edi,%eax
80108594:	e8 87 fb ff ff       	call   80108120 <mappages>
80108599:	83 c4 10             	add    $0x10,%esp
8010859c:	85 c0                	test   %eax,%eax
8010859e:	78 78                	js     80108618 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801085a0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801085a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801085a9:	76 48                	jbe    801085f3 <allocuvm+0xc3>
    mem = kalloc();
801085ab:	e8 70 a5 ff ff       	call   80102b20 <kalloc>
801085b0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801085b2:	85 c0                	test   %eax,%eax
801085b4:	75 ba                	jne    80108570 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801085b6:	83 ec 0c             	sub    $0xc,%esp
801085b9:	68 ad 97 10 80       	push   $0x801097ad
801085be:	e8 2d 81 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
801085c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801085c6:	83 c4 10             	add    $0x10,%esp
801085c9:	39 45 10             	cmp    %eax,0x10(%ebp)
801085cc:	74 32                	je     80108600 <allocuvm+0xd0>
801085ce:	8b 55 10             	mov    0x10(%ebp),%edx
801085d1:	89 c1                	mov    %eax,%ecx
801085d3:	89 f8                	mov    %edi,%eax
801085d5:	e8 96 fa ff ff       	call   80108070 <deallocuvm.part.0>
      return 0;
801085da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801085e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801085e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085e7:	5b                   	pop    %ebx
801085e8:	5e                   	pop    %esi
801085e9:	5f                   	pop    %edi
801085ea:	5d                   	pop    %ebp
801085eb:	c3                   	ret    
801085ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801085f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801085f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801085f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085f9:	5b                   	pop    %ebx
801085fa:	5e                   	pop    %esi
801085fb:	5f                   	pop    %edi
801085fc:	5d                   	pop    %ebp
801085fd:	c3                   	ret    
801085fe:	66 90                	xchg   %ax,%ax
    return 0;
80108600:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010860a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010860d:	5b                   	pop    %ebx
8010860e:	5e                   	pop    %esi
8010860f:	5f                   	pop    %edi
80108610:	5d                   	pop    %ebp
80108611:	c3                   	ret    
80108612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108618:	83 ec 0c             	sub    $0xc,%esp
8010861b:	68 c5 97 10 80       	push   $0x801097c5
80108620:	e8 cb 80 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80108625:	8b 45 0c             	mov    0xc(%ebp),%eax
80108628:	83 c4 10             	add    $0x10,%esp
8010862b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010862e:	74 0c                	je     8010863c <allocuvm+0x10c>
80108630:	8b 55 10             	mov    0x10(%ebp),%edx
80108633:	89 c1                	mov    %eax,%ecx
80108635:	89 f8                	mov    %edi,%eax
80108637:	e8 34 fa ff ff       	call   80108070 <deallocuvm.part.0>
      kfree(mem);
8010863c:	83 ec 0c             	sub    $0xc,%esp
8010863f:	53                   	push   %ebx
80108640:	e8 1b a3 ff ff       	call   80102960 <kfree>
      return 0;
80108645:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010864c:	83 c4 10             	add    $0x10,%esp
}
8010864f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108652:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108655:	5b                   	pop    %ebx
80108656:	5e                   	pop    %esi
80108657:	5f                   	pop    %edi
80108658:	5d                   	pop    %ebp
80108659:	c3                   	ret    
8010865a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108660 <deallocuvm>:
{
80108660:	55                   	push   %ebp
80108661:	89 e5                	mov    %esp,%ebp
80108663:	8b 55 0c             	mov    0xc(%ebp),%edx
80108666:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108669:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010866c:	39 d1                	cmp    %edx,%ecx
8010866e:	73 10                	jae    80108680 <deallocuvm+0x20>
}
80108670:	5d                   	pop    %ebp
80108671:	e9 fa f9 ff ff       	jmp    80108070 <deallocuvm.part.0>
80108676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010867d:	8d 76 00             	lea    0x0(%esi),%esi
80108680:	89 d0                	mov    %edx,%eax
80108682:	5d                   	pop    %ebp
80108683:	c3                   	ret    
80108684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010868b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010868f:	90                   	nop

80108690 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108690:	55                   	push   %ebp
80108691:	89 e5                	mov    %esp,%ebp
80108693:	57                   	push   %edi
80108694:	56                   	push   %esi
80108695:	53                   	push   %ebx
80108696:	83 ec 0c             	sub    $0xc,%esp
80108699:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010869c:	85 f6                	test   %esi,%esi
8010869e:	74 59                	je     801086f9 <freevm+0x69>
  if(newsz >= oldsz)
801086a0:	31 c9                	xor    %ecx,%ecx
801086a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801086a7:	89 f0                	mov    %esi,%eax
801086a9:	89 f3                	mov    %esi,%ebx
801086ab:	e8 c0 f9 ff ff       	call   80108070 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801086b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801086b6:	eb 0f                	jmp    801086c7 <freevm+0x37>
801086b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086bf:	90                   	nop
801086c0:	83 c3 04             	add    $0x4,%ebx
801086c3:	39 df                	cmp    %ebx,%edi
801086c5:	74 23                	je     801086ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801086c7:	8b 03                	mov    (%ebx),%eax
801086c9:	a8 01                	test   $0x1,%al
801086cb:	74 f3                	je     801086c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801086cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801086d2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801086d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801086d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801086dd:	50                   	push   %eax
801086de:	e8 7d a2 ff ff       	call   80102960 <kfree>
801086e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801086e6:	39 df                	cmp    %ebx,%edi
801086e8:	75 dd                	jne    801086c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801086ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801086ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086f0:	5b                   	pop    %ebx
801086f1:	5e                   	pop    %esi
801086f2:	5f                   	pop    %edi
801086f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801086f4:	e9 67 a2 ff ff       	jmp    80102960 <kfree>
    panic("freevm: no pgdir");
801086f9:	83 ec 0c             	sub    $0xc,%esp
801086fc:	68 e1 97 10 80       	push   $0x801097e1
80108701:	e8 7a 7c ff ff       	call   80100380 <panic>
80108706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010870d:	8d 76 00             	lea    0x0(%esi),%esi

80108710 <setupkvm>:
{
80108710:	55                   	push   %ebp
80108711:	89 e5                	mov    %esp,%ebp
80108713:	56                   	push   %esi
80108714:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108715:	e8 06 a4 ff ff       	call   80102b20 <kalloc>
8010871a:	89 c6                	mov    %eax,%esi
8010871c:	85 c0                	test   %eax,%eax
8010871e:	74 42                	je     80108762 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108720:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108723:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108728:	68 00 10 00 00       	push   $0x1000
8010872d:	6a 00                	push   $0x0
8010872f:	50                   	push   %eax
80108730:	e8 9b d4 ff ff       	call   80105bd0 <memset>
80108735:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108738:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010873b:	83 ec 08             	sub    $0x8,%esp
8010873e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108741:	ff 73 0c             	push   0xc(%ebx)
80108744:	8b 13                	mov    (%ebx),%edx
80108746:	50                   	push   %eax
80108747:	29 c1                	sub    %eax,%ecx
80108749:	89 f0                	mov    %esi,%eax
8010874b:	e8 d0 f9 ff ff       	call   80108120 <mappages>
80108750:	83 c4 10             	add    $0x10,%esp
80108753:	85 c0                	test   %eax,%eax
80108755:	78 19                	js     80108770 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108757:	83 c3 10             	add    $0x10,%ebx
8010875a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108760:	75 d6                	jne    80108738 <setupkvm+0x28>
}
80108762:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108765:	89 f0                	mov    %esi,%eax
80108767:	5b                   	pop    %ebx
80108768:	5e                   	pop    %esi
80108769:	5d                   	pop    %ebp
8010876a:	c3                   	ret    
8010876b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010876f:	90                   	nop
      freevm(pgdir);
80108770:	83 ec 0c             	sub    $0xc,%esp
80108773:	56                   	push   %esi
      return 0;
80108774:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108776:	e8 15 ff ff ff       	call   80108690 <freevm>
      return 0;
8010877b:	83 c4 10             	add    $0x10,%esp
}
8010877e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108781:	89 f0                	mov    %esi,%eax
80108783:	5b                   	pop    %ebx
80108784:	5e                   	pop    %esi
80108785:	5d                   	pop    %ebp
80108786:	c3                   	ret    
80108787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010878e:	66 90                	xchg   %ax,%ax

80108790 <kvmalloc>:
{
80108790:	55                   	push   %ebp
80108791:	89 e5                	mov    %esp,%ebp
80108793:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108796:	e8 75 ff ff ff       	call   80108710 <setupkvm>
8010879b:	a3 44 6f 11 80       	mov    %eax,0x80116f44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801087a0:	05 00 00 00 80       	add    $0x80000000,%eax
801087a5:	0f 22 d8             	mov    %eax,%cr3
}
801087a8:	c9                   	leave  
801087a9:	c3                   	ret    
801087aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801087b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801087b0:	55                   	push   %ebp
801087b1:	89 e5                	mov    %esp,%ebp
801087b3:	83 ec 08             	sub    $0x8,%esp
801087b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801087b9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801087bc:	89 c1                	mov    %eax,%ecx
801087be:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801087c1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801087c4:	f6 c2 01             	test   $0x1,%dl
801087c7:	75 17                	jne    801087e0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801087c9:	83 ec 0c             	sub    $0xc,%esp
801087cc:	68 f2 97 10 80       	push   $0x801097f2
801087d1:	e8 aa 7b ff ff       	call   80100380 <panic>
801087d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087dd:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801087e0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801087e3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
801087e9:	25 fc 0f 00 00       	and    $0xffc,%eax
801087ee:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801087f5:	85 c0                	test   %eax,%eax
801087f7:	74 d0                	je     801087c9 <clearpteu+0x19>
  *pte &= ~PTE_U;
801087f9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801087fc:	c9                   	leave  
801087fd:	c3                   	ret    
801087fe:	66 90                	xchg   %ax,%ax

80108800 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108800:	55                   	push   %ebp
80108801:	89 e5                	mov    %esp,%ebp
80108803:	57                   	push   %edi
80108804:	56                   	push   %esi
80108805:	53                   	push   %ebx
80108806:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108809:	e8 02 ff ff ff       	call   80108710 <setupkvm>
8010880e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108811:	85 c0                	test   %eax,%eax
80108813:	0f 84 bd 00 00 00    	je     801088d6 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108819:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010881c:	85 c9                	test   %ecx,%ecx
8010881e:	0f 84 b2 00 00 00    	je     801088d6 <copyuvm+0xd6>
80108824:	31 f6                	xor    %esi,%esi
80108826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010882d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108830:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108833:	89 f0                	mov    %esi,%eax
80108835:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108838:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010883b:	a8 01                	test   $0x1,%al
8010883d:	75 11                	jne    80108850 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010883f:	83 ec 0c             	sub    $0xc,%esp
80108842:	68 fc 97 10 80       	push   $0x801097fc
80108847:	e8 34 7b ff ff       	call   80100380 <panic>
8010884c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80108850:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108852:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80108857:	c1 ea 0a             	shr    $0xa,%edx
8010885a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80108860:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108867:	85 c0                	test   %eax,%eax
80108869:	74 d4                	je     8010883f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010886b:	8b 00                	mov    (%eax),%eax
8010886d:	a8 01                	test   $0x1,%al
8010886f:	0f 84 9f 00 00 00    	je     80108914 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80108875:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108877:	25 ff 0f 00 00       	and    $0xfff,%eax
8010887c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010887f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108885:	e8 96 a2 ff ff       	call   80102b20 <kalloc>
8010888a:	89 c3                	mov    %eax,%ebx
8010888c:	85 c0                	test   %eax,%eax
8010888e:	74 64                	je     801088f4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108890:	83 ec 04             	sub    $0x4,%esp
80108893:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108899:	68 00 10 00 00       	push   $0x1000
8010889e:	57                   	push   %edi
8010889f:	50                   	push   %eax
801088a0:	e8 cb d3 ff ff       	call   80105c70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801088a5:	58                   	pop    %eax
801088a6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801088ac:	5a                   	pop    %edx
801088ad:	ff 75 e4             	push   -0x1c(%ebp)
801088b0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801088b5:	89 f2                	mov    %esi,%edx
801088b7:	50                   	push   %eax
801088b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088bb:	e8 60 f8 ff ff       	call   80108120 <mappages>
801088c0:	83 c4 10             	add    $0x10,%esp
801088c3:	85 c0                	test   %eax,%eax
801088c5:	78 21                	js     801088e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801088c7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801088cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
801088d0:	0f 87 5a ff ff ff    	ja     80108830 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801088d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088dc:	5b                   	pop    %ebx
801088dd:	5e                   	pop    %esi
801088de:	5f                   	pop    %edi
801088df:	5d                   	pop    %ebp
801088e0:	c3                   	ret    
801088e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801088e8:	83 ec 0c             	sub    $0xc,%esp
801088eb:	53                   	push   %ebx
801088ec:	e8 6f a0 ff ff       	call   80102960 <kfree>
      goto bad;
801088f1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801088f4:	83 ec 0c             	sub    $0xc,%esp
801088f7:	ff 75 e0             	push   -0x20(%ebp)
801088fa:	e8 91 fd ff ff       	call   80108690 <freevm>
  return 0;
801088ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108906:	83 c4 10             	add    $0x10,%esp
}
80108909:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010890c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010890f:	5b                   	pop    %ebx
80108910:	5e                   	pop    %esi
80108911:	5f                   	pop    %edi
80108912:	5d                   	pop    %ebp
80108913:	c3                   	ret    
      panic("copyuvm: page not present");
80108914:	83 ec 0c             	sub    $0xc,%esp
80108917:	68 16 98 10 80       	push   $0x80109816
8010891c:	e8 5f 7a ff ff       	call   80100380 <panic>
80108921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010892f:	90                   	nop

80108930 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108930:	55                   	push   %ebp
80108931:	89 e5                	mov    %esp,%ebp
80108933:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108936:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108939:	89 c1                	mov    %eax,%ecx
8010893b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010893e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108941:	f6 c2 01             	test   $0x1,%dl
80108944:	0f 84 00 01 00 00    	je     80108a4a <uva2ka.cold>
  return &pgtab[PTX(va)];
8010894a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010894d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108953:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80108954:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80108959:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80108960:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108962:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108967:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010896a:	05 00 00 00 80       	add    $0x80000000,%eax
8010896f:	83 fa 05             	cmp    $0x5,%edx
80108972:	ba 00 00 00 00       	mov    $0x0,%edx
80108977:	0f 45 c2             	cmovne %edx,%eax
}
8010897a:	c3                   	ret    
8010897b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010897f:	90                   	nop

80108980 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108980:	55                   	push   %ebp
80108981:	89 e5                	mov    %esp,%ebp
80108983:	57                   	push   %edi
80108984:	56                   	push   %esi
80108985:	53                   	push   %ebx
80108986:	83 ec 0c             	sub    $0xc,%esp
80108989:	8b 75 14             	mov    0x14(%ebp),%esi
8010898c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010898f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108992:	85 f6                	test   %esi,%esi
80108994:	75 51                	jne    801089e7 <copyout+0x67>
80108996:	e9 a5 00 00 00       	jmp    80108a40 <copyout+0xc0>
8010899b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010899f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
801089a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801089a6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801089ac:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801089b2:	74 75                	je     80108a29 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
801089b4:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801089b6:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
801089b9:	29 c3                	sub    %eax,%ebx
801089bb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801089c1:	39 f3                	cmp    %esi,%ebx
801089c3:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
801089c6:	29 f8                	sub    %edi,%eax
801089c8:	83 ec 04             	sub    $0x4,%esp
801089cb:	01 c1                	add    %eax,%ecx
801089cd:	53                   	push   %ebx
801089ce:	52                   	push   %edx
801089cf:	51                   	push   %ecx
801089d0:	e8 9b d2 ff ff       	call   80105c70 <memmove>
    len -= n;
    buf += n;
801089d5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801089d8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801089de:	83 c4 10             	add    $0x10,%esp
    buf += n;
801089e1:	01 da                	add    %ebx,%edx
  while(len > 0){
801089e3:	29 de                	sub    %ebx,%esi
801089e5:	74 59                	je     80108a40 <copyout+0xc0>
  if(*pde & PTE_P){
801089e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801089ea:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801089ec:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801089ee:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801089f1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801089f7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801089fa:	f6 c1 01             	test   $0x1,%cl
801089fd:	0f 84 4e 00 00 00    	je     80108a51 <copyout.cold>
  return &pgtab[PTX(va)];
80108a03:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108a05:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80108a0b:	c1 eb 0c             	shr    $0xc,%ebx
80108a0e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108a14:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80108a1b:	89 d9                	mov    %ebx,%ecx
80108a1d:	83 e1 05             	and    $0x5,%ecx
80108a20:	83 f9 05             	cmp    $0x5,%ecx
80108a23:	0f 84 77 ff ff ff    	je     801089a0 <copyout+0x20>
  }
  return 0;
}
80108a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108a31:	5b                   	pop    %ebx
80108a32:	5e                   	pop    %esi
80108a33:	5f                   	pop    %edi
80108a34:	5d                   	pop    %ebp
80108a35:	c3                   	ret    
80108a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a3d:	8d 76 00             	lea    0x0(%esi),%esi
80108a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108a43:	31 c0                	xor    %eax,%eax
}
80108a45:	5b                   	pop    %ebx
80108a46:	5e                   	pop    %esi
80108a47:	5f                   	pop    %edi
80108a48:	5d                   	pop    %ebp
80108a49:	c3                   	ret    

80108a4a <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80108a4a:	a1 00 00 00 00       	mov    0x0,%eax
80108a4f:	0f 0b                	ud2    

80108a51 <copyout.cold>:
80108a51:	a1 00 00 00 00       	mov    0x0,%eax
80108a56:	0f 0b                	ud2    
