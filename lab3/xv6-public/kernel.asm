
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
80100028:	bc 50 68 11 80       	mov    $0x80116850,%esp

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
8010004c:	68 c0 82 10 80       	push   $0x801082c0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 65 53 00 00       	call   801053c0 <initlock>
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
80100092:	68 c7 82 10 80       	push   $0x801082c7
80100097:	50                   	push   %eax
80100098:	e8 f3 51 00 00       	call   80105290 <initsleeplock>
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
801000e4:	e8 a7 54 00 00       	call   80105590 <acquire>
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
80100162:	e8 c9 53 00 00       	call   80105530 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 51 00 00       	call   801052d0 <acquiresleep>
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
801001a1:	68 ce 82 10 80       	push   $0x801082ce
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
801001be:	e8 ad 51 00 00       	call   80105370 <holdingsleep>
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
801001dc:	68 df 82 10 80       	push   $0x801082df
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
801001ff:	e8 6c 51 00 00       	call   80105370 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 51 00 00       	call   80105330 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 70 53 00 00       	call   80105590 <acquire>
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
8010026c:	e9 bf 52 00 00       	jmp    80105530 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 e6 82 10 80       	push   $0x801082e6
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
801002a0:	e8 eb 52 00 00       	call   80105590 <acquire>
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
801002cd:	e8 7e 45 00 00       	call   80104850 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 09 3c 00 00       	call   80103ef0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 35 52 00 00       	call   80105530 <release>
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
8010034c:	e8 df 51 00 00       	call   80105530 <release>
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
801003a2:	68 ed 82 10 80       	push   $0x801082ed
801003a7:	e8 44 03 00 00       	call   801006f0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 3b 03 00 00       	call   801006f0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 bb 8e 10 80 	movl   $0x80108ebb,(%esp)
801003bc:	e8 2f 03 00 00       	call   801006f0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 50 00 00       	call   801053e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 83 10 80       	push   $0x80108301
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
80100575:	e8 76 51 00 00       	call   801056f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010057a:	b8 80 07 00 00       	mov    $0x780,%eax
8010057f:	83 c4 0c             	add    $0xc,%esp
80100582:	29 d8                	sub    %ebx,%eax
80100584:	01 c0                	add    %eax,%eax
80100586:	50                   	push   %eax
80100587:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
8010058e:	6a 00                	push   $0x0
80100590:	50                   	push   %eax
80100591:	e8 ba 50 00 00       	call   80105650 <memset>
  outb(CRTPORT+1, pos);
80100596:	88 5d e3             	mov    %bl,-0x1d(%ebp)
80100599:	8b 0d 0c ff 10 80    	mov    0x8010ff0c,%ecx
8010059f:	83 c4 10             	add    $0x10,%esp
801005a2:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005a6:	e9 07 ff ff ff       	jmp    801004b2 <cgaputc+0xb2>
    panic("pos under/overflow");
801005ab:	83 ec 0c             	sub    $0xc,%esp
801005ae:	68 05 83 10 80       	push   $0x80108305
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
801005db:	e8 b0 4f 00 00       	call   80105590 <acquire>
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
8010060a:	e8 d1 67 00 00       	call   80106de0 <uartputc>
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
80100626:	e8 05 4f 00 00       	call   80105530 <release>
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
80100676:	0f b6 92 30 83 10 80 	movzbl -0x7fef7cd0(%edx),%edx
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
801006b7:	e8 24 67 00 00       	call   80106de0 <uartputc>
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
801007a5:	bf 18 83 10 80       	mov    $0x80108318,%edi
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
8010081a:	e8 c1 65 00 00       	call   80106de0 <uartputc>
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
80100848:	e8 43 4d 00 00       	call   80105590 <acquire>
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
80100867:	e8 74 65 00 00       	call   80106de0 <uartputc>
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
801008a8:	e8 33 65 00 00       	call   80106de0 <uartputc>
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
801008f3:	e8 e8 64 00 00       	call   80106de0 <uartputc>
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
8010091f:	e8 bc 64 00 00       	call   80106de0 <uartputc>
  cgaputc(c);
80100924:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100927:	e8 d4 fa ff ff       	call   80100400 <cgaputc>
}
8010092c:	83 c4 10             	add    $0x10,%esp
8010092f:	e9 37 fe ff ff       	jmp    8010076b <cprintf+0x7b>
    release(&cons.lock);
80100934:	83 ec 0c             	sub    $0xc,%esp
80100937:	68 20 ff 10 80       	push   $0x8010ff20
8010093c:	e8 ef 4b 00 00       	call   80105530 <release>
80100941:	83 c4 10             	add    $0x10,%esp
}
80100944:	e9 38 fe ff ff       	jmp    80100781 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100949:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010094c:	e9 1a fe ff ff       	jmp    8010076b <cprintf+0x7b>
    panic("null fmt");
80100951:	83 ec 0c             	sub    $0xc,%esp
80100954:	68 1f 83 10 80       	push   $0x8010831f
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
80100a65:	e8 76 63 00 00       	call   80106de0 <uartputc>
80100a6a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a71:	e8 6a 63 00 00       	call   80106de0 <uartputc>
80100a76:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a7d:	e8 5e 63 00 00       	call   80106de0 <uartputc>
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
80100add:	e8 fe 62 00 00       	call   80106de0 <uartputc>
80100ae2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae9:	e8 f2 62 00 00       	call   80106de0 <uartputc>
80100aee:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100af5:	e8 e6 62 00 00       	call   80106de0 <uartputc>
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
80100c43:	e8 48 49 00 00       	call   80105590 <acquire>
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
80100d18:	e8 13 48 00 00       	call   80105530 <release>
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
80100d3f:	e8 9c 60 00 00       	call   80106de0 <uartputc>
80100d44:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100d4b:	e8 90 60 00 00       	call   80106de0 <uartputc>
80100d50:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100d57:	e8 84 60 00 00       	call   80106de0 <uartputc>
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
80100dda:	e8 01 60 00 00       	call   80106de0 <uartputc>
80100ddf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100de6:	e8 f5 5f 00 00       	call   80106de0 <uartputc>
80100deb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100df2:	e8 e9 5f 00 00       	call   80106de0 <uartputc>
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
80100e57:	e8 84 5f 00 00       	call   80106de0 <uartputc>
80100e5c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100e63:	e8 78 5f 00 00       	call   80106de0 <uartputc>
80100e68:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100e6f:	e8 6c 5f 00 00       	call   80106de0 <uartputc>
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
80100e9c:	c6 82 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%edx)
  if(panicked){
80100ea3:	85 c9                	test   %ecx,%ecx
80100ea5:	75 df                	jne    80100e86 <consoleintr+0x256>
    uartputc(c);
80100ea7:	83 ec 0c             	sub    $0xc,%esp
80100eaa:	6a 0a                	push   $0xa
80100eac:	e8 2f 5f 00 00       	call   80106de0 <uartputc>
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
80100ecf:	e8 0c 5f 00 00       	call   80106de0 <uartputc>
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
80100f06:	68 28 83 10 80       	push   $0x80108328
80100f0b:	68 20 ff 10 80       	push   $0x8010ff20
80100f10:	e8 ab 44 00 00       	call   801053c0 <initlock>

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
80100fd4:	e8 97 6f 00 00       	call   80107f70 <setupkvm>
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
80101043:	e8 48 6d 00 00       	call   80107d90 <allocuvm>
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
80101079:	e8 22 6c 00 00       	call   80107ca0 <loaduvm>
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
801010bb:	e8 30 6e 00 00       	call   80107ef0 <freevm>
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
80101102:	e8 89 6c 00 00       	call   80107d90 <allocuvm>
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
80101123:	e8 e8 6e 00 00       	call   80108010 <clearpteu>
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
80101173:	e8 d8 46 00 00       	call   80105850 <strlen>
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
80101187:	e8 c4 46 00 00       	call   80105850 <strlen>
8010118c:	83 c0 01             	add    $0x1,%eax
8010118f:	50                   	push   %eax
80101190:	8b 45 0c             	mov    0xc(%ebp),%eax
80101193:	ff 34 b8             	push   (%eax,%edi,4)
80101196:	53                   	push   %ebx
80101197:	56                   	push   %esi
80101198:	e8 43 70 00 00       	call   801081e0 <copyout>
8010119d:	83 c4 20             	add    $0x20,%esp
801011a0:	85 c0                	test   %eax,%eax
801011a2:	79 ac                	jns    80101150 <exec+0x200>
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
801011a8:	83 ec 0c             	sub    $0xc,%esp
801011ab:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
801011b1:	e8 3a 6d 00 00       	call   80107ef0 <freevm>
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
80101203:	e8 d8 6f 00 00       	call   801081e0 <copyout>
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
80101241:	e8 ca 45 00 00       	call   80105810 <safestrcpy>
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
8010126d:	e8 9e 68 00 00       	call   80107b10 <switchuvm>
  freevm(oldpgdir);
80101272:	89 3c 24             	mov    %edi,(%esp)
80101275:	e8 76 6c 00 00       	call   80107ef0 <freevm>
  return 0;
8010127a:	83 c4 10             	add    $0x10,%esp
8010127d:	31 c0                	xor    %eax,%eax
8010127f:	e9 38 fd ff ff       	jmp    80100fbc <exec+0x6c>
    end_op();
80101284:	e8 e7 1f 00 00       	call   80103270 <end_op>
    cprintf("exec: fail\n");
80101289:	83 ec 0c             	sub    $0xc,%esp
8010128c:	68 41 83 10 80       	push   $0x80108341
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
801012b6:	68 4d 83 10 80       	push   $0x8010834d
801012bb:	68 60 ff 10 80       	push   $0x8010ff60
801012c0:	e8 fb 40 00 00       	call   801053c0 <initlock>
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
801012e1:	e8 aa 42 00 00       	call   80105590 <acquire>
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
80101311:	e8 1a 42 00 00       	call   80105530 <release>
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
8010132a:	e8 01 42 00 00       	call   80105530 <release>
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
8010134f:	e8 3c 42 00 00       	call   80105590 <acquire>
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
8010136c:	e8 bf 41 00 00       	call   80105530 <release>
  return f;
}
80101371:	89 d8                	mov    %ebx,%eax
80101373:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101376:	c9                   	leave  
80101377:	c3                   	ret    
    panic("filedup");
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	68 54 83 10 80       	push   $0x80108354
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
801013a1:	e8 ea 41 00 00       	call   80105590 <acquire>
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
801013dc:	e8 4f 41 00 00       	call   80105530 <release>

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
8010140e:	e9 1d 41 00 00       	jmp    80105530 <release>
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
8010145c:	68 5c 83 10 80       	push   $0x8010835c
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
80101542:	68 66 83 10 80       	push   $0x80108366
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
80101617:	68 6f 83 10 80       	push   $0x8010836f
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
80101651:	68 75 83 10 80       	push   $0x80108375
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
801016c7:	68 7f 83 10 80       	push   $0x8010837f
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
80101784:	68 92 83 10 80       	push   $0x80108392
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
801017c5:	e8 86 3e 00 00       	call   80105650 <memset>
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
8010180a:	e8 81 3d 00 00       	call   80105590 <acquire>
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
80101877:	e8 b4 3c 00 00       	call   80105530 <release>

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
801018a5:	e8 86 3c 00 00       	call   80105530 <release>
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
801018d8:	68 a8 83 10 80       	push   $0x801083a8
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
801019b5:	68 b8 83 10 80       	push   $0x801083b8
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
801019e1:	e8 0a 3d 00 00       	call   801056f0 <memmove>
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
80101a0c:	68 cb 83 10 80       	push   $0x801083cb
80101a11:	68 60 09 11 80       	push   $0x80110960
80101a16:	e8 a5 39 00 00       	call   801053c0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a1b:	83 c4 10             	add    $0x10,%esp
80101a1e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101a20:	83 ec 08             	sub    $0x8,%esp
80101a23:	68 d2 83 10 80       	push   $0x801083d2
80101a28:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101a29:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
80101a2f:	e8 5c 38 00 00       	call   80105290 <initsleeplock>
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
80101a5c:	e8 8f 3c 00 00       	call   801056f0 <memmove>
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
80101a93:	68 38 84 10 80       	push   $0x80108438
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
80101b2e:	e8 1d 3b 00 00       	call   80105650 <memset>
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
80101b63:	68 d8 83 10 80       	push   $0x801083d8
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
80101bd1:	e8 1a 3b 00 00       	call   801056f0 <memmove>
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
80101bff:	e8 8c 39 00 00       	call   80105590 <acquire>
  ip->ref++;
80101c04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c08:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101c0f:	e8 1c 39 00 00       	call   80105530 <release>
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
80101c42:	e8 89 36 00 00       	call   801052d0 <acquiresleep>
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
80101cb8:	e8 33 3a 00 00       	call   801056f0 <memmove>
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
80101cdd:	68 f0 83 10 80       	push   $0x801083f0
80101ce2:	e8 99 e6 ff ff       	call   80100380 <panic>
    panic("ilock");
80101ce7:	83 ec 0c             	sub    $0xc,%esp
80101cea:	68 ea 83 10 80       	push   $0x801083ea
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
80101d13:	e8 58 36 00 00       	call   80105370 <holdingsleep>
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
80101d2f:	e9 fc 35 00 00       	jmp    80105330 <releasesleep>
    panic("iunlock");
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 ff 83 10 80       	push   $0x801083ff
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
80101d60:	e8 6b 35 00 00       	call   801052d0 <acquiresleep>
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
80101d7a:	e8 b1 35 00 00       	call   80105330 <releasesleep>
  acquire(&icache.lock);
80101d7f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101d86:	e8 05 38 00 00       	call   80105590 <acquire>
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
80101da0:	e9 8b 37 00 00       	jmp    80105530 <release>
80101da5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	68 60 09 11 80       	push   $0x80110960
80101db0:	e8 db 37 00 00       	call   80105590 <acquire>
    int r = ip->ref;
80101db5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101db8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101dbf:	e8 6c 37 00 00       	call   80105530 <release>
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
80101ec3:	e8 a8 34 00 00       	call   80105370 <holdingsleep>
80101ec8:	83 c4 10             	add    $0x10,%esp
80101ecb:	85 c0                	test   %eax,%eax
80101ecd:	74 21                	je     80101ef0 <iunlockput+0x40>
80101ecf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ed2:	85 c0                	test   %eax,%eax
80101ed4:	7e 1a                	jle    80101ef0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ed6:	83 ec 0c             	sub    $0xc,%esp
80101ed9:	56                   	push   %esi
80101eda:	e8 51 34 00 00       	call   80105330 <releasesleep>
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
80101ef3:	68 ff 83 10 80       	push   $0x801083ff
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
80101fd7:	e8 14 37 00 00       	call   801056f0 <memmove>
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
801020d3:	e8 18 36 00 00       	call   801056f0 <memmove>
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
8010216e:	e8 ed 35 00 00       	call   80105760 <strncmp>
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
801021cd:	e8 8e 35 00 00       	call   80105760 <strncmp>
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
80102212:	68 19 84 10 80       	push   $0x80108419
80102217:	e8 64 e1 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
8010221c:	83 ec 0c             	sub    $0xc,%esp
8010221f:	68 07 84 10 80       	push   $0x80108407
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
80102255:	68 60 09 11 80       	push   $0x80110960
8010225a:	e8 31 33 00 00       	call   80105590 <acquire>
  ip->ref++;
8010225f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102263:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010226a:	e8 c1 32 00 00       	call   80105530 <release>
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
801022c7:	e8 24 34 00 00       	call   801056f0 <memmove>
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
8010232c:	e8 3f 30 00 00       	call   80105370 <holdingsleep>
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
8010234e:	e8 dd 2f 00 00       	call   80105330 <releasesleep>
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
8010237b:	e8 70 33 00 00       	call   801056f0 <memmove>
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
801023cb:	e8 a0 2f 00 00       	call   80105370 <holdingsleep>
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	85 c0                	test   %eax,%eax
801023d5:	0f 84 91 00 00 00    	je     8010246c <namex+0x23c>
801023db:	8b 46 08             	mov    0x8(%esi),%eax
801023de:	85 c0                	test   %eax,%eax
801023e0:	0f 8e 86 00 00 00    	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
801023e6:	83 ec 0c             	sub    $0xc,%esp
801023e9:	53                   	push   %ebx
801023ea:	e8 41 2f 00 00       	call   80105330 <releasesleep>
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
8010240d:	e8 5e 2f 00 00       	call   80105370 <holdingsleep>
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
80102430:	e8 3b 2f 00 00       	call   80105370 <holdingsleep>
80102435:	83 c4 10             	add    $0x10,%esp
80102438:	85 c0                	test   %eax,%eax
8010243a:	74 30                	je     8010246c <namex+0x23c>
8010243c:	8b 7e 08             	mov    0x8(%esi),%edi
8010243f:	85 ff                	test   %edi,%edi
80102441:	7e 29                	jle    8010246c <namex+0x23c>
  releasesleep(&ip->lock);
80102443:	83 ec 0c             	sub    $0xc,%esp
80102446:	53                   	push   %ebx
80102447:	e8 e4 2e 00 00       	call   80105330 <releasesleep>
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
8010246f:	68 ff 83 10 80       	push   $0x801083ff
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
801024dd:	e8 ce 32 00 00       	call   801057b0 <strncpy>
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
8010251b:	68 28 84 10 80       	push   $0x80108428
80102520:	e8 5b de ff ff       	call   80100380 <panic>
    panic("dirlink");
80102525:	83 ec 0c             	sub    $0xc,%esp
80102528:	68 3a 8b 10 80       	push   $0x80108b3a
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
8010263b:	68 94 84 10 80       	push   $0x80108494
80102640:	e8 3b dd ff ff       	call   80100380 <panic>
    panic("idestart");
80102645:	83 ec 0c             	sub    $0xc,%esp
80102648:	68 8b 84 10 80       	push   $0x8010848b
8010264d:	e8 2e dd ff ff       	call   80100380 <panic>
80102652:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102660 <ideinit>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102666:	68 a6 84 10 80       	push   $0x801084a6
8010266b:	68 00 26 11 80       	push   $0x80112600
80102670:	e8 4b 2d 00 00       	call   801053c0 <initlock>
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
801026ee:	e8 9d 2e 00 00       	call   80105590 <acquire>

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
8010274d:	e8 be 21 00 00       	call   80104910 <wakeup>

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
8010276b:	e8 c0 2d 00 00       	call   80105530 <release>

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
8010278e:	e8 dd 2b 00 00       	call   80105370 <holdingsleep>
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
801027c8:	e8 c3 2d 00 00       	call   80105590 <acquire>

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
80102809:	e8 42 20 00 00       	call   80104850 <sleep>
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
80102826:	e9 05 2d 00 00       	jmp    80105530 <release>
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
8010284a:	68 d5 84 10 80       	push   $0x801084d5
8010284f:	e8 2c db ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102854:	83 ec 0c             	sub    $0xc,%esp
80102857:	68 c0 84 10 80       	push   $0x801084c0
8010285c:	e8 1f db ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102861:	83 ec 0c             	sub    $0xc,%esp
80102864:	68 aa 84 10 80       	push   $0x801084aa
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
801028ba:	68 f4 84 10 80       	push   $0x801084f4
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
80102972:	81 fb 50 68 11 80    	cmp    $0x80116850,%ebx
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
80102992:	e8 b9 2c 00 00       	call   80105650 <memset>

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
801029c8:	e8 c3 2b 00 00       	call   80105590 <acquire>
801029cd:	83 c4 10             	add    $0x10,%esp
801029d0:	eb d2                	jmp    801029a4 <kfree+0x44>
801029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029d8:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801029df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e2:	c9                   	leave  
    release(&kmem.lock);
801029e3:	e9 48 2b 00 00       	jmp    80105530 <release>
    panic("kfree");
801029e8:	83 ec 0c             	sub    $0xc,%esp
801029eb:	68 26 85 10 80       	push   $0x80108526
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
80102abb:	68 2c 85 10 80       	push   $0x8010852c
80102ac0:	68 40 26 11 80       	push   $0x80112640
80102ac5:	e8 f6 28 00 00       	call   801053c0 <initlock>
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
80102b53:	e8 38 2a 00 00       	call   80105590 <acquire>
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
80102b81:	e8 aa 29 00 00       	call   80105530 <release>
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
80102bcb:	0f b6 91 60 86 10 80 	movzbl -0x7fef79a0(%ecx),%edx
  shift ^= togglecode[data];
80102bd2:	0f b6 81 60 85 10 80 	movzbl -0x7fef7aa0(%ecx),%eax
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
80102beb:	8b 04 85 40 85 10 80 	mov    -0x7fef7ac0(,%eax,4),%eax
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
80102c28:	0f b6 81 60 86 10 80 	movzbl -0x7fef79a0(%ecx),%eax
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
80102f97:	e8 04 27 00 00       	call   801056a0 <memcmp>
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
801030c4:	e8 27 26 00 00       	call   801056f0 <memmove>
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
8010316a:	68 60 87 10 80       	push   $0x80108760
8010316f:	68 a0 26 11 80       	push   $0x801126a0
80103174:	e8 47 22 00 00       	call   801053c0 <initlock>
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
8010320b:	e8 80 23 00 00       	call   80105590 <acquire>
80103210:	83 c4 10             	add    $0x10,%esp
80103213:	eb 18                	jmp    8010322d <begin_op+0x2d>
80103215:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103218:	83 ec 08             	sub    $0x8,%esp
8010321b:	68 a0 26 11 80       	push   $0x801126a0
80103220:	68 a0 26 11 80       	push   $0x801126a0
80103225:	e8 26 16 00 00       	call   80104850 <sleep>
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
8010325c:	e8 cf 22 00 00       	call   80105530 <release>
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
8010327e:	e8 0d 23 00 00       	call   80105590 <acquire>
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
801032bc:	e8 6f 22 00 00       	call   80105530 <release>
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
801032d6:	e8 b5 22 00 00       	call   80105590 <acquire>
    wakeup(&log);
801032db:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
801032e2:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
801032e9:	00 00 00 
    wakeup(&log);
801032ec:	e8 1f 16 00 00       	call   80104910 <wakeup>
    release(&log.lock);
801032f1:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801032f8:	e8 33 22 00 00       	call   80105530 <release>
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
80103354:	e8 97 23 00 00       	call   801056f0 <memmove>
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
801033a8:	e8 63 15 00 00       	call   80104910 <wakeup>
  release(&log.lock);
801033ad:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
801033b4:	e8 77 21 00 00       	call   80105530 <release>
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
801033c7:	68 64 87 10 80       	push   $0x80108764
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
80103416:	e8 75 21 00 00       	call   80105590 <acquire>
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
80103455:	e9 d6 20 00 00       	jmp    80105530 <release>
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
80103481:	68 73 87 10 80       	push   $0x80108773
80103486:	e8 f5 ce ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010348b:	83 ec 0c             	sub    $0xc,%esp
8010348e:	68 89 87 10 80       	push   $0x80108789
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
801034b8:	68 a4 87 10 80       	push   $0x801087a4
801034bd:	e8 2e d2 ff ff       	call   801006f0 <cprintf>
  idtinit();       // load idt register
801034c2:	e8 49 35 00 00       	call   80106a10 <idtinit>
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
801034e6:	e8 15 46 00 00       	call   80107b00 <switchkvm>
  seginit();
801034eb:	e8 80 45 00 00       	call   80107a70 <seginit>
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
80103517:	68 50 68 11 80       	push   $0x80116850
8010351c:	e8 8f f5 ff ff       	call   80102ab0 <kinit1>
  kvmalloc();      // kernel page table
80103521:	e8 ca 4a 00 00       	call   80107ff0 <kvmalloc>
  mpinit();        // detect other processors
80103526:	e8 85 01 00 00       	call   801036b0 <mpinit>
  lapicinit();     // interrupt controller
8010352b:	e8 60 f7 ff ff       	call   80102c90 <lapicinit>
  seginit();       // segment descriptors
80103530:	e8 3b 45 00 00       	call   80107a70 <seginit>
  picinit();       // disable pic
80103535:	e8 76 03 00 00       	call   801038b0 <picinit>
  ioapicinit();    // another interrupt controller
8010353a:	e8 31 f3 ff ff       	call   80102870 <ioapicinit>
  consoleinit();   // console hardware
8010353f:	e8 bc d9 ff ff       	call   80100f00 <consoleinit>
  uartinit();      // serial port
80103544:	e8 b7 37 00 00       	call   80106d00 <uartinit>
  pinit();         // process table
80103549:	e8 02 09 00 00       	call   80103e50 <pinit>
  tvinit();        // trap vectors
8010354e:	e8 3d 34 00 00       	call   80106990 <tvinit>
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
80103574:	e8 77 21 00 00       	call   801056f0 <memmove>

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
8010365e:	68 b8 87 10 80       	push   $0x801087b8
80103663:	56                   	push   %esi
80103664:	e8 37 20 00 00       	call   801056a0 <memcmp>
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
80103716:	68 bd 87 10 80       	push   $0x801087bd
8010371b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010371c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010371f:	e8 7c 1f 00 00       	call   801056a0 <memcmp>
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
80103833:	68 c2 87 10 80       	push   $0x801087c2
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
80103862:	68 b8 87 10 80       	push   $0x801087b8
80103867:	53                   	push   %ebx
80103868:	e8 33 1e 00 00       	call   801056a0 <memcmp>
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
80103898:	68 dc 87 10 80       	push   $0x801087dc
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
80103943:	68 fb 87 10 80       	push   $0x801087fb
80103948:	50                   	push   %eax
80103949:	e8 72 1a 00 00       	call   801053c0 <initlock>
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
801039df:	e8 ac 1b 00 00       	call   80105590 <acquire>
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
80103a24:	e9 07 1b 00 00       	jmp    80105530 <release>
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103a30:	83 ec 0c             	sub    $0xc,%esp
80103a33:	53                   	push   %ebx
80103a34:	e8 f7 1a 00 00       	call   80105530 <release>
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
80103a7d:	e8 0e 1b 00 00       	call   80105590 <acquire>
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
80103b0c:	e8 1f 1a 00 00       	call   80105530 <release>
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
80103b62:	e8 c9 19 00 00       	call   80105530 <release>
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
80103b86:	e8 05 1a 00 00       	call   80105590 <acquire>
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
80103c1e:	e8 0d 19 00 00       	call   80105530 <release>
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
80103c39:	e8 f2 18 00 00       	call   80105530 <release>
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
80103c56:	68 a0 2d 11 80       	push   $0x80112da0
80103c5b:	e8 d0 18 00 00       	call   80105530 <release>

  if (first) {
80103c60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
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
80103c70:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
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
80103cb4:	68 00 50 11 80       	push   $0x80115000
80103cb9:	e8 d2 18 00 00       	call   80105590 <acquire>
    int random_number, diff = max - min + 1, time = ticks;
80103cbe:	8b 0d e0 4f 11 80    	mov    0x80114fe0,%ecx
    release(&tickslock);
80103cc4:	c7 04 24 00 50 11 80 	movl   $0x80115000,(%esp)
    int random_number, diff = max - min + 1, time = ticks;
80103ccb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    release(&tickslock);
80103cce:	e8 5d 18 00 00       	call   80105530 <release>
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
80103d24:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
{
80103d29:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103d2c:	68 a0 2d 11 80       	push   $0x80112da0
80103d31:	e8 5a 18 00 00       	call   80105590 <acquire>
80103d36:	83 c4 10             	add    $0x10,%esp
80103d39:	eb 17                	jmp    80103d52 <allocproc+0x32>
80103d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d3f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d40:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103d46:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
80103d4c:	0f 84 9e 00 00 00    	je     80103df0 <allocproc+0xd0>
    if(p->state == UNUSED)
80103d52:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d55:	85 c0                	test   %eax,%eax
80103d57:	75 e7                	jne    80103d40 <allocproc+0x20>
  p->pid = nextpid++;
80103d59:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  release(&ptable.lock);
80103d5e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d61:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103d68:	89 43 10             	mov    %eax,0x10(%ebx)
80103d6b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d6e:	68 a0 2d 11 80       	push   $0x80112da0
  p->pid = nextpid++;
80103d73:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103d79:	e8 b2 17 00 00       	call   80105530 <release>
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
80103d9e:	c7 40 14 7d 69 10 80 	movl   $0x8010697d,0x14(%eax)
  p->context = (struct context*)sp;
80103da5:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103da8:	6a 14                	push   $0x14
80103daa:	6a 00                	push   $0x0
80103dac:	50                   	push   %eax
80103dad:	e8 9e 18 00 00       	call   80105650 <memset>
  p->context->eip = (uint)forkret;
80103db2:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103db5:	ba 1e 00 00 00       	mov    $0x1e,%edx
80103dba:	c7 40 10 50 3c 10 80 	movl   $0x80103c50,0x10(%eax)
  p->entered_queue = ticks;
80103dc1:	a1 e0 4f 11 80       	mov    0x80114fe0,%eax
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
80103df5:	68 a0 2d 11 80       	push   $0x80112da0
80103dfa:	e8 31 17 00 00       	call   80105530 <release>
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
80103e56:	68 00 88 10 80       	push   $0x80108800
80103e5b:	68 a0 2d 11 80       	push   $0x80112da0
80103e60:	e8 5b 15 00 00       	call   801053c0 <initlock>
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
80103e81:	8b 35 84 27 11 80    	mov    0x80112784,%esi
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
80103e9d:	0f b6 99 a0 27 11 80 	movzbl -0x7feed860(%ecx),%ebx
80103ea4:	39 c3                	cmp    %eax,%ebx
80103ea6:	75 e8                	jne    80103e90 <mycpu+0x20>
}
80103ea8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103eab:	8d 81 a0 27 11 80    	lea    -0x7feed860(%ecx),%eax
}
80103eb1:	5b                   	pop    %ebx
80103eb2:	5e                   	pop    %esi
80103eb3:	5d                   	pop    %ebp
80103eb4:	c3                   	ret    
  panic("unknown apicid\n");
80103eb5:	83 ec 0c             	sub    $0xc,%esp
80103eb8:	68 07 88 10 80       	push   $0x80108807
80103ebd:	e8 be c4 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ec2:	83 ec 0c             	sub    $0xc,%esp
80103ec5:	68 30 89 10 80       	push   $0x80108930
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
80103edc:	2d a0 27 11 80       	sub    $0x801127a0,%eax
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
80103ef7:	e8 44 15 00 00       	call   80105440 <pushcli>
  c = mycpu();
80103efc:	e8 6f ff ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80103f01:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f07:	e8 84 15 00 00       	call   80105490 <popcli>
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
80103f2e:	a3 d4 4f 11 80       	mov    %eax,0x80114fd4
  if((p->pgdir = setupkvm()) == 0)
80103f33:	e8 38 40 00 00       	call   80107f70 <setupkvm>
80103f38:	89 43 04             	mov    %eax,0x4(%ebx)
80103f3b:	85 c0                	test   %eax,%eax
80103f3d:	0f 84 bd 00 00 00    	je     80104000 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f43:	83 ec 04             	sub    $0x4,%esp
80103f46:	68 2c 00 00 00       	push   $0x2c
80103f4b:	68 60 b4 10 80       	push   $0x8010b460
80103f50:	50                   	push   %eax
80103f51:	e8 ca 3c 00 00       	call   80107c20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f56:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f59:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f5f:	6a 4c                	push   $0x4c
80103f61:	6a 00                	push   $0x0
80103f63:	ff 73 18             	push   0x18(%ebx)
80103f66:	e8 e5 16 00 00       	call   80105650 <memset>
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
80103fbf:	68 30 88 10 80       	push   $0x80108830
80103fc4:	50                   	push   %eax
80103fc5:	e8 46 18 00 00       	call   80105810 <safestrcpy>
  p->cwd = namei("/");
80103fca:	c7 04 24 39 88 10 80 	movl   $0x80108839,(%esp)
80103fd1:	e8 6a e5 ff ff       	call   80102540 <namei>
80103fd6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fd9:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103fe0:	e8 ab 15 00 00       	call   80105590 <acquire>
  p->state = RUNNABLE;
80103fe5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fec:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80103ff3:	e8 38 15 00 00       	call   80105530 <release>
}
80103ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ffb:	83 c4 10             	add    $0x10,%esp
80103ffe:	c9                   	leave  
80103fff:	c3                   	ret    
    panic("userinit: out of memory?");
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	68 17 88 10 80       	push   $0x80108817
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
80104018:	e8 23 14 00 00       	call   80105440 <pushcli>
  c = mycpu();
8010401d:	e8 4e fe ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104022:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104028:	e8 63 14 00 00       	call   80105490 <popcli>
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
8010403b:	e8 d0 3a 00 00       	call   80107b10 <switchuvm>
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
8010405a:	e8 31 3d 00 00       	call   80107d90 <allocuvm>
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
8010407a:	e8 41 3e 00 00       	call   80107ec0 <deallocuvm>
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
80104099:	e8 a2 13 00 00       	call   80105440 <pushcli>
  c = mycpu();
8010409e:	e8 cd fd ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801040a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040a9:	e8 e2 13 00 00       	call   80105490 <popcli>
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
801040c8:	e8 93 3f 00 00       	call   80108060 <copyuvm>
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
80104141:	e8 ca 16 00 00       	call   80105810 <safestrcpy>
  pid = np->pid;
80104146:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104149:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104150:	e8 3b 14 00 00       	call   80105590 <acquire>
  np->state = RUNNABLE;
80104155:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010415c:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104163:	e8 c8 13 00 00       	call   80105530 <release>
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
801041b0:	8b 0d e0 4f 11 80    	mov    0x80114fe0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b6:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
801041bb:	eb 0f                	jmp    801041cc <fix_queues+0x1c>
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
801041c0:	05 88 00 00 00       	add    $0x88,%eax
801041c5:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
801041f1:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104203:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
{ 
80104208:	89 e5                	mov    %esp,%ebp
8010420a:	56                   	push   %esi
    struct proc *min_p = 0;
8010420b:	31 f6                	xor    %esi,%esi
{ 
8010420d:	53                   	push   %ebx
    int time = ticks;
8010420e:	8b 1d e0 4f 11 80    	mov    0x80114fe0,%ebx
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
8010423d:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104252:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
80104277:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
8010427c:	75 e2                	jne    80104260 <lottery+0x10>
    if (min >= max)
8010427e:	83 fa 01             	cmp    $0x1,%edx
80104281:	7f 33                	jg     801042b6 <lottery+0x66>
        return max > 0 ? max : -1 * max;
80104283:	89 d0                	mov    %edx,%eax
80104285:	f7 d8                	neg    %eax
80104287:	0f 49 d0             	cmovns %eax,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428a:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
801042ab:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
801042c8:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
801042eb:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104306:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
80104335:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
8010437c:	68 a0 2d 11 80       	push   $0x80112da0
80104381:	e8 0a 12 00 00       	call   80105590 <acquire>
      if(ticks - p->entered_queue >= STARVING_THRESHOLD){
80104386:	8b 15 e0 4f 11 80    	mov    0x80114fe0,%edx
        p->entered_queue = ticks;
8010438c:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010438f:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
        p->entered_queue = ticks;
80104394:	89 d7                	mov    %edx,%edi
80104396:	eb 14                	jmp    801043ac <scheduler+0x5c>
80104398:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a0:	05 88 00 00 00       	add    $0x88,%eax
801043a5:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
801043d1:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
801043d6:	75 d4                	jne    801043ac <scheduler+0x5c>
801043d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop
    struct proc *min_p = 0;
801043e0:	31 f6                	xor    %esi,%esi
    int starvation_time = 0;
801043e2:	31 db                	xor    %ebx,%ebx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801043e4:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
80104415:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104433:	e8 d8 36 00 00       	call   80107b10 <switchuvm>
    p->state = RUNNING;
80104438:	c7 46 0c 04 00 00 00 	movl   $0x4,0xc(%esi)
    swtch(&(c->scheduler), p->context);
8010443f:	58                   	pop    %eax
80104440:	5a                   	pop    %edx
80104441:	ff 76 1c             	push   0x1c(%esi)
80104444:	ff 75 e0             	push   -0x20(%ebp)
80104447:	e8 1f 14 00 00       	call   8010586b <swtch>
    switchkvm();
8010444c:	e8 af 36 00 00       	call   80107b00 <switchkvm>
    c->proc = 0;
80104451:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80104458:	00 00 00 
    release(&ptable.lock);
8010445b:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104462:	e8 c9 10 00 00       	call   80105530 <release>
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
8010447f:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
801044ad:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
801044b2:	75 d4                	jne    80104488 <scheduler+0x138>
    if(p == 0){
801044b4:	85 f6                	test   %esi,%esi
801044b6:	75 15                	jne    801044cd <scheduler+0x17d>
      release(&ptable.lock);
801044b8:	83 ec 0c             	sub    $0xc,%esp
801044bb:	68 a0 2d 11 80       	push   $0x80112da0
801044c0:	e8 6b 10 00 00       	call   80105530 <release>
      continue;
801044c5:	83 c4 10             	add    $0x10,%esp
801044c8:	e9 ab fe ff ff       	jmp    80104378 <scheduler+0x28>
    p->entered_queue = ticks;
801044cd:	8b 3d e0 4f 11 80    	mov    0x80114fe0,%edi
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
801044e5:	e8 56 0f 00 00       	call   80105440 <pushcli>
  c = mycpu();
801044ea:	e8 81 f9 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801044ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f5:	e8 96 0f 00 00       	call   80105490 <popcli>
  if(!holding(&ptable.lock))
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	68 a0 2d 11 80       	push   $0x80112da0
80104502:	e8 e9 0f 00 00       	call   801054f0 <holding>
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
80104543:	e8 23 13 00 00       	call   8010586b <swtch>
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
80104560:	68 3b 88 10 80       	push   $0x8010883b
80104565:	e8 16 be ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010456a:	83 ec 0c             	sub    $0xc,%esp
8010456d:	68 67 88 10 80       	push   $0x80108867
80104572:	e8 09 be ff ff       	call   80100380 <panic>
    panic("sched running");
80104577:	83 ec 0c             	sub    $0xc,%esp
8010457a:	68 59 88 10 80       	push   $0x80108859
8010457f:	e8 fc bd ff ff       	call   80100380 <panic>
    panic("sched locks");
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	68 4d 88 10 80       	push   $0x8010884d
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
801045ae:	39 05 d4 4f 11 80    	cmp    %eax,0x80114fd4
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
80104603:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
8010460a:	e8 81 0f 00 00       	call   80105590 <acquire>
  wakeup1(curproc->parent);
8010460f:	8b 53 14             	mov    0x14(%ebx),%edx
80104612:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104615:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010461a:	eb 10                	jmp    8010462c <exit+0x8c>
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104620:	05 88 00 00 00       	add    $0x88,%eax
80104625:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104643:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80104648:	75 e2                	jne    8010462c <exit+0x8c>
      p->parent = initproc;
8010464a:	8b 0d d4 4f 11 80    	mov    0x80114fd4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104650:	ba d4 2d 11 80       	mov    $0x80112dd4,%edx
80104655:	eb 17                	jmp    8010466e <exit+0xce>
80104657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010465e:	66 90                	xchg   %ax,%ax
80104660:	81 c2 88 00 00 00    	add    $0x88,%edx
80104666:	81 fa d4 4f 11 80    	cmp    $0x80114fd4,%edx
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
8010467c:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
80104681:	eb 11                	jmp    80104694 <exit+0xf4>
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	05 88 00 00 00       	add    $0x88,%eax
8010468d:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
801046b7:	68 88 88 10 80       	push   $0x80108888
801046bc:	e8 bf bc ff ff       	call   80100380 <panic>
    panic("init exiting");
801046c1:	83 ec 0c             	sub    $0xc,%esp
801046c4:	68 7b 88 10 80       	push   $0x8010887b
801046c9:	e8 b2 bc ff ff       	call   80100380 <panic>
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <wait>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
  pushcli();
801046d5:	e8 66 0d 00 00       	call   80105440 <pushcli>
  c = mycpu();
801046da:	e8 91 f7 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
801046df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046e5:	e8 a6 0d 00 00       	call   80105490 <popcli>
  acquire(&ptable.lock);
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	68 a0 2d 11 80       	push   $0x80112da0
801046f2:	e8 99 0e 00 00       	call   80105590 <acquire>
801046f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801046fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046fc:	bb d4 2d 11 80       	mov    $0x80112dd4,%ebx
80104701:	eb 13                	jmp    80104716 <wait+0x46>
80104703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104707:	90                   	nop
80104708:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010470e:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
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
8010472c:	81 fb d4 4f 11 80    	cmp    $0x80114fd4,%ebx
80104732:	75 e2                	jne    80104716 <wait+0x46>
    if(!havekids || curproc->killed){
80104734:	85 c0                	test   %eax,%eax
80104736:	0f 84 9a 00 00 00    	je     801047d6 <wait+0x106>
8010473c:	8b 46 24             	mov    0x24(%esi),%eax
8010473f:	85 c0                	test   %eax,%eax
80104741:	0f 85 8f 00 00 00    	jne    801047d6 <wait+0x106>
  pushcli();
80104747:	e8 f4 0c 00 00       	call   80105440 <pushcli>
  c = mycpu();
8010474c:	e8 1f f7 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104751:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104757:	e8 34 0d 00 00       	call   80105490 <popcli>
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
80104799:	e8 52 37 00 00       	call   80107ef0 <freevm>
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
801047be:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801047c5:	e8 66 0d 00 00       	call   80105530 <release>
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
801047de:	68 a0 2d 11 80       	push   $0x80112da0
801047e3:	e8 48 0d 00 00       	call   80105530 <release>
      return -1;
801047e8:	83 c4 10             	add    $0x10,%esp
801047eb:	eb e0                	jmp    801047cd <wait+0xfd>
    panic("sleep");
801047ed:	83 ec 0c             	sub    $0xc,%esp
801047f0:	68 94 88 10 80       	push   $0x80108894
801047f5:	e8 86 bb ff ff       	call   80100380 <panic>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <yield>:
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104807:	68 a0 2d 11 80       	push   $0x80112da0
8010480c:	e8 7f 0d 00 00       	call   80105590 <acquire>
  pushcli();
80104811:	e8 2a 0c 00 00       	call   80105440 <pushcli>
  c = mycpu();
80104816:	e8 55 f6 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
8010481b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104821:	e8 6a 0c 00 00       	call   80105490 <popcli>
  myproc()->state = RUNNABLE;
80104826:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010482d:	e8 ae fc ff ff       	call   801044e0 <sched>
  release(&ptable.lock);
80104832:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104839:	e8 f2 0c 00 00       	call   80105530 <release>
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
8010485f:	e8 dc 0b 00 00       	call   80105440 <pushcli>
  c = mycpu();
80104864:	e8 07 f6 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104869:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010486f:	e8 1c 0c 00 00       	call   80105490 <popcli>
  if(p == 0)
80104874:	85 db                	test   %ebx,%ebx
80104876:	0f 84 87 00 00 00    	je     80104903 <sleep+0xb3>
  if(lk == 0)
8010487c:	85 f6                	test   %esi,%esi
8010487e:	74 76                	je     801048f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104880:	81 fe a0 2d 11 80    	cmp    $0x80112da0,%esi
80104886:	74 50                	je     801048d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	68 a0 2d 11 80       	push   $0x80112da0
80104890:	e8 fb 0c 00 00       	call   80105590 <acquire>
    release(lk);
80104895:	89 34 24             	mov    %esi,(%esp)
80104898:	e8 93 0c 00 00       	call   80105530 <release>
  p->chan = chan;
8010489d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048a7:	e8 34 fc ff ff       	call   801044e0 <sched>
  p->chan = 0;
801048ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801048b3:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
801048ba:	e8 71 0c 00 00       	call   80105530 <release>
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
801048cc:	e9 bf 0c 00 00       	jmp    80105590 <acquire>
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
801048f9:	68 9a 88 10 80       	push   $0x8010889a
801048fe:	e8 7d ba ff ff       	call   80100380 <panic>
    panic("sleep");
80104903:	83 ec 0c             	sub    $0xc,%esp
80104906:	68 94 88 10 80       	push   $0x80108894
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
8010491a:	68 a0 2d 11 80       	push   $0x80112da0
8010491f:	e8 6c 0c 00 00       	call   80105590 <acquire>
80104924:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104927:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010492c:	eb 0e                	jmp    8010493c <wakeup+0x2c>
8010492e:	66 90                	xchg   %ax,%ax
80104930:	05 88 00 00 00       	add    $0x88,%eax
80104935:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104953:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80104958:	75 e2                	jne    8010493c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010495a:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80104961:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104964:	c9                   	leave  
  release(&ptable.lock);
80104965:	e9 c6 0b 00 00       	jmp    80105530 <release>
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
8010497a:	68 a0 2d 11 80       	push   $0x80112da0
8010497f:	e8 0c 0c 00 00       	call   80105590 <acquire>
80104984:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104987:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
8010498c:	eb 0e                	jmp    8010499c <kill+0x2c>
8010498e:	66 90                	xchg   %ax,%ax
80104990:	05 88 00 00 00       	add    $0x88,%eax
80104995:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
801049b8:	68 a0 2d 11 80       	push   $0x80112da0
801049bd:	e8 6e 0b 00 00       	call   80105530 <release>
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
801049d3:	68 a0 2d 11 80       	push   $0x80112da0
801049d8:	e8 53 0b 00 00       	call   80105530 <release>
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
801049f9:	bb 40 2e 11 80       	mov    $0x80112e40,%ebx
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
80104a0b:	68 bb 8e 10 80       	push   $0x80108ebb
80104a10:	e8 db bc ff ff       	call   801006f0 <cprintf>
80104a15:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a18:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104a1e:	81 fb 40 50 11 80    	cmp    $0x80115040,%ebx
80104a24:	0f 84 7e 00 00 00    	je     80104aa8 <procdump+0xb8>
    if(p->state == UNUSED)
80104a2a:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	74 e7                	je     80104a18 <procdump+0x28>
      state = "???";
80104a31:	ba ab 88 10 80       	mov    $0x801088ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a36:	83 f8 05             	cmp    $0x5,%eax
80104a39:	77 11                	ja     80104a4c <procdump+0x5c>
80104a3b:	8b 14 85 24 8a 10 80 	mov    -0x7fef75dc(,%eax,4),%edx
      state = "???";
80104a42:	b8 ab 88 10 80       	mov    $0x801088ab,%eax
80104a47:	85 d2                	test   %edx,%edx
80104a49:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104a4c:	53                   	push   %ebx
80104a4d:	52                   	push   %edx
80104a4e:	ff 73 a4             	push   -0x5c(%ebx)
80104a51:	68 af 88 10 80       	push   $0x801088af
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
80104a78:	e8 63 09 00 00       	call   801053e0 <getcallerpcs>
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
80104a8d:	68 01 83 10 80       	push   $0x80108301
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
80104d37:	83 04 85 1c 2d 11 80 	addl   $0x1,-0x7feed2e4(,%eax,4)
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
80104d50:	8b 14 85 20 2d 11 80 	mov    -0x7feed2e0(,%eax,4),%edx
        most_used_sys_call = i + 1;
80104d57:	83 c0 01             	add    $0x1,%eax
      if(syscalls_count[i] > max_called){
80104d5a:	39 ca                	cmp    %ecx,%edx
80104d5c:	7e 04                	jle    80104d62 <find_most_callee+0x22>
80104d5e:	89 d1                	mov    %edx,%ecx
        most_used_sys_call = i + 1;
80104d60:	89 c3                	mov    %eax,%ebx
    for(int i = 0; i < NUM_OF_SYSCALLS; i++){
80104d62:	83 f8 1e             	cmp    $0x1e,%eax
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
80104d75:	e8 c6 06 00 00       	call   80105440 <pushcli>
  c = mycpu();
80104d7a:	e8 f1 f0 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104d7f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104d85:	e8 06 07 00 00       	call   80105490 <popcli>
    int pid = myproc()->pid;
    struct proc *p;
    int children_count = 0;
    
    acquire(&ptable.lock);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
    int pid = myproc()->pid;
80104d8d:	8b 73 10             	mov    0x10(%ebx),%esi
    acquire(&ptable.lock);
80104d90:	68 a0 2d 11 80       	push   $0x80112da0
    int children_count = 0;
80104d95:	31 db                	xor    %ebx,%ebx
    acquire(&ptable.lock);
80104d97:	e8 f4 07 00 00       	call   80105590 <acquire>
80104d9c:	83 c4 10             	add    $0x10,%esp

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d9f:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
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
80104dbb:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80104dc0:	75 e6                	jne    80104da8 <get_children_count+0x38>
      }
    }

    release(&ptable.lock);
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 a0 2d 11 80       	push   $0x80112da0
80104dca:	e8 61 07 00 00       	call   80105530 <release>

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
80104de7:	e8 54 06 00 00       	call   80105440 <pushcli>
  c = mycpu();
80104dec:	e8 7f f0 ff ff       	call   80103e70 <mycpu>
  p = c->proc;
80104df1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104df7:	e8 94 06 00 00       	call   80105490 <popcli>
  int pid = myproc()->pid;
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104dfc:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
  int pid = myproc()->pid;
80104e01:	8b 4b 10             	mov    0x10(%ebx),%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e04:	eb 16                	jmp    80104e1c <kill_first_child_process+0x3c>
80104e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e0d:	8d 76 00             	lea    0x0(%esi),%esi
80104e10:	05 88 00 00 00       	add    $0x88,%eax
80104e15:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
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
80104e5e:	68 a0 2d 11 80       	push   $0x80112da0
80104e63:	e8 28 07 00 00       	call   80105590 <acquire>
80104e68:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e6b:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
    if(p->pid == pid){
80104e70:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e73:	75 03                	jne    80104e78 <set_proc_queue+0x28>
      p->queue = queue;
80104e75:	89 70 7c             	mov    %esi,0x7c(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e78:	05 88 00 00 00       	add    $0x88,%eax
80104e7d:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80104e82:	75 ec                	jne    80104e70 <set_proc_queue+0x20>
    }
  }
  release(&ptable.lock);
80104e84:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80104e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e8e:	5b                   	pop    %ebx
80104e8f:	5e                   	pop    %esi
80104e90:	5d                   	pop    %ebp
  release(&ptable.lock);
80104e91:	e9 9a 06 00 00       	jmp    80105530 <release>
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
80104eae:	68 a0 2d 11 80       	push   $0x80112da0
80104eb3:	e8 d8 06 00 00       	call   80105590 <acquire>
80104eb8:	83 c4 10             	add    $0x10,%esp

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ebb:	b8 d4 2d 11 80       	mov    $0x80112dd4,%eax
    if(p->pid == pid){
80104ec0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104ec3:	75 06                	jne    80104ecb <set_lottery_params+0x2b>
      p->tickets = ticket_chance;
80104ec5:	89 b0 84 00 00 00    	mov    %esi,0x84(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ecb:	05 88 00 00 00       	add    $0x88,%eax
80104ed0:	3d d4 4f 11 80       	cmp    $0x80114fd4,%eax
80104ed5:	75 e9                	jne    80104ec0 <set_lottery_params+0x20>
    }
  }

  release(&ptable.lock);
80104ed7:	c7 45 08 a0 2d 11 80 	movl   $0x80112da0,0x8(%ebp)
}
80104ede:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee1:	5b                   	pop    %ebx
80104ee2:	5e                   	pop    %esi
80104ee3:	5d                   	pop    %ebp
  release(&ptable.lock);
80104ee4:	e9 47 06 00 00       	jmp    80105530 <release>
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
80104f39:	68 58 89 10 80       	push   $0x80108958
80104f3e:	e8 ad b7 ff ff       	call   801006f0 <cprintf>
  cprintf(".............................................................................................\n");
80104f43:	c7 04 24 b0 89 10 80 	movl   $0x801089b0,(%esp)
80104f4a:	e8 a1 b7 ff ff       	call   801006f0 <cprintf>
  acquire(&ptable.lock);
80104f4f:	c7 04 24 a0 2d 11 80 	movl   $0x80112da0,(%esp)
80104f56:	e8 35 06 00 00       	call   80105590 <acquire>
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f5b:	c7 45 e4 40 2e 11 80 	movl   $0x80112e40,-0x1c(%ebp)
80104f62:	83 c4 10             	add    $0x10,%esp
80104f65:	eb 20                	jmp    80104f87 <print_all_procs+0x57>
80104f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6e:	66 90                	xchg   %ax,%ax
80104f70:	81 45 e4 88 00 00 00 	addl   $0x88,-0x1c(%ebp)
80104f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f7a:	bf 40 50 11 80       	mov    $0x80115040,%edi
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
80104fb6:	68 24 89 10 80       	push   $0x80108924
80104fbb:	e8 30 b7 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 17 - strlen(p->name); i++){ // 15 instead 11
80104fc0:	83 c4 10             	add    $0x10,%esp
80104fc3:	83 ec 0c             	sub    $0xc,%esp
80104fc6:	57                   	push   %edi
80104fc7:	e8 84 08 00 00       	call   80105850 <strlen>
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
80104fe4:	68 d8 88 10 80       	push   $0x801088d8
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
8010503a:	68 24 89 10 80       	push   $0x80108924
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
80105053:	be b8 88 10 80       	mov    $0x801088b8,%esi
    if(p->state == 0){
80105058:	8b 40 a0             	mov    -0x60(%eax),%eax
8010505b:	85 c0                	test   %eax,%eax
8010505d:	74 14                	je     80105073 <print_all_procs+0x143>
    }
    else if(p->state == 1){
8010505f:	83 e8 01             	sub    $0x1,%eax
    if(p->state == 0){
80105062:	be bc 8e 10 80       	mov    $0x80108ebc,%esi
80105067:	83 f8 04             	cmp    $0x4,%eax
8010506a:	77 07                	ja     80105073 <print_all_procs+0x143>
8010506c:	8b 34 85 10 8a 10 80 	mov    -0x7fef75f0(,%eax,4),%esi
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
80105096:	68 24 89 10 80       	push   $0x80108924
8010509b:	e8 50 b6 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 12 - strlen(state); i++){
801050a0:	83 c4 10             	add    $0x10,%esp
801050a3:	83 ec 0c             	sub    $0xc,%esp
801050a6:	56                   	push   %esi
801050a7:	e8 a4 07 00 00       	call   80105850 <strlen>
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
801050bc:	be bf 88 10 80       	mov    $0x801088bf,%esi
    if(p->queue == 1){
801050c1:	8b 40 10             	mov    0x10(%eax),%eax
801050c4:	83 f8 01             	cmp    $0x1,%eax
801050c7:	74 1a                	je     801050e3 <print_all_procs+0x1b3>
    }
    else if(p->queue == 2){
      queue = "LOTTERY";
801050c9:	be cb 88 10 80       	mov    $0x801088cb,%esi
    else if(p->queue == 2){
801050ce:	83 f8 02             	cmp    $0x2,%eax
801050d1:	74 10                	je     801050e3 <print_all_procs+0x1b3>
    }
    else if(p->queue == 3){
      queue = "FCFS";
801050d3:	83 f8 03             	cmp    $0x3,%eax
801050d6:	be bc 8e 10 80       	mov    $0x80108ebc,%esi
801050db:	b8 d3 88 10 80       	mov    $0x801088d3,%eax
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
80105106:	68 24 89 10 80       	push   $0x80108924
8010510b:	e8 e0 b5 ff ff       	call   801006f0 <cprintf>
    for(int i = 0; i < 12 - strlen(queue); i++){
80105110:	83 c4 10             	add    $0x10,%esp
80105113:	83 ec 0c             	sub    $0xc,%esp
80105116:	56                   	push   %esi
80105117:	e8 34 07 00 00       	call   80105850 <strlen>
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
80105134:	68 d8 88 10 80       	push   $0x801088d8
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
8010518a:	68 24 89 10 80       	push   $0x80108924
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
801051ab:	68 d8 88 10 80       	push   $0x801088d8
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
80105202:	68 24 89 10 80       	push   $0x80108924
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
8010521e:	a1 e0 4f 11 80       	mov    0x80114fe0,%eax
80105223:	2b 47 14             	sub    0x14(%edi),%eax
    cprintf("%d", cycle);
80105226:	50                   	push   %eax
80105227:	68 d8 88 10 80       	push   $0x801088d8
8010522c:	e8 bf b4 ff ff       	call   801006f0 <cprintf>

    cprintf("\n");
80105231:	c7 04 24 bb 8e 10 80 	movl   $0x80108ebb,(%esp)
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
8010526d:	68 a0 2d 11 80       	push   $0x80112da0
80105272:	e8 b9 02 00 00       	call   80105530 <release>
80105277:	83 c4 10             	add    $0x10,%esp
8010527a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010527d:	5b                   	pop    %ebx
8010527e:	5e                   	pop    %esi
8010527f:	5f                   	pop    %edi
80105280:	5d                   	pop    %ebp
80105281:	c3                   	ret    
80105282:	66 90                	xchg   %ax,%ax
80105284:	66 90                	xchg   %ax,%ax
80105286:	66 90                	xchg   %ax,%ax
80105288:	66 90                	xchg   %ax,%ax
8010528a:	66 90                	xchg   %ax,%ax
8010528c:	66 90                	xchg   %ax,%ax
8010528e:	66 90                	xchg   %ax,%ax

80105290 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	53                   	push   %ebx
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010529a:	68 3c 8a 10 80       	push   $0x80108a3c
8010529f:	8d 43 04             	lea    0x4(%ebx),%eax
801052a2:	50                   	push   %eax
801052a3:	e8 18 01 00 00       	call   801053c0 <initlock>
  lk->name = name;
801052a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801052ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801052b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801052b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801052bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801052be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c1:	c9                   	leave  
801052c2:	c3                   	ret    
801052c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801052d8:	8d 73 04             	lea    0x4(%ebx),%esi
801052db:	83 ec 0c             	sub    $0xc,%esp
801052de:	56                   	push   %esi
801052df:	e8 ac 02 00 00       	call   80105590 <acquire>
  while (lk->locked) {
801052e4:	8b 13                	mov    (%ebx),%edx
801052e6:	83 c4 10             	add    $0x10,%esp
801052e9:	85 d2                	test   %edx,%edx
801052eb:	74 16                	je     80105303 <acquiresleep+0x33>
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801052f0:	83 ec 08             	sub    $0x8,%esp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	e8 56 f5 ff ff       	call   80104850 <sleep>
  while (lk->locked) {
801052fa:	8b 03                	mov    (%ebx),%eax
801052fc:	83 c4 10             	add    $0x10,%esp
801052ff:	85 c0                	test   %eax,%eax
80105301:	75 ed                	jne    801052f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105303:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105309:	e8 e2 eb ff ff       	call   80103ef0 <myproc>
8010530e:	8b 40 10             	mov    0x10(%eax),%eax
80105311:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105314:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105317:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010531a:	5b                   	pop    %ebx
8010531b:	5e                   	pop    %esi
8010531c:	5d                   	pop    %ebp
  release(&lk->lk);
8010531d:	e9 0e 02 00 00       	jmp    80105530 <release>
80105322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105330 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	56                   	push   %esi
80105334:	53                   	push   %ebx
80105335:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105338:	8d 73 04             	lea    0x4(%ebx),%esi
8010533b:	83 ec 0c             	sub    $0xc,%esp
8010533e:	56                   	push   %esi
8010533f:	e8 4c 02 00 00       	call   80105590 <acquire>
  lk->locked = 0;
80105344:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010534a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105351:	89 1c 24             	mov    %ebx,(%esp)
80105354:	e8 b7 f5 ff ff       	call   80104910 <wakeup>
  release(&lk->lk);
80105359:	89 75 08             	mov    %esi,0x8(%ebp)
8010535c:	83 c4 10             	add    $0x10,%esp
}
8010535f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5d                   	pop    %ebp
  release(&lk->lk);
80105365:	e9 c6 01 00 00       	jmp    80105530 <release>
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105370 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	31 ff                	xor    %edi,%edi
80105376:	56                   	push   %esi
80105377:	53                   	push   %ebx
80105378:	83 ec 18             	sub    $0x18,%esp
8010537b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010537e:	8d 73 04             	lea    0x4(%ebx),%esi
80105381:	56                   	push   %esi
80105382:	e8 09 02 00 00       	call   80105590 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105387:	8b 03                	mov    (%ebx),%eax
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	85 c0                	test   %eax,%eax
8010538e:	75 18                	jne    801053a8 <holdingsleep+0x38>
  release(&lk->lk);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	56                   	push   %esi
80105394:	e8 97 01 00 00       	call   80105530 <release>
  return r;
}
80105399:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010539c:	89 f8                	mov    %edi,%eax
8010539e:	5b                   	pop    %ebx
8010539f:	5e                   	pop    %esi
801053a0:	5f                   	pop    %edi
801053a1:	5d                   	pop    %ebp
801053a2:	c3                   	ret    
801053a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053a7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
801053a8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801053ab:	e8 40 eb ff ff       	call   80103ef0 <myproc>
801053b0:	39 58 10             	cmp    %ebx,0x10(%eax)
801053b3:	0f 94 c0             	sete   %al
801053b6:	0f b6 c0             	movzbl %al,%eax
801053b9:	89 c7                	mov    %eax,%edi
801053bb:	eb d3                	jmp    80105390 <holdingsleep+0x20>
801053bd:	66 90                	xchg   %ax,%ax
801053bf:	90                   	nop

801053c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801053c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801053c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801053cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801053d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053df:	90                   	nop

801053e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801053e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801053e1:	31 d2                	xor    %edx,%edx
{
801053e3:	89 e5                	mov    %esp,%ebp
801053e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801053e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801053e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801053ec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801053ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801053f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801053f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801053fc:	77 1a                	ja     80105418 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801053fe:	8b 58 04             	mov    0x4(%eax),%ebx
80105401:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105404:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105407:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105409:	83 fa 0a             	cmp    $0xa,%edx
8010540c:	75 e2                	jne    801053f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010540e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105411:	c9                   	leave  
80105412:	c3                   	ret    
80105413:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105417:	90                   	nop
  for(; i < 10; i++)
80105418:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010541b:	8d 51 28             	lea    0x28(%ecx),%edx
8010541e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105426:	83 c0 04             	add    $0x4,%eax
80105429:	39 d0                	cmp    %edx,%eax
8010542b:	75 f3                	jne    80105420 <getcallerpcs+0x40>
}
8010542d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105430:	c9                   	leave  
80105431:	c3                   	ret    
80105432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105440 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	53                   	push   %ebx
80105444:	83 ec 04             	sub    $0x4,%esp
80105447:	9c                   	pushf  
80105448:	5b                   	pop    %ebx
  asm volatile("cli");
80105449:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010544a:	e8 21 ea ff ff       	call   80103e70 <mycpu>
8010544f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105455:	85 c0                	test   %eax,%eax
80105457:	74 17                	je     80105470 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105459:	e8 12 ea ff ff       	call   80103e70 <mycpu>
8010545e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105468:	c9                   	leave  
80105469:	c3                   	ret    
8010546a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80105470:	e8 fb e9 ff ff       	call   80103e70 <mycpu>
80105475:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010547b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105481:	eb d6                	jmp    80105459 <pushcli+0x19>
80105483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010548a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105490 <popcli>:

void
popcli(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105496:	9c                   	pushf  
80105497:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105498:	f6 c4 02             	test   $0x2,%ah
8010549b:	75 35                	jne    801054d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010549d:	e8 ce e9 ff ff       	call   80103e70 <mycpu>
801054a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801054a9:	78 34                	js     801054df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801054ab:	e8 c0 e9 ff ff       	call   80103e70 <mycpu>
801054b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801054b6:	85 d2                	test   %edx,%edx
801054b8:	74 06                	je     801054c0 <popcli+0x30>
    sti();
}
801054ba:	c9                   	leave  
801054bb:	c3                   	ret    
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801054c0:	e8 ab e9 ff ff       	call   80103e70 <mycpu>
801054c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801054cb:	85 c0                	test   %eax,%eax
801054cd:	74 eb                	je     801054ba <popcli+0x2a>
  asm volatile("sti");
801054cf:	fb                   	sti    
}
801054d0:	c9                   	leave  
801054d1:	c3                   	ret    
    panic("popcli - interruptible");
801054d2:	83 ec 0c             	sub    $0xc,%esp
801054d5:	68 47 8a 10 80       	push   $0x80108a47
801054da:	e8 a1 ae ff ff       	call   80100380 <panic>
    panic("popcli");
801054df:	83 ec 0c             	sub    $0xc,%esp
801054e2:	68 5e 8a 10 80       	push   $0x80108a5e
801054e7:	e8 94 ae ff ff       	call   80100380 <panic>
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <holding>:
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	8b 75 08             	mov    0x8(%ebp),%esi
801054f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801054fa:	e8 41 ff ff ff       	call   80105440 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801054ff:	8b 06                	mov    (%esi),%eax
80105501:	85 c0                	test   %eax,%eax
80105503:	75 0b                	jne    80105510 <holding+0x20>
  popcli();
80105505:	e8 86 ff ff ff       	call   80105490 <popcli>
}
8010550a:	89 d8                	mov    %ebx,%eax
8010550c:	5b                   	pop    %ebx
8010550d:	5e                   	pop    %esi
8010550e:	5d                   	pop    %ebp
8010550f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80105510:	8b 5e 08             	mov    0x8(%esi),%ebx
80105513:	e8 58 e9 ff ff       	call   80103e70 <mycpu>
80105518:	39 c3                	cmp    %eax,%ebx
8010551a:	0f 94 c3             	sete   %bl
  popcli();
8010551d:	e8 6e ff ff ff       	call   80105490 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105522:	0f b6 db             	movzbl %bl,%ebx
}
80105525:	89 d8                	mov    %ebx,%eax
80105527:	5b                   	pop    %ebx
80105528:	5e                   	pop    %esi
80105529:	5d                   	pop    %ebp
8010552a:	c3                   	ret    
8010552b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010552f:	90                   	nop

80105530 <release>:
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	56                   	push   %esi
80105534:	53                   	push   %ebx
80105535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80105538:	e8 03 ff ff ff       	call   80105440 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010553d:	8b 03                	mov    (%ebx),%eax
8010553f:	85 c0                	test   %eax,%eax
80105541:	75 15                	jne    80105558 <release+0x28>
  popcli();
80105543:	e8 48 ff ff ff       	call   80105490 <popcli>
    panic("release");
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	68 65 8a 10 80       	push   $0x80108a65
80105550:	e8 2b ae ff ff       	call   80100380 <panic>
80105555:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105558:	8b 73 08             	mov    0x8(%ebx),%esi
8010555b:	e8 10 e9 ff ff       	call   80103e70 <mycpu>
80105560:	39 c6                	cmp    %eax,%esi
80105562:	75 df                	jne    80105543 <release+0x13>
  popcli();
80105564:	e8 27 ff ff ff       	call   80105490 <popcli>
  lk->pcs[0] = 0;
80105569:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105570:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105577:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010557c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105582:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105585:	5b                   	pop    %ebx
80105586:	5e                   	pop    %esi
80105587:	5d                   	pop    %ebp
  popcli();
80105588:	e9 03 ff ff ff       	jmp    80105490 <popcli>
8010558d:	8d 76 00             	lea    0x0(%esi),%esi

80105590 <acquire>:
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105597:	e8 a4 fe ff ff       	call   80105440 <pushcli>
  if(holding(lk))
8010559c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010559f:	e8 9c fe ff ff       	call   80105440 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801055a4:	8b 03                	mov    (%ebx),%eax
801055a6:	85 c0                	test   %eax,%eax
801055a8:	75 7e                	jne    80105628 <acquire+0x98>
  popcli();
801055aa:	e8 e1 fe ff ff       	call   80105490 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801055af:	b9 01 00 00 00       	mov    $0x1,%ecx
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
801055b8:	8b 55 08             	mov    0x8(%ebp),%edx
801055bb:	89 c8                	mov    %ecx,%eax
801055bd:	f0 87 02             	lock xchg %eax,(%edx)
801055c0:	85 c0                	test   %eax,%eax
801055c2:	75 f4                	jne    801055b8 <acquire+0x28>
  __sync_synchronize();
801055c4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801055c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801055cc:	e8 9f e8 ff ff       	call   80103e70 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801055d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
801055d4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
801055d6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
801055d9:	31 c0                	xor    %eax,%eax
801055db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801055e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801055ec:	77 1a                	ja     80105608 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
801055ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801055f1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801055f5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801055f8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801055fa:	83 f8 0a             	cmp    $0xa,%eax
801055fd:	75 e1                	jne    801055e0 <acquire+0x50>
}
801055ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105602:	c9                   	leave  
80105603:	c3                   	ret    
80105604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105608:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010560c:	8d 51 34             	lea    0x34(%ecx),%edx
8010560f:	90                   	nop
    pcs[i] = 0;
80105610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105616:	83 c0 04             	add    $0x4,%eax
80105619:	39 c2                	cmp    %eax,%edx
8010561b:	75 f3                	jne    80105610 <acquire+0x80>
}
8010561d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105620:	c9                   	leave  
80105621:	c3                   	ret    
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80105628:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010562b:	e8 40 e8 ff ff       	call   80103e70 <mycpu>
80105630:	39 c3                	cmp    %eax,%ebx
80105632:	0f 85 72 ff ff ff    	jne    801055aa <acquire+0x1a>
  popcli();
80105638:	e8 53 fe ff ff       	call   80105490 <popcli>
    panic("acquire");
8010563d:	83 ec 0c             	sub    $0xc,%esp
80105640:	68 6d 8a 10 80       	push   $0x80108a6d
80105645:	e8 36 ad ff ff       	call   80100380 <panic>
8010564a:	66 90                	xchg   %ax,%ax
8010564c:	66 90                	xchg   %ax,%ax
8010564e:	66 90                	xchg   %ax,%ax

80105650 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	8b 55 08             	mov    0x8(%ebp),%edx
80105657:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010565a:	53                   	push   %ebx
8010565b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
8010565e:	89 d7                	mov    %edx,%edi
80105660:	09 cf                	or     %ecx,%edi
80105662:	83 e7 03             	and    $0x3,%edi
80105665:	75 29                	jne    80105690 <memset+0x40>
    c &= 0xFF;
80105667:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010566a:	c1 e0 18             	shl    $0x18,%eax
8010566d:	89 fb                	mov    %edi,%ebx
8010566f:	c1 e9 02             	shr    $0x2,%ecx
80105672:	c1 e3 10             	shl    $0x10,%ebx
80105675:	09 d8                	or     %ebx,%eax
80105677:	09 f8                	or     %edi,%eax
80105679:	c1 e7 08             	shl    $0x8,%edi
8010567c:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010567e:	89 d7                	mov    %edx,%edi
80105680:	fc                   	cld    
80105681:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105683:	5b                   	pop    %ebx
80105684:	89 d0                	mov    %edx,%eax
80105686:	5f                   	pop    %edi
80105687:	5d                   	pop    %ebp
80105688:	c3                   	ret    
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80105690:	89 d7                	mov    %edx,%edi
80105692:	fc                   	cld    
80105693:	f3 aa                	rep stos %al,%es:(%edi)
80105695:	5b                   	pop    %ebx
80105696:	89 d0                	mov    %edx,%eax
80105698:	5f                   	pop    %edi
80105699:	5d                   	pop    %ebp
8010569a:	c3                   	ret    
8010569b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010569f:	90                   	nop

801056a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	56                   	push   %esi
801056a4:	8b 75 10             	mov    0x10(%ebp),%esi
801056a7:	8b 55 08             	mov    0x8(%ebp),%edx
801056aa:	53                   	push   %ebx
801056ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801056ae:	85 f6                	test   %esi,%esi
801056b0:	74 2e                	je     801056e0 <memcmp+0x40>
801056b2:	01 c6                	add    %eax,%esi
801056b4:	eb 14                	jmp    801056ca <memcmp+0x2a>
801056b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801056c0:	83 c0 01             	add    $0x1,%eax
801056c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801056c6:	39 f0                	cmp    %esi,%eax
801056c8:	74 16                	je     801056e0 <memcmp+0x40>
    if(*s1 != *s2)
801056ca:	0f b6 0a             	movzbl (%edx),%ecx
801056cd:	0f b6 18             	movzbl (%eax),%ebx
801056d0:	38 d9                	cmp    %bl,%cl
801056d2:	74 ec                	je     801056c0 <memcmp+0x20>
      return *s1 - *s2;
801056d4:	0f b6 c1             	movzbl %cl,%eax
801056d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801056d9:	5b                   	pop    %ebx
801056da:	5e                   	pop    %esi
801056db:	5d                   	pop    %ebp
801056dc:	c3                   	ret    
801056dd:	8d 76 00             	lea    0x0(%esi),%esi
801056e0:	5b                   	pop    %ebx
  return 0;
801056e1:	31 c0                	xor    %eax,%eax
}
801056e3:	5e                   	pop    %esi
801056e4:	5d                   	pop    %ebp
801056e5:	c3                   	ret    
801056e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ed:	8d 76 00             	lea    0x0(%esi),%esi

801056f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	8b 55 08             	mov    0x8(%ebp),%edx
801056f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801056fa:	56                   	push   %esi
801056fb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801056fe:	39 d6                	cmp    %edx,%esi
80105700:	73 26                	jae    80105728 <memmove+0x38>
80105702:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105705:	39 fa                	cmp    %edi,%edx
80105707:	73 1f                	jae    80105728 <memmove+0x38>
80105709:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
8010570c:	85 c9                	test   %ecx,%ecx
8010570e:	74 0c                	je     8010571c <memmove+0x2c>
      *--d = *--s;
80105710:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105714:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105717:	83 e8 01             	sub    $0x1,%eax
8010571a:	73 f4                	jae    80105710 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010571c:	5e                   	pop    %esi
8010571d:	89 d0                	mov    %edx,%eax
8010571f:	5f                   	pop    %edi
80105720:	5d                   	pop    %ebp
80105721:	c3                   	ret    
80105722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80105728:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
8010572b:	89 d7                	mov    %edx,%edi
8010572d:	85 c9                	test   %ecx,%ecx
8010572f:	74 eb                	je     8010571c <memmove+0x2c>
80105731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105738:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105739:	39 c6                	cmp    %eax,%esi
8010573b:	75 fb                	jne    80105738 <memmove+0x48>
}
8010573d:	5e                   	pop    %esi
8010573e:	89 d0                	mov    %edx,%eax
80105740:	5f                   	pop    %edi
80105741:	5d                   	pop    %ebp
80105742:	c3                   	ret    
80105743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105750 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80105750:	eb 9e                	jmp    801056f0 <memmove>
80105752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105760 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	8b 75 10             	mov    0x10(%ebp),%esi
80105767:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010576a:	53                   	push   %ebx
8010576b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
8010576e:	85 f6                	test   %esi,%esi
80105770:	74 2e                	je     801057a0 <strncmp+0x40>
80105772:	01 d6                	add    %edx,%esi
80105774:	eb 18                	jmp    8010578e <strncmp+0x2e>
80105776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577d:	8d 76 00             	lea    0x0(%esi),%esi
80105780:	38 d8                	cmp    %bl,%al
80105782:	75 14                	jne    80105798 <strncmp+0x38>
    n--, p++, q++;
80105784:	83 c2 01             	add    $0x1,%edx
80105787:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010578a:	39 f2                	cmp    %esi,%edx
8010578c:	74 12                	je     801057a0 <strncmp+0x40>
8010578e:	0f b6 01             	movzbl (%ecx),%eax
80105791:	0f b6 1a             	movzbl (%edx),%ebx
80105794:	84 c0                	test   %al,%al
80105796:	75 e8                	jne    80105780 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105798:	29 d8                	sub    %ebx,%eax
}
8010579a:	5b                   	pop    %ebx
8010579b:	5e                   	pop    %esi
8010579c:	5d                   	pop    %ebp
8010579d:	c3                   	ret    
8010579e:	66 90                	xchg   %ax,%ax
801057a0:	5b                   	pop    %ebx
    return 0;
801057a1:	31 c0                	xor    %eax,%eax
}
801057a3:	5e                   	pop    %esi
801057a4:	5d                   	pop    %ebp
801057a5:	c3                   	ret    
801057a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ad:	8d 76 00             	lea    0x0(%esi),%esi

801057b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	57                   	push   %edi
801057b4:	56                   	push   %esi
801057b5:	8b 75 08             	mov    0x8(%ebp),%esi
801057b8:	53                   	push   %ebx
801057b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801057bc:	89 f0                	mov    %esi,%eax
801057be:	eb 15                	jmp    801057d5 <strncpy+0x25>
801057c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801057c4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801057c7:	83 c0 01             	add    $0x1,%eax
801057ca:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
801057ce:	88 50 ff             	mov    %dl,-0x1(%eax)
801057d1:	84 d2                	test   %dl,%dl
801057d3:	74 09                	je     801057de <strncpy+0x2e>
801057d5:	89 cb                	mov    %ecx,%ebx
801057d7:	83 e9 01             	sub    $0x1,%ecx
801057da:	85 db                	test   %ebx,%ebx
801057dc:	7f e2                	jg     801057c0 <strncpy+0x10>
    ;
  while(n-- > 0)
801057de:	89 c2                	mov    %eax,%edx
801057e0:	85 c9                	test   %ecx,%ecx
801057e2:	7e 17                	jle    801057fb <strncpy+0x4b>
801057e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801057e8:	83 c2 01             	add    $0x1,%edx
801057eb:	89 c1                	mov    %eax,%ecx
801057ed:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
801057f1:	29 d1                	sub    %edx,%ecx
801057f3:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
801057f7:	85 c9                	test   %ecx,%ecx
801057f9:	7f ed                	jg     801057e8 <strncpy+0x38>
  return os;
}
801057fb:	5b                   	pop    %ebx
801057fc:	89 f0                	mov    %esi,%eax
801057fe:	5e                   	pop    %esi
801057ff:	5f                   	pop    %edi
80105800:	5d                   	pop    %ebp
80105801:	c3                   	ret    
80105802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105810 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	56                   	push   %esi
80105814:	8b 55 10             	mov    0x10(%ebp),%edx
80105817:	8b 75 08             	mov    0x8(%ebp),%esi
8010581a:	53                   	push   %ebx
8010581b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010581e:	85 d2                	test   %edx,%edx
80105820:	7e 25                	jle    80105847 <safestrcpy+0x37>
80105822:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105826:	89 f2                	mov    %esi,%edx
80105828:	eb 16                	jmp    80105840 <safestrcpy+0x30>
8010582a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105830:	0f b6 08             	movzbl (%eax),%ecx
80105833:	83 c0 01             	add    $0x1,%eax
80105836:	83 c2 01             	add    $0x1,%edx
80105839:	88 4a ff             	mov    %cl,-0x1(%edx)
8010583c:	84 c9                	test   %cl,%cl
8010583e:	74 04                	je     80105844 <safestrcpy+0x34>
80105840:	39 d8                	cmp    %ebx,%eax
80105842:	75 ec                	jne    80105830 <safestrcpy+0x20>
    ;
  *s = 0;
80105844:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105847:	89 f0                	mov    %esi,%eax
80105849:	5b                   	pop    %ebx
8010584a:	5e                   	pop    %esi
8010584b:	5d                   	pop    %ebp
8010584c:	c3                   	ret    
8010584d:	8d 76 00             	lea    0x0(%esi),%esi

80105850 <strlen>:

int
strlen(const char *s)
{
80105850:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105851:	31 c0                	xor    %eax,%eax
{
80105853:	89 e5                	mov    %esp,%ebp
80105855:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105858:	80 3a 00             	cmpb   $0x0,(%edx)
8010585b:	74 0c                	je     80105869 <strlen+0x19>
8010585d:	8d 76 00             	lea    0x0(%esi),%esi
80105860:	83 c0 01             	add    $0x1,%eax
80105863:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105867:	75 f7                	jne    80105860 <strlen+0x10>
    ;
  return n;
}
80105869:	5d                   	pop    %ebp
8010586a:	c3                   	ret    

8010586b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010586b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010586f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105873:	55                   	push   %ebp
  pushl %ebx
80105874:	53                   	push   %ebx
  pushl %esi
80105875:	56                   	push   %esi
  pushl %edi
80105876:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105877:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105879:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010587b:	5f                   	pop    %edi
  popl %esi
8010587c:	5e                   	pop    %esi
  popl %ebx
8010587d:	5b                   	pop    %ebx
  popl %ebp
8010587e:	5d                   	pop    %ebp
  ret
8010587f:	c3                   	ret    

80105880 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	53                   	push   %ebx
80105884:	83 ec 04             	sub    $0x4,%esp
80105887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010588a:	e8 61 e6 ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010588f:	8b 00                	mov    (%eax),%eax
80105891:	39 d8                	cmp    %ebx,%eax
80105893:	76 1b                	jbe    801058b0 <fetchint+0x30>
80105895:	8d 53 04             	lea    0x4(%ebx),%edx
80105898:	39 d0                	cmp    %edx,%eax
8010589a:	72 14                	jb     801058b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010589c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010589f:	8b 13                	mov    (%ebx),%edx
801058a1:	89 10                	mov    %edx,(%eax)
  return 0;
801058a3:	31 c0                	xor    %eax,%eax
}
801058a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a8:	c9                   	leave  
801058a9:	c3                   	ret    
801058aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b5:	eb ee                	jmp    801058a5 <fetchint+0x25>
801058b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058be:	66 90                	xchg   %ax,%ax

801058c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	53                   	push   %ebx
801058c4:	83 ec 04             	sub    $0x4,%esp
801058c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801058ca:	e8 21 e6 ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz)
801058cf:	39 18                	cmp    %ebx,(%eax)
801058d1:	76 2d                	jbe    80105900 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801058d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801058d6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801058d8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801058da:	39 d3                	cmp    %edx,%ebx
801058dc:	73 22                	jae    80105900 <fetchstr+0x40>
801058de:	89 d8                	mov    %ebx,%eax
801058e0:	eb 0d                	jmp    801058ef <fetchstr+0x2f>
801058e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058e8:	83 c0 01             	add    $0x1,%eax
801058eb:	39 c2                	cmp    %eax,%edx
801058ed:	76 11                	jbe    80105900 <fetchstr+0x40>
    if(*s == 0)
801058ef:	80 38 00             	cmpb   $0x0,(%eax)
801058f2:	75 f4                	jne    801058e8 <fetchstr+0x28>
      return s - *pp;
801058f4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801058f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058f9:	c9                   	leave  
801058fa:	c3                   	ret    
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop
80105900:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105903:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105908:	c9                   	leave  
80105909:	c3                   	ret    
8010590a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105910 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	56                   	push   %esi
80105914:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105915:	e8 d6 e5 ff ff       	call   80103ef0 <myproc>
8010591a:	8b 55 08             	mov    0x8(%ebp),%edx
8010591d:	8b 40 18             	mov    0x18(%eax),%eax
80105920:	8b 40 44             	mov    0x44(%eax),%eax
80105923:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105926:	e8 c5 e5 ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010592b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010592e:	8b 00                	mov    (%eax),%eax
80105930:	39 c6                	cmp    %eax,%esi
80105932:	73 1c                	jae    80105950 <argint+0x40>
80105934:	8d 53 08             	lea    0x8(%ebx),%edx
80105937:	39 d0                	cmp    %edx,%eax
80105939:	72 15                	jb     80105950 <argint+0x40>
  *ip = *(int*)(addr);
8010593b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010593e:	8b 53 04             	mov    0x4(%ebx),%edx
80105941:	89 10                	mov    %edx,(%eax)
  return 0;
80105943:	31 c0                	xor    %eax,%eax
}
80105945:	5b                   	pop    %ebx
80105946:	5e                   	pop    %esi
80105947:	5d                   	pop    %ebp
80105948:	c3                   	ret    
80105949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105955:	eb ee                	jmp    80105945 <argint+0x35>
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax

80105960 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
80105965:	53                   	push   %ebx
80105966:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105969:	e8 82 e5 ff ff       	call   80103ef0 <myproc>
8010596e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105970:	e8 7b e5 ff ff       	call   80103ef0 <myproc>
80105975:	8b 55 08             	mov    0x8(%ebp),%edx
80105978:	8b 40 18             	mov    0x18(%eax),%eax
8010597b:	8b 40 44             	mov    0x44(%eax),%eax
8010597e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105981:	e8 6a e5 ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105986:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105989:	8b 00                	mov    (%eax),%eax
8010598b:	39 c7                	cmp    %eax,%edi
8010598d:	73 31                	jae    801059c0 <argptr+0x60>
8010598f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105992:	39 c8                	cmp    %ecx,%eax
80105994:	72 2a                	jb     801059c0 <argptr+0x60>

  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105996:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105999:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010599c:	85 d2                	test   %edx,%edx
8010599e:	78 20                	js     801059c0 <argptr+0x60>
801059a0:	8b 16                	mov    (%esi),%edx
801059a2:	39 c2                	cmp    %eax,%edx
801059a4:	76 1a                	jbe    801059c0 <argptr+0x60>
801059a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801059a9:	01 c3                	add    %eax,%ebx
801059ab:	39 da                	cmp    %ebx,%edx
801059ad:	72 11                	jb     801059c0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801059af:	8b 55 0c             	mov    0xc(%ebp),%edx
801059b2:	89 02                	mov    %eax,(%edx)
  return 0;
801059b4:	31 c0                	xor    %eax,%eax
}
801059b6:	83 c4 0c             	add    $0xc,%esp
801059b9:	5b                   	pop    %ebx
801059ba:	5e                   	pop    %esi
801059bb:	5f                   	pop    %edi
801059bc:	5d                   	pop    %ebp
801059bd:	c3                   	ret    
801059be:	66 90                	xchg   %ax,%ax
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c5:	eb ef                	jmp    801059b6 <argptr+0x56>
801059c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ce:	66 90                	xchg   %ax,%ax

801059d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	56                   	push   %esi
801059d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059d5:	e8 16 e5 ff ff       	call   80103ef0 <myproc>
801059da:	8b 55 08             	mov    0x8(%ebp),%edx
801059dd:	8b 40 18             	mov    0x18(%eax),%eax
801059e0:	8b 40 44             	mov    0x44(%eax),%eax
801059e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801059e6:	e8 05 e5 ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801059eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801059ee:	8b 00                	mov    (%eax),%eax
801059f0:	39 c6                	cmp    %eax,%esi
801059f2:	73 44                	jae    80105a38 <argstr+0x68>
801059f4:	8d 53 08             	lea    0x8(%ebx),%edx
801059f7:	39 d0                	cmp    %edx,%eax
801059f9:	72 3d                	jb     80105a38 <argstr+0x68>
  *ip = *(int*)(addr);
801059fb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801059fe:	e8 ed e4 ff ff       	call   80103ef0 <myproc>
  if(addr >= curproc->sz)
80105a03:	3b 18                	cmp    (%eax),%ebx
80105a05:	73 31                	jae    80105a38 <argstr+0x68>
  *pp = (char*)addr;
80105a07:	8b 55 0c             	mov    0xc(%ebp),%edx
80105a0a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80105a0c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80105a0e:	39 d3                	cmp    %edx,%ebx
80105a10:	73 26                	jae    80105a38 <argstr+0x68>
80105a12:	89 d8                	mov    %ebx,%eax
80105a14:	eb 11                	jmp    80105a27 <argstr+0x57>
80105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
80105a20:	83 c0 01             	add    $0x1,%eax
80105a23:	39 c2                	cmp    %eax,%edx
80105a25:	76 11                	jbe    80105a38 <argstr+0x68>
    if(*s == 0)
80105a27:	80 38 00             	cmpb   $0x0,(%eax)
80105a2a:	75 f4                	jne    80105a20 <argstr+0x50>
      return s - *pp;
80105a2c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80105a2e:	5b                   	pop    %ebx
80105a2f:	5e                   	pop    %esi
80105a30:	5d                   	pop    %ebp
80105a31:	c3                   	ret    
80105a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105a38:	5b                   	pop    %ebx
    return -1;
80105a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a3e:	5e                   	pop    %esi
80105a3f:	5d                   	pop    %ebp
80105a40:	c3                   	ret    
80105a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4f:	90                   	nop

80105a50 <syscall>:
};


void
syscall(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	56                   	push   %esi
80105a54:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105a55:	e8 96 e4 ff ff       	call   80103ef0 <myproc>
80105a5a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105a5c:	8b 40 18             	mov    0x18(%eax),%eax
80105a5f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105a62:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a65:	83 fa 1b             	cmp    $0x1b,%edx
80105a68:	77 2e                	ja     80105a98 <syscall+0x48>
80105a6a:	8b 34 85 a0 8a 10 80 	mov    -0x7fef7560(,%eax,4),%esi
80105a71:	85 f6                	test   %esi,%esi
80105a73:	74 23                	je     80105a98 <syscall+0x48>
    // increase the count of how many times a system call, has been called by one.
    update_syscalls_count(num);
80105a75:	83 ec 0c             	sub    $0xc,%esp
80105a78:	50                   	push   %eax
80105a79:	e8 b2 f2 ff ff       	call   80104d30 <update_syscalls_count>
    curproc->tf->eax = syscalls[num]();
80105a7e:	ff d6                	call   *%esi
80105a80:	83 c4 10             	add    $0x10,%esp
80105a83:	89 c2                	mov    %eax,%edx
80105a85:	8b 43 18             	mov    0x18(%ebx),%eax
80105a88:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105a8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a8e:	5b                   	pop    %ebx
80105a8f:	5e                   	pop    %esi
80105a90:	5d                   	pop    %ebp
80105a91:	c3                   	ret    
80105a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105a98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105a99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105a9c:	50                   	push   %eax
80105a9d:	ff 73 10             	push   0x10(%ebx)
80105aa0:	68 75 8a 10 80       	push   $0x80108a75
80105aa5:	e8 46 ac ff ff       	call   801006f0 <cprintf>
    curproc->tf->eax = -1;
80105aaa:	8b 43 18             	mov    0x18(%ebx),%eax
80105aad:	83 c4 10             	add    $0x10,%esp
80105ab0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105ab7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105aba:	5b                   	pop    %ebx
80105abb:	5e                   	pop    %esi
80105abc:	5d                   	pop    %ebp
80105abd:	c3                   	ret    
80105abe:	66 90                	xchg   %ax,%ax

80105ac0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105ac5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105ac8:	53                   	push   %ebx
80105ac9:	83 ec 34             	sub    $0x34,%esp
80105acc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80105acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105ad2:	57                   	push   %edi
80105ad3:	50                   	push   %eax
{
80105ad4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105ad7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105ada:	e8 81 ca ff ff       	call   80102560 <nameiparent>
80105adf:	83 c4 10             	add    $0x10,%esp
80105ae2:	85 c0                	test   %eax,%eax
80105ae4:	0f 84 46 01 00 00    	je     80105c30 <create+0x170>
    return 0;
  ilock(dp);
80105aea:	83 ec 0c             	sub    $0xc,%esp
80105aed:	89 c3                	mov    %eax,%ebx
80105aef:	50                   	push   %eax
80105af0:	e8 2b c1 ff ff       	call   80101c20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105af5:	83 c4 0c             	add    $0xc,%esp
80105af8:	6a 00                	push   $0x0
80105afa:	57                   	push   %edi
80105afb:	53                   	push   %ebx
80105afc:	e8 7f c6 ff ff       	call   80102180 <dirlookup>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	89 c6                	mov    %eax,%esi
80105b06:	85 c0                	test   %eax,%eax
80105b08:	74 56                	je     80105b60 <create+0xa0>
    iunlockput(dp);
80105b0a:	83 ec 0c             	sub    $0xc,%esp
80105b0d:	53                   	push   %ebx
80105b0e:	e8 9d c3 ff ff       	call   80101eb0 <iunlockput>
    ilock(ip);
80105b13:	89 34 24             	mov    %esi,(%esp)
80105b16:	e8 05 c1 ff ff       	call   80101c20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105b1b:	83 c4 10             	add    $0x10,%esp
80105b1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105b23:	75 1b                	jne    80105b40 <create+0x80>
80105b25:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80105b2a:	75 14                	jne    80105b40 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105b2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b2f:	89 f0                	mov    %esi,%eax
80105b31:	5b                   	pop    %ebx
80105b32:	5e                   	pop    %esi
80105b33:	5f                   	pop    %edi
80105b34:	5d                   	pop    %ebp
80105b35:	c3                   	ret    
80105b36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	56                   	push   %esi
    return 0;
80105b44:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105b46:	e8 65 c3 ff ff       	call   80101eb0 <iunlockput>
    return 0;
80105b4b:	83 c4 10             	add    $0x10,%esp
}
80105b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b51:	89 f0                	mov    %esi,%eax
80105b53:	5b                   	pop    %ebx
80105b54:	5e                   	pop    %esi
80105b55:	5f                   	pop    %edi
80105b56:	5d                   	pop    %ebp
80105b57:	c3                   	ret    
80105b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105b60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105b64:	83 ec 08             	sub    $0x8,%esp
80105b67:	50                   	push   %eax
80105b68:	ff 33                	push   (%ebx)
80105b6a:	e8 41 bf ff ff       	call   80101ab0 <ialloc>
80105b6f:	83 c4 10             	add    $0x10,%esp
80105b72:	89 c6                	mov    %eax,%esi
80105b74:	85 c0                	test   %eax,%eax
80105b76:	0f 84 cd 00 00 00    	je     80105c49 <create+0x189>
  ilock(ip);
80105b7c:	83 ec 0c             	sub    $0xc,%esp
80105b7f:	50                   	push   %eax
80105b80:	e8 9b c0 ff ff       	call   80101c20 <ilock>
  ip->major = major;
80105b85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105b89:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80105b8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105b91:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105b95:	b8 01 00 00 00       	mov    $0x1,%eax
80105b9a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80105b9e:	89 34 24             	mov    %esi,(%esp)
80105ba1:	e8 ca bf ff ff       	call   80101b70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105bae:	74 30                	je     80105be0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105bb0:	83 ec 04             	sub    $0x4,%esp
80105bb3:	ff 76 04             	push   0x4(%esi)
80105bb6:	57                   	push   %edi
80105bb7:	53                   	push   %ebx
80105bb8:	e8 c3 c8 ff ff       	call   80102480 <dirlink>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	85 c0                	test   %eax,%eax
80105bc2:	78 78                	js     80105c3c <create+0x17c>
  iunlockput(dp);
80105bc4:	83 ec 0c             	sub    $0xc,%esp
80105bc7:	53                   	push   %ebx
80105bc8:	e8 e3 c2 ff ff       	call   80101eb0 <iunlockput>
  return ip;
80105bcd:	83 c4 10             	add    $0x10,%esp
}
80105bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd3:	89 f0                	mov    %esi,%eax
80105bd5:	5b                   	pop    %ebx
80105bd6:	5e                   	pop    %esi
80105bd7:	5f                   	pop    %edi
80105bd8:	5d                   	pop    %ebp
80105bd9:	c3                   	ret    
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105be0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105be3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105be8:	53                   	push   %ebx
80105be9:	e8 82 bf ff ff       	call   80101b70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105bee:	83 c4 0c             	add    $0xc,%esp
80105bf1:	ff 76 04             	push   0x4(%esi)
80105bf4:	68 30 8b 10 80       	push   $0x80108b30
80105bf9:	56                   	push   %esi
80105bfa:	e8 81 c8 ff ff       	call   80102480 <dirlink>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	85 c0                	test   %eax,%eax
80105c04:	78 18                	js     80105c1e <create+0x15e>
80105c06:	83 ec 04             	sub    $0x4,%esp
80105c09:	ff 73 04             	push   0x4(%ebx)
80105c0c:	68 2f 8b 10 80       	push   $0x80108b2f
80105c11:	56                   	push   %esi
80105c12:	e8 69 c8 ff ff       	call   80102480 <dirlink>
80105c17:	83 c4 10             	add    $0x10,%esp
80105c1a:	85 c0                	test   %eax,%eax
80105c1c:	79 92                	jns    80105bb0 <create+0xf0>
      panic("create dots");
80105c1e:	83 ec 0c             	sub    $0xc,%esp
80105c21:	68 23 8b 10 80       	push   $0x80108b23
80105c26:	e8 55 a7 ff ff       	call   80100380 <panic>
80105c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c2f:	90                   	nop
}
80105c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105c33:	31 f6                	xor    %esi,%esi
}
80105c35:	5b                   	pop    %ebx
80105c36:	89 f0                	mov    %esi,%eax
80105c38:	5e                   	pop    %esi
80105c39:	5f                   	pop    %edi
80105c3a:	5d                   	pop    %ebp
80105c3b:	c3                   	ret    
    panic("create: dirlink");
80105c3c:	83 ec 0c             	sub    $0xc,%esp
80105c3f:	68 32 8b 10 80       	push   $0x80108b32
80105c44:	e8 37 a7 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105c49:	83 ec 0c             	sub    $0xc,%esp
80105c4c:	68 14 8b 10 80       	push   $0x80108b14
80105c51:	e8 2a a7 ff ff       	call   80100380 <panic>
80105c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5d:	8d 76 00             	lea    0x0(%esi),%esi

80105c60 <sys_dup>:
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	56                   	push   %esi
80105c64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105c65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105c6b:	50                   	push   %eax
80105c6c:	6a 00                	push   $0x0
80105c6e:	e8 9d fc ff ff       	call   80105910 <argint>
80105c73:	83 c4 10             	add    $0x10,%esp
80105c76:	85 c0                	test   %eax,%eax
80105c78:	78 36                	js     80105cb0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105c7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105c7e:	77 30                	ja     80105cb0 <sys_dup+0x50>
80105c80:	e8 6b e2 ff ff       	call   80103ef0 <myproc>
80105c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105c8c:	85 f6                	test   %esi,%esi
80105c8e:	74 20                	je     80105cb0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105c90:	e8 5b e2 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105c95:	31 db                	xor    %ebx,%ebx
80105c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c9e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105ca0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ca4:	85 d2                	test   %edx,%edx
80105ca6:	74 18                	je     80105cc0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105ca8:	83 c3 01             	add    $0x1,%ebx
80105cab:	83 fb 10             	cmp    $0x10,%ebx
80105cae:	75 f0                	jne    80105ca0 <sys_dup+0x40>
}
80105cb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105cb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105cb8:	89 d8                	mov    %ebx,%eax
80105cba:	5b                   	pop    %ebx
80105cbb:	5e                   	pop    %esi
80105cbc:	5d                   	pop    %ebp
80105cbd:	c3                   	ret    
80105cbe:	66 90                	xchg   %ax,%ax
  filedup(f);
80105cc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105cc3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105cc7:	56                   	push   %esi
80105cc8:	e8 73 b6 ff ff       	call   80101340 <filedup>
  return fd;
80105ccd:	83 c4 10             	add    $0x10,%esp
}
80105cd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cd3:	89 d8                	mov    %ebx,%eax
80105cd5:	5b                   	pop    %ebx
80105cd6:	5e                   	pop    %esi
80105cd7:	5d                   	pop    %ebp
80105cd8:	c3                   	ret    
80105cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_read>:
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	56                   	push   %esi
80105ce4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105ce5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105ce8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105ceb:	53                   	push   %ebx
80105cec:	6a 00                	push   $0x0
80105cee:	e8 1d fc ff ff       	call   80105910 <argint>
80105cf3:	83 c4 10             	add    $0x10,%esp
80105cf6:	85 c0                	test   %eax,%eax
80105cf8:	78 5e                	js     80105d58 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105cfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105cfe:	77 58                	ja     80105d58 <sys_read+0x78>
80105d00:	e8 eb e1 ff ff       	call   80103ef0 <myproc>
80105d05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105d0c:	85 f6                	test   %esi,%esi
80105d0e:	74 48                	je     80105d58 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d16:	50                   	push   %eax
80105d17:	6a 02                	push   $0x2
80105d19:	e8 f2 fb ff ff       	call   80105910 <argint>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	85 c0                	test   %eax,%eax
80105d23:	78 33                	js     80105d58 <sys_read+0x78>
80105d25:	83 ec 04             	sub    $0x4,%esp
80105d28:	ff 75 f0             	push   -0x10(%ebp)
80105d2b:	53                   	push   %ebx
80105d2c:	6a 01                	push   $0x1
80105d2e:	e8 2d fc ff ff       	call   80105960 <argptr>
80105d33:	83 c4 10             	add    $0x10,%esp
80105d36:	85 c0                	test   %eax,%eax
80105d38:	78 1e                	js     80105d58 <sys_read+0x78>
  return fileread(f, p, n);
80105d3a:	83 ec 04             	sub    $0x4,%esp
80105d3d:	ff 75 f0             	push   -0x10(%ebp)
80105d40:	ff 75 f4             	push   -0xc(%ebp)
80105d43:	56                   	push   %esi
80105d44:	e8 77 b7 ff ff       	call   801014c0 <fileread>
80105d49:	83 c4 10             	add    $0x10,%esp
}
80105d4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d4f:	5b                   	pop    %ebx
80105d50:	5e                   	pop    %esi
80105d51:	5d                   	pop    %ebp
80105d52:	c3                   	ret    
80105d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d57:	90                   	nop
    return -1;
80105d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5d:	eb ed                	jmp    80105d4c <sys_read+0x6c>
80105d5f:	90                   	nop

80105d60 <sys_write>:
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	56                   	push   %esi
80105d64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105d65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105d68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105d6b:	53                   	push   %ebx
80105d6c:	6a 00                	push   $0x0
80105d6e:	e8 9d fb ff ff       	call   80105910 <argint>
80105d73:	83 c4 10             	add    $0x10,%esp
80105d76:	85 c0                	test   %eax,%eax
80105d78:	78 5e                	js     80105dd8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105d7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105d7e:	77 58                	ja     80105dd8 <sys_write+0x78>
80105d80:	e8 6b e1 ff ff       	call   80103ef0 <myproc>
80105d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105d8c:	85 f6                	test   %esi,%esi
80105d8e:	74 48                	je     80105dd8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d90:	83 ec 08             	sub    $0x8,%esp
80105d93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d96:	50                   	push   %eax
80105d97:	6a 02                	push   $0x2
80105d99:	e8 72 fb ff ff       	call   80105910 <argint>
80105d9e:	83 c4 10             	add    $0x10,%esp
80105da1:	85 c0                	test   %eax,%eax
80105da3:	78 33                	js     80105dd8 <sys_write+0x78>
80105da5:	83 ec 04             	sub    $0x4,%esp
80105da8:	ff 75 f0             	push   -0x10(%ebp)
80105dab:	53                   	push   %ebx
80105dac:	6a 01                	push   $0x1
80105dae:	e8 ad fb ff ff       	call   80105960 <argptr>
80105db3:	83 c4 10             	add    $0x10,%esp
80105db6:	85 c0                	test   %eax,%eax
80105db8:	78 1e                	js     80105dd8 <sys_write+0x78>
  return filewrite(f, p, n);
80105dba:	83 ec 04             	sub    $0x4,%esp
80105dbd:	ff 75 f0             	push   -0x10(%ebp)
80105dc0:	ff 75 f4             	push   -0xc(%ebp)
80105dc3:	56                   	push   %esi
80105dc4:	e8 87 b7 ff ff       	call   80101550 <filewrite>
80105dc9:	83 c4 10             	add    $0x10,%esp
}
80105dcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105dcf:	5b                   	pop    %ebx
80105dd0:	5e                   	pop    %esi
80105dd1:	5d                   	pop    %ebp
80105dd2:	c3                   	ret    
80105dd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105dd7:	90                   	nop
    return -1;
80105dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddd:	eb ed                	jmp    80105dcc <sys_write+0x6c>
80105ddf:	90                   	nop

80105de0 <sys_close>:
{
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	56                   	push   %esi
80105de4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105de5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105de8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105deb:	50                   	push   %eax
80105dec:	6a 00                	push   $0x0
80105dee:	e8 1d fb ff ff       	call   80105910 <argint>
80105df3:	83 c4 10             	add    $0x10,%esp
80105df6:	85 c0                	test   %eax,%eax
80105df8:	78 3e                	js     80105e38 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105dfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105dfe:	77 38                	ja     80105e38 <sys_close+0x58>
80105e00:	e8 eb e0 ff ff       	call   80103ef0 <myproc>
80105e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e08:	8d 5a 08             	lea    0x8(%edx),%ebx
80105e0b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80105e0f:	85 f6                	test   %esi,%esi
80105e11:	74 25                	je     80105e38 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105e13:	e8 d8 e0 ff ff       	call   80103ef0 <myproc>
  fileclose(f);
80105e18:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105e1b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105e22:	00 
  fileclose(f);
80105e23:	56                   	push   %esi
80105e24:	e8 67 b5 ff ff       	call   80101390 <fileclose>
  return 0;
80105e29:	83 c4 10             	add    $0x10,%esp
80105e2c:	31 c0                	xor    %eax,%eax
}
80105e2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e31:	5b                   	pop    %ebx
80105e32:	5e                   	pop    %esi
80105e33:	5d                   	pop    %ebp
80105e34:	c3                   	ret    
80105e35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3d:	eb ef                	jmp    80105e2e <sys_close+0x4e>
80105e3f:	90                   	nop

80105e40 <sys_fstat>:
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	56                   	push   %esi
80105e44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105e45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105e48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80105e4b:	53                   	push   %ebx
80105e4c:	6a 00                	push   $0x0
80105e4e:	e8 bd fa ff ff       	call   80105910 <argint>
80105e53:	83 c4 10             	add    $0x10,%esp
80105e56:	85 c0                	test   %eax,%eax
80105e58:	78 46                	js     80105ea0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105e5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105e5e:	77 40                	ja     80105ea0 <sys_fstat+0x60>
80105e60:	e8 8b e0 ff ff       	call   80103ef0 <myproc>
80105e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80105e6c:	85 f6                	test   %esi,%esi
80105e6e:	74 30                	je     80105ea0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e70:	83 ec 04             	sub    $0x4,%esp
80105e73:	6a 14                	push   $0x14
80105e75:	53                   	push   %ebx
80105e76:	6a 01                	push   $0x1
80105e78:	e8 e3 fa ff ff       	call   80105960 <argptr>
80105e7d:	83 c4 10             	add    $0x10,%esp
80105e80:	85 c0                	test   %eax,%eax
80105e82:	78 1c                	js     80105ea0 <sys_fstat+0x60>
  return filestat(f, st);
80105e84:	83 ec 08             	sub    $0x8,%esp
80105e87:	ff 75 f4             	push   -0xc(%ebp)
80105e8a:	56                   	push   %esi
80105e8b:	e8 e0 b5 ff ff       	call   80101470 <filestat>
80105e90:	83 c4 10             	add    $0x10,%esp
}
80105e93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105e96:	5b                   	pop    %ebx
80105e97:	5e                   	pop    %esi
80105e98:	5d                   	pop    %ebp
80105e99:	c3                   	ret    
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea5:	eb ec                	jmp    80105e93 <sys_fstat+0x53>
80105ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <sys_link>:
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	57                   	push   %edi
80105eb4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105eb5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105eb8:	53                   	push   %ebx
80105eb9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ebc:	50                   	push   %eax
80105ebd:	6a 00                	push   $0x0
80105ebf:	e8 0c fb ff ff       	call   801059d0 <argstr>
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	85 c0                	test   %eax,%eax
80105ec9:	0f 88 fb 00 00 00    	js     80105fca <sys_link+0x11a>
80105ecf:	83 ec 08             	sub    $0x8,%esp
80105ed2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105ed5:	50                   	push   %eax
80105ed6:	6a 01                	push   $0x1
80105ed8:	e8 f3 fa ff ff       	call   801059d0 <argstr>
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	85 c0                	test   %eax,%eax
80105ee2:	0f 88 e2 00 00 00    	js     80105fca <sys_link+0x11a>
  begin_op();
80105ee8:	e8 13 d3 ff ff       	call   80103200 <begin_op>
  if((ip = namei(old)) == 0){
80105eed:	83 ec 0c             	sub    $0xc,%esp
80105ef0:	ff 75 d4             	push   -0x2c(%ebp)
80105ef3:	e8 48 c6 ff ff       	call   80102540 <namei>
80105ef8:	83 c4 10             	add    $0x10,%esp
80105efb:	89 c3                	mov    %eax,%ebx
80105efd:	85 c0                	test   %eax,%eax
80105eff:	0f 84 e4 00 00 00    	je     80105fe9 <sys_link+0x139>
  ilock(ip);
80105f05:	83 ec 0c             	sub    $0xc,%esp
80105f08:	50                   	push   %eax
80105f09:	e8 12 bd ff ff       	call   80101c20 <ilock>
  if(ip->type == T_DIR){
80105f0e:	83 c4 10             	add    $0x10,%esp
80105f11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f16:	0f 84 b5 00 00 00    	je     80105fd1 <sys_link+0x121>
  iupdate(ip);
80105f1c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105f1f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105f24:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105f27:	53                   	push   %ebx
80105f28:	e8 43 bc ff ff       	call   80101b70 <iupdate>
  iunlock(ip);
80105f2d:	89 1c 24             	mov    %ebx,(%esp)
80105f30:	e8 cb bd ff ff       	call   80101d00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105f35:	58                   	pop    %eax
80105f36:	5a                   	pop    %edx
80105f37:	57                   	push   %edi
80105f38:	ff 75 d0             	push   -0x30(%ebp)
80105f3b:	e8 20 c6 ff ff       	call   80102560 <nameiparent>
80105f40:	83 c4 10             	add    $0x10,%esp
80105f43:	89 c6                	mov    %eax,%esi
80105f45:	85 c0                	test   %eax,%eax
80105f47:	74 5b                	je     80105fa4 <sys_link+0xf4>
  ilock(dp);
80105f49:	83 ec 0c             	sub    $0xc,%esp
80105f4c:	50                   	push   %eax
80105f4d:	e8 ce bc ff ff       	call   80101c20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f52:	8b 03                	mov    (%ebx),%eax
80105f54:	83 c4 10             	add    $0x10,%esp
80105f57:	39 06                	cmp    %eax,(%esi)
80105f59:	75 3d                	jne    80105f98 <sys_link+0xe8>
80105f5b:	83 ec 04             	sub    $0x4,%esp
80105f5e:	ff 73 04             	push   0x4(%ebx)
80105f61:	57                   	push   %edi
80105f62:	56                   	push   %esi
80105f63:	e8 18 c5 ff ff       	call   80102480 <dirlink>
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	78 29                	js     80105f98 <sys_link+0xe8>
  iunlockput(dp);
80105f6f:	83 ec 0c             	sub    $0xc,%esp
80105f72:	56                   	push   %esi
80105f73:	e8 38 bf ff ff       	call   80101eb0 <iunlockput>
  iput(ip);
80105f78:	89 1c 24             	mov    %ebx,(%esp)
80105f7b:	e8 d0 bd ff ff       	call   80101d50 <iput>
  end_op();
80105f80:	e8 eb d2 ff ff       	call   80103270 <end_op>
  return 0;
80105f85:	83 c4 10             	add    $0x10,%esp
80105f88:	31 c0                	xor    %eax,%eax
}
80105f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f8d:	5b                   	pop    %ebx
80105f8e:	5e                   	pop    %esi
80105f8f:	5f                   	pop    %edi
80105f90:	5d                   	pop    %ebp
80105f91:	c3                   	ret    
80105f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105f98:	83 ec 0c             	sub    $0xc,%esp
80105f9b:	56                   	push   %esi
80105f9c:	e8 0f bf ff ff       	call   80101eb0 <iunlockput>
    goto bad;
80105fa1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105fa4:	83 ec 0c             	sub    $0xc,%esp
80105fa7:	53                   	push   %ebx
80105fa8:	e8 73 bc ff ff       	call   80101c20 <ilock>
  ip->nlink--;
80105fad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105fb2:	89 1c 24             	mov    %ebx,(%esp)
80105fb5:	e8 b6 bb ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
80105fba:	89 1c 24             	mov    %ebx,(%esp)
80105fbd:	e8 ee be ff ff       	call   80101eb0 <iunlockput>
  end_op();
80105fc2:	e8 a9 d2 ff ff       	call   80103270 <end_op>
  return -1;
80105fc7:	83 c4 10             	add    $0x10,%esp
80105fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fcf:	eb b9                	jmp    80105f8a <sys_link+0xda>
    iunlockput(ip);
80105fd1:	83 ec 0c             	sub    $0xc,%esp
80105fd4:	53                   	push   %ebx
80105fd5:	e8 d6 be ff ff       	call   80101eb0 <iunlockput>
    end_op();
80105fda:	e8 91 d2 ff ff       	call   80103270 <end_op>
    return -1;
80105fdf:	83 c4 10             	add    $0x10,%esp
80105fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe7:	eb a1                	jmp    80105f8a <sys_link+0xda>
    end_op();
80105fe9:	e8 82 d2 ff ff       	call   80103270 <end_op>
    return -1;
80105fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ff3:	eb 95                	jmp    80105f8a <sys_link+0xda>
80105ff5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_unlink>:
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	57                   	push   %edi
80106004:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106005:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80106008:	53                   	push   %ebx
80106009:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010600c:	50                   	push   %eax
8010600d:	6a 00                	push   $0x0
8010600f:	e8 bc f9 ff ff       	call   801059d0 <argstr>
80106014:	83 c4 10             	add    $0x10,%esp
80106017:	85 c0                	test   %eax,%eax
80106019:	0f 88 7a 01 00 00    	js     80106199 <sys_unlink+0x199>
  begin_op();
8010601f:	e8 dc d1 ff ff       	call   80103200 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106024:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80106027:	83 ec 08             	sub    $0x8,%esp
8010602a:	53                   	push   %ebx
8010602b:	ff 75 c0             	push   -0x40(%ebp)
8010602e:	e8 2d c5 ff ff       	call   80102560 <nameiparent>
80106033:	83 c4 10             	add    $0x10,%esp
80106036:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80106039:	85 c0                	test   %eax,%eax
8010603b:	0f 84 62 01 00 00    	je     801061a3 <sys_unlink+0x1a3>
  ilock(dp);
80106041:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80106044:	83 ec 0c             	sub    $0xc,%esp
80106047:	57                   	push   %edi
80106048:	e8 d3 bb ff ff       	call   80101c20 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010604d:	58                   	pop    %eax
8010604e:	5a                   	pop    %edx
8010604f:	68 30 8b 10 80       	push   $0x80108b30
80106054:	53                   	push   %ebx
80106055:	e8 06 c1 ff ff       	call   80102160 <namecmp>
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	85 c0                	test   %eax,%eax
8010605f:	0f 84 fb 00 00 00    	je     80106160 <sys_unlink+0x160>
80106065:	83 ec 08             	sub    $0x8,%esp
80106068:	68 2f 8b 10 80       	push   $0x80108b2f
8010606d:	53                   	push   %ebx
8010606e:	e8 ed c0 ff ff       	call   80102160 <namecmp>
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	85 c0                	test   %eax,%eax
80106078:	0f 84 e2 00 00 00    	je     80106160 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010607e:	83 ec 04             	sub    $0x4,%esp
80106081:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106084:	50                   	push   %eax
80106085:	53                   	push   %ebx
80106086:	57                   	push   %edi
80106087:	e8 f4 c0 ff ff       	call   80102180 <dirlookup>
8010608c:	83 c4 10             	add    $0x10,%esp
8010608f:	89 c3                	mov    %eax,%ebx
80106091:	85 c0                	test   %eax,%eax
80106093:	0f 84 c7 00 00 00    	je     80106160 <sys_unlink+0x160>
  ilock(ip);
80106099:	83 ec 0c             	sub    $0xc,%esp
8010609c:	50                   	push   %eax
8010609d:	e8 7e bb ff ff       	call   80101c20 <ilock>
  if(ip->nlink < 1)
801060a2:	83 c4 10             	add    $0x10,%esp
801060a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801060aa:	0f 8e 1c 01 00 00    	jle    801061cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801060b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801060b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801060b8:	74 66                	je     80106120 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801060ba:	83 ec 04             	sub    $0x4,%esp
801060bd:	6a 10                	push   $0x10
801060bf:	6a 00                	push   $0x0
801060c1:	57                   	push   %edi
801060c2:	e8 89 f5 ff ff       	call   80105650 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801060c7:	6a 10                	push   $0x10
801060c9:	ff 75 c4             	push   -0x3c(%ebp)
801060cc:	57                   	push   %edi
801060cd:	ff 75 b4             	push   -0x4c(%ebp)
801060d0:	e8 5b bf ff ff       	call   80102030 <writei>
801060d5:	83 c4 20             	add    $0x20,%esp
801060d8:	83 f8 10             	cmp    $0x10,%eax
801060db:	0f 85 de 00 00 00    	jne    801061bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801060e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801060e6:	0f 84 94 00 00 00    	je     80106180 <sys_unlink+0x180>
  iunlockput(dp);
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	ff 75 b4             	push   -0x4c(%ebp)
801060f2:	e8 b9 bd ff ff       	call   80101eb0 <iunlockput>
  ip->nlink--;
801060f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801060fc:	89 1c 24             	mov    %ebx,(%esp)
801060ff:	e8 6c ba ff ff       	call   80101b70 <iupdate>
  iunlockput(ip);
80106104:	89 1c 24             	mov    %ebx,(%esp)
80106107:	e8 a4 bd ff ff       	call   80101eb0 <iunlockput>
  end_op();
8010610c:	e8 5f d1 ff ff       	call   80103270 <end_op>
  return 0;
80106111:	83 c4 10             	add    $0x10,%esp
80106114:	31 c0                	xor    %eax,%eax
}
80106116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106119:	5b                   	pop    %ebx
8010611a:	5e                   	pop    %esi
8010611b:	5f                   	pop    %edi
8010611c:	5d                   	pop    %ebp
8010611d:	c3                   	ret    
8010611e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106120:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106124:	76 94                	jbe    801060ba <sys_unlink+0xba>
80106126:	be 20 00 00 00       	mov    $0x20,%esi
8010612b:	eb 0b                	jmp    80106138 <sys_unlink+0x138>
8010612d:	8d 76 00             	lea    0x0(%esi),%esi
80106130:	83 c6 10             	add    $0x10,%esi
80106133:	3b 73 58             	cmp    0x58(%ebx),%esi
80106136:	73 82                	jae    801060ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106138:	6a 10                	push   $0x10
8010613a:	56                   	push   %esi
8010613b:	57                   	push   %edi
8010613c:	53                   	push   %ebx
8010613d:	e8 ee bd ff ff       	call   80101f30 <readi>
80106142:	83 c4 10             	add    $0x10,%esp
80106145:	83 f8 10             	cmp    $0x10,%eax
80106148:	75 68                	jne    801061b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010614a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010614f:	74 df                	je     80106130 <sys_unlink+0x130>
    iunlockput(ip);
80106151:	83 ec 0c             	sub    $0xc,%esp
80106154:	53                   	push   %ebx
80106155:	e8 56 bd ff ff       	call   80101eb0 <iunlockput>
    goto bad;
8010615a:	83 c4 10             	add    $0x10,%esp
8010615d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80106160:	83 ec 0c             	sub    $0xc,%esp
80106163:	ff 75 b4             	push   -0x4c(%ebp)
80106166:	e8 45 bd ff ff       	call   80101eb0 <iunlockput>
  end_op();
8010616b:	e8 00 d1 ff ff       	call   80103270 <end_op>
  return -1;
80106170:	83 c4 10             	add    $0x10,%esp
80106173:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106178:	eb 9c                	jmp    80106116 <sys_unlink+0x116>
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80106180:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80106183:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106186:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010618b:	50                   	push   %eax
8010618c:	e8 df b9 ff ff       	call   80101b70 <iupdate>
80106191:	83 c4 10             	add    $0x10,%esp
80106194:	e9 53 ff ff ff       	jmp    801060ec <sys_unlink+0xec>
    return -1;
80106199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619e:	e9 73 ff ff ff       	jmp    80106116 <sys_unlink+0x116>
    end_op();
801061a3:	e8 c8 d0 ff ff       	call   80103270 <end_op>
    return -1;
801061a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ad:	e9 64 ff ff ff       	jmp    80106116 <sys_unlink+0x116>
      panic("isdirempty: readi");
801061b2:	83 ec 0c             	sub    $0xc,%esp
801061b5:	68 54 8b 10 80       	push   $0x80108b54
801061ba:	e8 c1 a1 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801061bf:	83 ec 0c             	sub    $0xc,%esp
801061c2:	68 66 8b 10 80       	push   $0x80108b66
801061c7:	e8 b4 a1 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801061cc:	83 ec 0c             	sub    $0xc,%esp
801061cf:	68 42 8b 10 80       	push   $0x80108b42
801061d4:	e8 a7 a1 ff ff       	call   80100380 <panic>
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061e0 <sys_open>:

int
sys_open(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801061e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801061e8:	53                   	push   %ebx
801061e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801061ec:	50                   	push   %eax
801061ed:	6a 00                	push   $0x0
801061ef:	e8 dc f7 ff ff       	call   801059d0 <argstr>
801061f4:	83 c4 10             	add    $0x10,%esp
801061f7:	85 c0                	test   %eax,%eax
801061f9:	0f 88 8e 00 00 00    	js     8010628d <sys_open+0xad>
801061ff:	83 ec 08             	sub    $0x8,%esp
80106202:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106205:	50                   	push   %eax
80106206:	6a 01                	push   $0x1
80106208:	e8 03 f7 ff ff       	call   80105910 <argint>
8010620d:	83 c4 10             	add    $0x10,%esp
80106210:	85 c0                	test   %eax,%eax
80106212:	78 79                	js     8010628d <sys_open+0xad>
    return -1;

  begin_op();
80106214:	e8 e7 cf ff ff       	call   80103200 <begin_op>

  if(omode & O_CREATE){
80106219:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010621d:	75 79                	jne    80106298 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010621f:	83 ec 0c             	sub    $0xc,%esp
80106222:	ff 75 e0             	push   -0x20(%ebp)
80106225:	e8 16 c3 ff ff       	call   80102540 <namei>
8010622a:	83 c4 10             	add    $0x10,%esp
8010622d:	89 c6                	mov    %eax,%esi
8010622f:	85 c0                	test   %eax,%eax
80106231:	0f 84 7e 00 00 00    	je     801062b5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106237:	83 ec 0c             	sub    $0xc,%esp
8010623a:	50                   	push   %eax
8010623b:	e8 e0 b9 ff ff       	call   80101c20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106240:	83 c4 10             	add    $0x10,%esp
80106243:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106248:	0f 84 c2 00 00 00    	je     80106310 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010624e:	e8 7d b0 ff ff       	call   801012d0 <filealloc>
80106253:	89 c7                	mov    %eax,%edi
80106255:	85 c0                	test   %eax,%eax
80106257:	74 23                	je     8010627c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106259:	e8 92 dc ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010625e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106260:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106264:	85 d2                	test   %edx,%edx
80106266:	74 60                	je     801062c8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106268:	83 c3 01             	add    $0x1,%ebx
8010626b:	83 fb 10             	cmp    $0x10,%ebx
8010626e:	75 f0                	jne    80106260 <sys_open+0x80>
    if(f)
      fileclose(f);
80106270:	83 ec 0c             	sub    $0xc,%esp
80106273:	57                   	push   %edi
80106274:	e8 17 b1 ff ff       	call   80101390 <fileclose>
80106279:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010627c:	83 ec 0c             	sub    $0xc,%esp
8010627f:	56                   	push   %esi
80106280:	e8 2b bc ff ff       	call   80101eb0 <iunlockput>
    end_op();
80106285:	e8 e6 cf ff ff       	call   80103270 <end_op>
    return -1;
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106292:	eb 6d                	jmp    80106301 <sys_open+0x121>
80106294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106298:	83 ec 0c             	sub    $0xc,%esp
8010629b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010629e:	31 c9                	xor    %ecx,%ecx
801062a0:	ba 02 00 00 00       	mov    $0x2,%edx
801062a5:	6a 00                	push   $0x0
801062a7:	e8 14 f8 ff ff       	call   80105ac0 <create>
    if(ip == 0){
801062ac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801062af:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801062b1:	85 c0                	test   %eax,%eax
801062b3:	75 99                	jne    8010624e <sys_open+0x6e>
      end_op();
801062b5:	e8 b6 cf ff ff       	call   80103270 <end_op>
      return -1;
801062ba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801062bf:	eb 40                	jmp    80106301 <sys_open+0x121>
801062c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801062c8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801062cb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801062cf:	56                   	push   %esi
801062d0:	e8 2b ba ff ff       	call   80101d00 <iunlock>
  end_op();
801062d5:	e8 96 cf ff ff       	call   80103270 <end_op>

  f->type = FD_INODE;
801062da:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801062e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801062e3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801062e6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801062e9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801062eb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801062f2:	f7 d0                	not    %eax
801062f4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801062f7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801062fa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801062fd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106304:	89 d8                	mov    %ebx,%eax
80106306:	5b                   	pop    %ebx
80106307:	5e                   	pop    %esi
80106308:	5f                   	pop    %edi
80106309:	5d                   	pop    %ebp
8010630a:	c3                   	ret    
8010630b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010630f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106313:	85 c9                	test   %ecx,%ecx
80106315:	0f 84 33 ff ff ff    	je     8010624e <sys_open+0x6e>
8010631b:	e9 5c ff ff ff       	jmp    8010627c <sys_open+0x9c>

80106320 <sys_mkdir>:

int
sys_mkdir(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106326:	e8 d5 ce ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010632b:	83 ec 08             	sub    $0x8,%esp
8010632e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106331:	50                   	push   %eax
80106332:	6a 00                	push   $0x0
80106334:	e8 97 f6 ff ff       	call   801059d0 <argstr>
80106339:	83 c4 10             	add    $0x10,%esp
8010633c:	85 c0                	test   %eax,%eax
8010633e:	78 30                	js     80106370 <sys_mkdir+0x50>
80106340:	83 ec 0c             	sub    $0xc,%esp
80106343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106346:	31 c9                	xor    %ecx,%ecx
80106348:	ba 01 00 00 00       	mov    $0x1,%edx
8010634d:	6a 00                	push   $0x0
8010634f:	e8 6c f7 ff ff       	call   80105ac0 <create>
80106354:	83 c4 10             	add    $0x10,%esp
80106357:	85 c0                	test   %eax,%eax
80106359:	74 15                	je     80106370 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010635b:	83 ec 0c             	sub    $0xc,%esp
8010635e:	50                   	push   %eax
8010635f:	e8 4c bb ff ff       	call   80101eb0 <iunlockput>
  end_op();
80106364:	e8 07 cf ff ff       	call   80103270 <end_op>
  return 0;
80106369:	83 c4 10             	add    $0x10,%esp
8010636c:	31 c0                	xor    %eax,%eax
}
8010636e:	c9                   	leave  
8010636f:	c3                   	ret    
    end_op();
80106370:	e8 fb ce ff ff       	call   80103270 <end_op>
    return -1;
80106375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010637a:	c9                   	leave  
8010637b:	c3                   	ret    
8010637c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106380 <sys_mknod>:

int
sys_mknod(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106386:	e8 75 ce ff ff       	call   80103200 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010638b:	83 ec 08             	sub    $0x8,%esp
8010638e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106391:	50                   	push   %eax
80106392:	6a 00                	push   $0x0
80106394:	e8 37 f6 ff ff       	call   801059d0 <argstr>
80106399:	83 c4 10             	add    $0x10,%esp
8010639c:	85 c0                	test   %eax,%eax
8010639e:	78 60                	js     80106400 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801063a0:	83 ec 08             	sub    $0x8,%esp
801063a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801063a6:	50                   	push   %eax
801063a7:	6a 01                	push   $0x1
801063a9:	e8 62 f5 ff ff       	call   80105910 <argint>
  if((argstr(0, &path)) < 0 ||
801063ae:	83 c4 10             	add    $0x10,%esp
801063b1:	85 c0                	test   %eax,%eax
801063b3:	78 4b                	js     80106400 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801063b5:	83 ec 08             	sub    $0x8,%esp
801063b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063bb:	50                   	push   %eax
801063bc:	6a 02                	push   $0x2
801063be:	e8 4d f5 ff ff       	call   80105910 <argint>
     argint(1, &major) < 0 ||
801063c3:	83 c4 10             	add    $0x10,%esp
801063c6:	85 c0                	test   %eax,%eax
801063c8:	78 36                	js     80106400 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801063ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801063ce:	83 ec 0c             	sub    $0xc,%esp
801063d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801063d5:	ba 03 00 00 00       	mov    $0x3,%edx
801063da:	50                   	push   %eax
801063db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801063de:	e8 dd f6 ff ff       	call   80105ac0 <create>
     argint(2, &minor) < 0 ||
801063e3:	83 c4 10             	add    $0x10,%esp
801063e6:	85 c0                	test   %eax,%eax
801063e8:	74 16                	je     80106400 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801063ea:	83 ec 0c             	sub    $0xc,%esp
801063ed:	50                   	push   %eax
801063ee:	e8 bd ba ff ff       	call   80101eb0 <iunlockput>
  end_op();
801063f3:	e8 78 ce ff ff       	call   80103270 <end_op>
  return 0;
801063f8:	83 c4 10             	add    $0x10,%esp
801063fb:	31 c0                	xor    %eax,%eax
}
801063fd:	c9                   	leave  
801063fe:	c3                   	ret    
801063ff:	90                   	nop
    end_op();
80106400:	e8 6b ce ff ff       	call   80103270 <end_op>
    return -1;
80106405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010640a:	c9                   	leave  
8010640b:	c3                   	ret    
8010640c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106410 <sys_chdir>:

int
sys_chdir(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	56                   	push   %esi
80106414:	53                   	push   %ebx
80106415:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106418:	e8 d3 da ff ff       	call   80103ef0 <myproc>
8010641d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010641f:	e8 dc cd ff ff       	call   80103200 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106424:	83 ec 08             	sub    $0x8,%esp
80106427:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010642a:	50                   	push   %eax
8010642b:	6a 00                	push   $0x0
8010642d:	e8 9e f5 ff ff       	call   801059d0 <argstr>
80106432:	83 c4 10             	add    $0x10,%esp
80106435:	85 c0                	test   %eax,%eax
80106437:	78 77                	js     801064b0 <sys_chdir+0xa0>
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	ff 75 f4             	push   -0xc(%ebp)
8010643f:	e8 fc c0 ff ff       	call   80102540 <namei>
80106444:	83 c4 10             	add    $0x10,%esp
80106447:	89 c3                	mov    %eax,%ebx
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 63                	je     801064b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	50                   	push   %eax
80106451:	e8 ca b7 ff ff       	call   80101c20 <ilock>
  if(ip->type != T_DIR){
80106456:	83 c4 10             	add    $0x10,%esp
80106459:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010645e:	75 30                	jne    80106490 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106460:	83 ec 0c             	sub    $0xc,%esp
80106463:	53                   	push   %ebx
80106464:	e8 97 b8 ff ff       	call   80101d00 <iunlock>
  iput(curproc->cwd);
80106469:	58                   	pop    %eax
8010646a:	ff 76 68             	push   0x68(%esi)
8010646d:	e8 de b8 ff ff       	call   80101d50 <iput>
  end_op();
80106472:	e8 f9 cd ff ff       	call   80103270 <end_op>
  curproc->cwd = ip;
80106477:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010647a:	83 c4 10             	add    $0x10,%esp
8010647d:	31 c0                	xor    %eax,%eax
}
8010647f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106482:	5b                   	pop    %ebx
80106483:	5e                   	pop    %esi
80106484:	5d                   	pop    %ebp
80106485:	c3                   	ret    
80106486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010648d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106490:	83 ec 0c             	sub    $0xc,%esp
80106493:	53                   	push   %ebx
80106494:	e8 17 ba ff ff       	call   80101eb0 <iunlockput>
    end_op();
80106499:	e8 d2 cd ff ff       	call   80103270 <end_op>
    return -1;
8010649e:	83 c4 10             	add    $0x10,%esp
801064a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064a6:	eb d7                	jmp    8010647f <sys_chdir+0x6f>
801064a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064af:	90                   	nop
    end_op();
801064b0:	e8 bb cd ff ff       	call   80103270 <end_op>
    return -1;
801064b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ba:	eb c3                	jmp    8010647f <sys_chdir+0x6f>
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064c0 <sys_exec>:

int
sys_exec(void)
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
801064c3:	57                   	push   %edi
801064c4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801064c5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801064cb:	53                   	push   %ebx
801064cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801064d2:	50                   	push   %eax
801064d3:	6a 00                	push   $0x0
801064d5:	e8 f6 f4 ff ff       	call   801059d0 <argstr>
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	85 c0                	test   %eax,%eax
801064df:	0f 88 87 00 00 00    	js     8010656c <sys_exec+0xac>
801064e5:	83 ec 08             	sub    $0x8,%esp
801064e8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801064ee:	50                   	push   %eax
801064ef:	6a 01                	push   $0x1
801064f1:	e8 1a f4 ff ff       	call   80105910 <argint>
801064f6:	83 c4 10             	add    $0x10,%esp
801064f9:	85 c0                	test   %eax,%eax
801064fb:	78 6f                	js     8010656c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801064fd:	83 ec 04             	sub    $0x4,%esp
80106500:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80106506:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106508:	68 80 00 00 00       	push   $0x80
8010650d:	6a 00                	push   $0x0
8010650f:	56                   	push   %esi
80106510:	e8 3b f1 ff ff       	call   80105650 <memset>
80106515:	83 c4 10             	add    $0x10,%esp
80106518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010651f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106520:	83 ec 08             	sub    $0x8,%esp
80106523:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80106529:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80106530:	50                   	push   %eax
80106531:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106537:	01 f8                	add    %edi,%eax
80106539:	50                   	push   %eax
8010653a:	e8 41 f3 ff ff       	call   80105880 <fetchint>
8010653f:	83 c4 10             	add    $0x10,%esp
80106542:	85 c0                	test   %eax,%eax
80106544:	78 26                	js     8010656c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80106546:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010654c:	85 c0                	test   %eax,%eax
8010654e:	74 30                	je     80106580 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106550:	83 ec 08             	sub    $0x8,%esp
80106553:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80106556:	52                   	push   %edx
80106557:	50                   	push   %eax
80106558:	e8 63 f3 ff ff       	call   801058c0 <fetchstr>
8010655d:	83 c4 10             	add    $0x10,%esp
80106560:	85 c0                	test   %eax,%eax
80106562:	78 08                	js     8010656c <sys_exec+0xac>
  for(i=0;; i++){
80106564:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106567:	83 fb 20             	cmp    $0x20,%ebx
8010656a:	75 b4                	jne    80106520 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010656c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010656f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106574:	5b                   	pop    %ebx
80106575:	5e                   	pop    %esi
80106576:	5f                   	pop    %edi
80106577:	5d                   	pop    %ebp
80106578:	c3                   	ret    
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80106580:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106587:	00 00 00 00 
  return exec(path, argv);
8010658b:	83 ec 08             	sub    $0x8,%esp
8010658e:	56                   	push   %esi
8010658f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80106595:	e8 b6 a9 ff ff       	call   80100f50 <exec>
8010659a:	83 c4 10             	add    $0x10,%esp
}
8010659d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a0:	5b                   	pop    %ebx
801065a1:	5e                   	pop    %esi
801065a2:	5f                   	pop    %edi
801065a3:	5d                   	pop    %ebp
801065a4:	c3                   	ret    
801065a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065b0 <sys_pipe>:

int
sys_pipe(void)
{
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	57                   	push   %edi
801065b4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801065b5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801065b8:	53                   	push   %ebx
801065b9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801065bc:	6a 08                	push   $0x8
801065be:	50                   	push   %eax
801065bf:	6a 00                	push   $0x0
801065c1:	e8 9a f3 ff ff       	call   80105960 <argptr>
801065c6:	83 c4 10             	add    $0x10,%esp
801065c9:	85 c0                	test   %eax,%eax
801065cb:	78 4a                	js     80106617 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801065cd:	83 ec 08             	sub    $0x8,%esp
801065d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801065d3:	50                   	push   %eax
801065d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801065d7:	50                   	push   %eax
801065d8:	e8 f3 d2 ff ff       	call   801038d0 <pipealloc>
801065dd:	83 c4 10             	add    $0x10,%esp
801065e0:	85 c0                	test   %eax,%eax
801065e2:	78 33                	js     80106617 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801065e4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801065e7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801065e9:	e8 02 d9 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801065ee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801065f0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801065f4:	85 f6                	test   %esi,%esi
801065f6:	74 28                	je     80106620 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
801065f8:	83 c3 01             	add    $0x1,%ebx
801065fb:	83 fb 10             	cmp    $0x10,%ebx
801065fe:	75 f0                	jne    801065f0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106600:	83 ec 0c             	sub    $0xc,%esp
80106603:	ff 75 e0             	push   -0x20(%ebp)
80106606:	e8 85 ad ff ff       	call   80101390 <fileclose>
    fileclose(wf);
8010660b:	58                   	pop    %eax
8010660c:	ff 75 e4             	push   -0x1c(%ebp)
8010660f:	e8 7c ad ff ff       	call   80101390 <fileclose>
    return -1;
80106614:	83 c4 10             	add    $0x10,%esp
80106617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010661c:	eb 53                	jmp    80106671 <sys_pipe+0xc1>
8010661e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106620:	8d 73 08             	lea    0x8(%ebx),%esi
80106623:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106627:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010662a:	e8 c1 d8 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010662f:	31 d2                	xor    %edx,%edx
80106631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106638:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010663c:	85 c9                	test   %ecx,%ecx
8010663e:	74 20                	je     80106660 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80106640:	83 c2 01             	add    $0x1,%edx
80106643:	83 fa 10             	cmp    $0x10,%edx
80106646:	75 f0                	jne    80106638 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80106648:	e8 a3 d8 ff ff       	call   80103ef0 <myproc>
8010664d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106654:	00 
80106655:	eb a9                	jmp    80106600 <sys_pipe+0x50>
80106657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106660:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106664:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106667:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106669:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010666c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010666f:	31 c0                	xor    %eax,%eax
}
80106671:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106674:	5b                   	pop    %ebx
80106675:	5e                   	pop    %esi
80106676:	5f                   	pop    %edi
80106677:	5d                   	pop    %ebp
80106678:	c3                   	ret    
80106679:	66 90                	xchg   %ax,%ax
8010667b:	66 90                	xchg   %ax,%ax
8010667d:	66 90                	xchg   %ax,%ax
8010667f:	90                   	nop

80106680 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80106680:	e9 0b da ff ff       	jmp    80104090 <fork>
80106685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010668c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106690 <sys_exit>:
}

int
sys_exit(void)
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	83 ec 08             	sub    $0x8,%esp
  exit();
80106696:	e8 05 df ff ff       	call   801045a0 <exit>
  return 0;  // not reached
}
8010669b:	31 c0                	xor    %eax,%eax
8010669d:	c9                   	leave  
8010669e:	c3                   	ret    
8010669f:	90                   	nop

801066a0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801066a0:	e9 2b e0 ff ff       	jmp    801046d0 <wait>
801066a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801066b0 <sys_kill>:
}

int
sys_kill(void)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801066b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066b9:	50                   	push   %eax
801066ba:	6a 00                	push   $0x0
801066bc:	e8 4f f2 ff ff       	call   80105910 <argint>
801066c1:	83 c4 10             	add    $0x10,%esp
801066c4:	85 c0                	test   %eax,%eax
801066c6:	78 18                	js     801066e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801066c8:	83 ec 0c             	sub    $0xc,%esp
801066cb:	ff 75 f4             	push   -0xc(%ebp)
801066ce:	e8 9d e2 ff ff       	call   80104970 <kill>
801066d3:	83 c4 10             	add    $0x10,%esp
}
801066d6:	c9                   	leave  
801066d7:	c3                   	ret    
801066d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066df:	90                   	nop
801066e0:	c9                   	leave  
    return -1;
801066e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066e6:	c3                   	ret    
801066e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ee:	66 90                	xchg   %ax,%ax

801066f0 <sys_getpid>:

int
sys_getpid(void)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801066f6:	e8 f5 d7 ff ff       	call   80103ef0 <myproc>
801066fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801066fe:	c9                   	leave  
801066ff:	c3                   	ret    

80106700 <sys_sbrk>:

int
sys_sbrk(void)
{
80106700:	55                   	push   %ebp
80106701:	89 e5                	mov    %esp,%ebp
80106703:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106704:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106707:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010670a:	50                   	push   %eax
8010670b:	6a 00                	push   $0x0
8010670d:	e8 fe f1 ff ff       	call   80105910 <argint>
80106712:	83 c4 10             	add    $0x10,%esp
80106715:	85 c0                	test   %eax,%eax
80106717:	78 27                	js     80106740 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106719:	e8 d2 d7 ff ff       	call   80103ef0 <myproc>
  if(growproc(n) < 0)
8010671e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106721:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106723:	ff 75 f4             	push   -0xc(%ebp)
80106726:	e8 e5 d8 ff ff       	call   80104010 <growproc>
8010672b:	83 c4 10             	add    $0x10,%esp
8010672e:	85 c0                	test   %eax,%eax
80106730:	78 0e                	js     80106740 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106732:	89 d8                	mov    %ebx,%eax
80106734:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106737:	c9                   	leave  
80106738:	c3                   	ret    
80106739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106740:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106745:	eb eb                	jmp    80106732 <sys_sbrk+0x32>
80106747:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010674e:	66 90                	xchg   %ax,%ax

80106750 <sys_sleep>:

int
sys_sleep(void)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106754:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106757:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010675a:	50                   	push   %eax
8010675b:	6a 00                	push   $0x0
8010675d:	e8 ae f1 ff ff       	call   80105910 <argint>
80106762:	83 c4 10             	add    $0x10,%esp
80106765:	85 c0                	test   %eax,%eax
80106767:	0f 88 8a 00 00 00    	js     801067f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010676d:	83 ec 0c             	sub    $0xc,%esp
80106770:	68 00 50 11 80       	push   $0x80115000
80106775:	e8 16 ee ff ff       	call   80105590 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010677a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010677d:	8b 1d e0 4f 11 80    	mov    0x80114fe0,%ebx
  while(ticks - ticks0 < n){
80106783:	83 c4 10             	add    $0x10,%esp
80106786:	85 d2                	test   %edx,%edx
80106788:	75 27                	jne    801067b1 <sys_sleep+0x61>
8010678a:	eb 54                	jmp    801067e0 <sys_sleep+0x90>
8010678c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106790:	83 ec 08             	sub    $0x8,%esp
80106793:	68 00 50 11 80       	push   $0x80115000
80106798:	68 e0 4f 11 80       	push   $0x80114fe0
8010679d:	e8 ae e0 ff ff       	call   80104850 <sleep>
  while(ticks - ticks0 < n){
801067a2:	a1 e0 4f 11 80       	mov    0x80114fe0,%eax
801067a7:	83 c4 10             	add    $0x10,%esp
801067aa:	29 d8                	sub    %ebx,%eax
801067ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801067af:	73 2f                	jae    801067e0 <sys_sleep+0x90>
    if(myproc()->killed){
801067b1:	e8 3a d7 ff ff       	call   80103ef0 <myproc>
801067b6:	8b 40 24             	mov    0x24(%eax),%eax
801067b9:	85 c0                	test   %eax,%eax
801067bb:	74 d3                	je     80106790 <sys_sleep+0x40>
      release(&tickslock);
801067bd:	83 ec 0c             	sub    $0xc,%esp
801067c0:	68 00 50 11 80       	push   $0x80115000
801067c5:	e8 66 ed ff ff       	call   80105530 <release>
  }
  release(&tickslock);
  return 0;
}
801067ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801067cd:	83 c4 10             	add    $0x10,%esp
801067d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067d5:	c9                   	leave  
801067d6:	c3                   	ret    
801067d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067de:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801067e0:	83 ec 0c             	sub    $0xc,%esp
801067e3:	68 00 50 11 80       	push   $0x80115000
801067e8:	e8 43 ed ff ff       	call   80105530 <release>
  return 0;
801067ed:	83 c4 10             	add    $0x10,%esp
801067f0:	31 c0                	xor    %eax,%eax
}
801067f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067f5:	c9                   	leave  
801067f6:	c3                   	ret    
    return -1;
801067f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067fc:	eb f4                	jmp    801067f2 <sys_sleep+0xa2>
801067fe:	66 90                	xchg   %ax,%ax

80106800 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	53                   	push   %ebx
80106804:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106807:	68 00 50 11 80       	push   $0x80115000
8010680c:	e8 7f ed ff ff       	call   80105590 <acquire>
  xticks = ticks;
80106811:	8b 1d e0 4f 11 80    	mov    0x80114fe0,%ebx
  release(&tickslock);
80106817:	c7 04 24 00 50 11 80 	movl   $0x80115000,(%esp)
8010681e:	e8 0d ed ff ff       	call   80105530 <release>
  return xticks;
}
80106823:	89 d8                	mov    %ebx,%eax
80106825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106828:	c9                   	leave  
80106829:	c3                   	ret    
8010682a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106830 <sys_find_fibonacci_number>:

// system call to find the nth fibonacci number:

int sys_find_fibonacci_number(void){
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	53                   	push   %ebx
80106834:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
80106837:	e8 b4 d6 ff ff       	call   80103ef0 <myproc>
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
8010683c:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
8010683f:	8b 40 18             	mov    0x18(%eax),%eax
80106842:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("Kernel: sys_find_fibonacci_number(%d) is called\n", n);
80106845:	53                   	push   %ebx
80106846:	68 78 8b 10 80       	push   $0x80108b78
8010684b:	e8 a0 9e ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling find_fibonacci_number(%d)\n", n);
80106850:	58                   	pop    %eax
80106851:	5a                   	pop    %edx
80106852:	53                   	push   %ebx
80106853:	68 ac 8b 10 80       	push   $0x80108bac
80106858:	e8 93 9e ff ff       	call   801006f0 <cprintf>
  return find_fibonacci_number(n);
8010685d:	89 1c 24             	mov    %ebx,(%esp)
80106860:	e8 4b e2 ff ff       	call   80104ab0 <find_fibonacci_number>
}
80106865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106868:	c9                   	leave  
80106869:	c3                   	ret    
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <sys_find_most_callee>:

// system call to find the most used system call:

int sys_find_most_callee(void){
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_find_most_callee is called\n");
80106876:	68 dc 8b 10 80       	push   $0x80108bdc
8010687b:	e8 70 9e ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling find_most_callee\n");
80106880:	c7 04 24 04 8c 10 80 	movl   $0x80108c04,(%esp)
80106887:	e8 64 9e ff ff       	call   801006f0 <cprintf>
  return find_most_callee();
8010688c:	83 c4 10             	add    $0x10,%esp
}
8010688f:	c9                   	leave  
  return find_most_callee();
80106890:	e9 ab e4 ff ff       	jmp    80104d40 <find_most_callee>
80106895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010689c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068a0 <sys_get_children_count>:

// system call to get children count of current process:

int sys_get_children_count(void){
801068a0:	55                   	push   %ebp
801068a1:	89 e5                	mov    %esp,%ebp
801068a3:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_get_children_count is called\n");
801068a6:	68 2c 8c 10 80       	push   $0x80108c2c
801068ab:	e8 40 9e ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling get_children_count\n");
801068b0:	c7 04 24 58 8c 10 80 	movl   $0x80108c58,(%esp)
801068b7:	e8 34 9e ff ff       	call   801006f0 <cprintf>
  return get_children_count();
801068bc:	83 c4 10             	add    $0x10,%esp
}
801068bf:	c9                   	leave  
  return get_children_count();
801068c0:	e9 ab e4 ff ff       	jmp    80104d70 <get_children_count>
801068c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801068d0 <sys_kill_first_child_process>:

// system call to kill the first child of a process:

int sys_kill_first_child_process(void){
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	83 ec 14             	sub    $0x14,%esp
  cprintf("Kernel: sys_kill_first_child_process is called\n");
801068d6:	68 80 8c 10 80       	push   $0x80108c80
801068db:	e8 10 9e ff ff       	call   801006f0 <cprintf>
  cprintf("        now calling kill_first_child_process\n");
801068e0:	c7 04 24 b0 8c 10 80 	movl   $0x80108cb0,(%esp)
801068e7:	e8 04 9e ff ff       	call   801006f0 <cprintf>
  return kill_first_child_process();
801068ec:	83 c4 10             	add    $0x10,%esp
}
801068ef:	c9                   	leave  
  return kill_first_child_process();
801068f0:	e9 eb e4 ff ff       	jmp    80104de0 <kill_first_child_process>
801068f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106900 <sys_set_proc_queue>:

void
sys_set_proc_queue(void)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	83 ec 20             	sub    $0x20,%esp
  int pid, queue;
  argint(0, &pid);
80106906:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106909:	50                   	push   %eax
8010690a:	6a 00                	push   $0x0
8010690c:	e8 ff ef ff ff       	call   80105910 <argint>
  argint(1, &queue);
80106911:	58                   	pop    %eax
80106912:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106915:	5a                   	pop    %edx
80106916:	50                   	push   %eax
80106917:	6a 01                	push   $0x1
80106919:	e8 f2 ef ff ff       	call   80105910 <argint>
  set_proc_queue(pid, queue);
8010691e:	59                   	pop    %ecx
8010691f:	58                   	pop    %eax
80106920:	ff 75 f4             	push   -0xc(%ebp)
80106923:	ff 75 f0             	push   -0x10(%ebp)
80106926:	e8 25 e5 ff ff       	call   80104e50 <set_proc_queue>
}
8010692b:	83 c4 10             	add    $0x10,%esp
8010692e:	c9                   	leave  
8010692f:	c3                   	ret    

80106930 <sys_set_lottery_params>:

void
sys_set_lottery_params(void)
{
80106930:	55                   	push   %ebp
80106931:	89 e5                	mov    %esp,%ebp
80106933:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket_chance;
  argint(0, &pid);
80106936:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106939:	50                   	push   %eax
8010693a:	6a 00                	push   $0x0
8010693c:	e8 cf ef ff ff       	call   80105910 <argint>
  argint(1, &ticket_chance);
80106941:	58                   	pop    %eax
80106942:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106945:	5a                   	pop    %edx
80106946:	50                   	push   %eax
80106947:	6a 01                	push   $0x1
80106949:	e8 c2 ef ff ff       	call   80105910 <argint>
  set_lottery_params(pid, ticket_chance);
8010694e:	59                   	pop    %ecx
8010694f:	58                   	pop    %eax
80106950:	ff 75 f4             	push   -0xc(%ebp)
80106953:	ff 75 f0             	push   -0x10(%ebp)
80106956:	e8 45 e5 ff ff       	call   80104ea0 <set_lottery_params>
}
8010695b:	83 c4 10             	add    $0x10,%esp
8010695e:	c9                   	leave  
8010695f:	c3                   	ret    

80106960 <sys_print_all_procs>:

void
sys_print_all_procs(void)
{
  print_all_procs();
80106960:	e9 cb e5 ff ff       	jmp    80104f30 <print_all_procs>

80106965 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106965:	1e                   	push   %ds
  pushl %es
80106966:	06                   	push   %es
  pushl %fs
80106967:	0f a0                	push   %fs
  pushl %gs
80106969:	0f a8                	push   %gs
  pushal
8010696b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010696c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106970:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106972:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106974:	54                   	push   %esp
  call trap
80106975:	e8 c6 00 00 00       	call   80106a40 <trap>
  addl $4, %esp
8010697a:	83 c4 04             	add    $0x4,%esp

8010697d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010697d:	61                   	popa   
  popl %gs
8010697e:	0f a9                	pop    %gs
  popl %fs
80106980:	0f a1                	pop    %fs
  popl %es
80106982:	07                   	pop    %es
  popl %ds
80106983:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106984:	83 c4 08             	add    $0x8,%esp
  iret
80106987:	cf                   	iret   
80106988:	66 90                	xchg   %ax,%ax
8010698a:	66 90                	xchg   %ax,%ax
8010698c:	66 90                	xchg   %ax,%ax
8010698e:	66 90                	xchg   %ax,%ax

80106990 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106990:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106991:	31 c0                	xor    %eax,%eax
{
80106993:	89 e5                	mov    %esp,%ebp
80106995:	83 ec 08             	sub    $0x8,%esp
80106998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801069a0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801069a7:	c7 04 c5 42 50 11 80 	movl   $0x8e000008,-0x7feeafbe(,%eax,8)
801069ae:	08 00 00 8e 
801069b2:	66 89 14 c5 40 50 11 	mov    %dx,-0x7feeafc0(,%eax,8)
801069b9:	80 
801069ba:	c1 ea 10             	shr    $0x10,%edx
801069bd:	66 89 14 c5 46 50 11 	mov    %dx,-0x7feeafba(,%eax,8)
801069c4:	80 
  for(i = 0; i < 256; i++)
801069c5:	83 c0 01             	add    $0x1,%eax
801069c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801069cd:	75 d1                	jne    801069a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801069cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069d2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
801069d7:	c7 05 42 52 11 80 08 	movl   $0xef000008,0x80115242
801069de:	00 00 ef 
  initlock(&tickslock, "time");
801069e1:	68 de 8c 10 80       	push   $0x80108cde
801069e6:	68 00 50 11 80       	push   $0x80115000
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801069eb:	66 a3 40 52 11 80    	mov    %ax,0x80115240
801069f1:	c1 e8 10             	shr    $0x10,%eax
801069f4:	66 a3 46 52 11 80    	mov    %ax,0x80115246
  initlock(&tickslock, "time");
801069fa:	e8 c1 e9 ff ff       	call   801053c0 <initlock>
}
801069ff:	83 c4 10             	add    $0x10,%esp
80106a02:	c9                   	leave  
80106a03:	c3                   	ret    
80106a04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a0f:	90                   	nop

80106a10 <idtinit>:

void
idtinit(void)
{
80106a10:	55                   	push   %ebp
  pd[0] = size-1;
80106a11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106a16:	89 e5                	mov    %esp,%ebp
80106a18:	83 ec 10             	sub    $0x10,%esp
80106a1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106a1f:	b8 40 50 11 80       	mov    $0x80115040,%eax
80106a24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106a28:	c1 e8 10             	shr    $0x10,%eax
80106a2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106a2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106a32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106a35:	c9                   	leave  
80106a36:	c3                   	ret    
80106a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a3e:	66 90                	xchg   %ax,%ax

80106a40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106a40:	55                   	push   %ebp
80106a41:	89 e5                	mov    %esp,%ebp
80106a43:	57                   	push   %edi
80106a44:	56                   	push   %esi
80106a45:	53                   	push   %ebx
80106a46:	83 ec 1c             	sub    $0x1c,%esp
80106a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106a4c:	8b 43 30             	mov    0x30(%ebx),%eax
80106a4f:	83 f8 40             	cmp    $0x40,%eax
80106a52:	0f 84 68 01 00 00    	je     80106bc0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106a58:	83 e8 20             	sub    $0x20,%eax
80106a5b:	83 f8 1f             	cmp    $0x1f,%eax
80106a5e:	0f 87 8c 00 00 00    	ja     80106af0 <trap+0xb0>
80106a64:	ff 24 85 84 8d 10 80 	jmp    *-0x7fef727c(,%eax,4)
80106a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a6f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106a70:	e8 6b bc ff ff       	call   801026e0 <ideintr>
    lapiceoi();
80106a75:	e8 36 c3 ff ff       	call   80102db0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a7a:	e8 71 d4 ff ff       	call   80103ef0 <myproc>
80106a7f:	85 c0                	test   %eax,%eax
80106a81:	74 1d                	je     80106aa0 <trap+0x60>
80106a83:	e8 68 d4 ff ff       	call   80103ef0 <myproc>
80106a88:	8b 50 24             	mov    0x24(%eax),%edx
80106a8b:	85 d2                	test   %edx,%edx
80106a8d:	74 11                	je     80106aa0 <trap+0x60>
80106a8f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106a93:	83 e0 03             	and    $0x3,%eax
80106a96:	66 83 f8 03          	cmp    $0x3,%ax
80106a9a:	0f 84 e8 01 00 00    	je     80106c88 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106aa0:	e8 4b d4 ff ff       	call   80103ef0 <myproc>
80106aa5:	85 c0                	test   %eax,%eax
80106aa7:	74 0f                	je     80106ab8 <trap+0x78>
80106aa9:	e8 42 d4 ff ff       	call   80103ef0 <myproc>
80106aae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106ab2:	0f 84 b8 00 00 00    	je     80106b70 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ab8:	e8 33 d4 ff ff       	call   80103ef0 <myproc>
80106abd:	85 c0                	test   %eax,%eax
80106abf:	74 1d                	je     80106ade <trap+0x9e>
80106ac1:	e8 2a d4 ff ff       	call   80103ef0 <myproc>
80106ac6:	8b 40 24             	mov    0x24(%eax),%eax
80106ac9:	85 c0                	test   %eax,%eax
80106acb:	74 11                	je     80106ade <trap+0x9e>
80106acd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106ad1:	83 e0 03             	and    $0x3,%eax
80106ad4:	66 83 f8 03          	cmp    $0x3,%ax
80106ad8:	0f 84 0f 01 00 00    	je     80106bed <trap+0x1ad>
    exit();
}
80106ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ae1:	5b                   	pop    %ebx
80106ae2:	5e                   	pop    %esi
80106ae3:	5f                   	pop    %edi
80106ae4:	5d                   	pop    %ebp
80106ae5:	c3                   	ret    
80106ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106aed:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106af0:	e8 fb d3 ff ff       	call   80103ef0 <myproc>
80106af5:	8b 7b 38             	mov    0x38(%ebx),%edi
80106af8:	85 c0                	test   %eax,%eax
80106afa:	0f 84 a2 01 00 00    	je     80106ca2 <trap+0x262>
80106b00:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106b04:	0f 84 98 01 00 00    	je     80106ca2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106b0a:	0f 20 d1             	mov    %cr2,%ecx
80106b0d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b10:	e8 bb d3 ff ff       	call   80103ed0 <cpuid>
80106b15:	8b 73 30             	mov    0x30(%ebx),%esi
80106b18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b1b:	8b 43 34             	mov    0x34(%ebx),%eax
80106b1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106b21:	e8 ca d3 ff ff       	call   80103ef0 <myproc>
80106b26:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b29:	e8 c2 d3 ff ff       	call   80103ef0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b2e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106b31:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b34:	51                   	push   %ecx
80106b35:	57                   	push   %edi
80106b36:	52                   	push   %edx
80106b37:	ff 75 e4             	push   -0x1c(%ebp)
80106b3a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106b3b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80106b3e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106b41:	56                   	push   %esi
80106b42:	ff 70 10             	push   0x10(%eax)
80106b45:	68 40 8d 10 80       	push   $0x80108d40
80106b4a:	e8 a1 9b ff ff       	call   801006f0 <cprintf>
    myproc()->killed = 1;
80106b4f:	83 c4 20             	add    $0x20,%esp
80106b52:	e8 99 d3 ff ff       	call   80103ef0 <myproc>
80106b57:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b5e:	e8 8d d3 ff ff       	call   80103ef0 <myproc>
80106b63:	85 c0                	test   %eax,%eax
80106b65:	0f 85 18 ff ff ff    	jne    80106a83 <trap+0x43>
80106b6b:	e9 30 ff ff ff       	jmp    80106aa0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106b70:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106b74:	0f 85 3e ff ff ff    	jne    80106ab8 <trap+0x78>
    yield();
80106b7a:	e8 81 dc ff ff       	call   80104800 <yield>
80106b7f:	e9 34 ff ff ff       	jmp    80106ab8 <trap+0x78>
80106b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106b88:	8b 7b 38             	mov    0x38(%ebx),%edi
80106b8b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106b8f:	e8 3c d3 ff ff       	call   80103ed0 <cpuid>
80106b94:	57                   	push   %edi
80106b95:	56                   	push   %esi
80106b96:	50                   	push   %eax
80106b97:	68 e8 8c 10 80       	push   $0x80108ce8
80106b9c:	e8 4f 9b ff ff       	call   801006f0 <cprintf>
    lapiceoi();
80106ba1:	e8 0a c2 ff ff       	call   80102db0 <lapiceoi>
    break;
80106ba6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ba9:	e8 42 d3 ff ff       	call   80103ef0 <myproc>
80106bae:	85 c0                	test   %eax,%eax
80106bb0:	0f 85 cd fe ff ff    	jne    80106a83 <trap+0x43>
80106bb6:	e9 e5 fe ff ff       	jmp    80106aa0 <trap+0x60>
80106bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bbf:	90                   	nop
    if(myproc()->killed)
80106bc0:	e8 2b d3 ff ff       	call   80103ef0 <myproc>
80106bc5:	8b 70 24             	mov    0x24(%eax),%esi
80106bc8:	85 f6                	test   %esi,%esi
80106bca:	0f 85 c8 00 00 00    	jne    80106c98 <trap+0x258>
    myproc()->tf = tf;
80106bd0:	e8 1b d3 ff ff       	call   80103ef0 <myproc>
80106bd5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106bd8:	e8 73 ee ff ff       	call   80105a50 <syscall>
    if(myproc()->killed)
80106bdd:	e8 0e d3 ff ff       	call   80103ef0 <myproc>
80106be2:	8b 48 24             	mov    0x24(%eax),%ecx
80106be5:	85 c9                	test   %ecx,%ecx
80106be7:	0f 84 f1 fe ff ff    	je     80106ade <trap+0x9e>
}
80106bed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bf0:	5b                   	pop    %ebx
80106bf1:	5e                   	pop    %esi
80106bf2:	5f                   	pop    %edi
80106bf3:	5d                   	pop    %ebp
      exit();
80106bf4:	e9 a7 d9 ff ff       	jmp    801045a0 <exit>
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106c00:	e8 3b 02 00 00       	call   80106e40 <uartintr>
    lapiceoi();
80106c05:	e8 a6 c1 ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c0a:	e8 e1 d2 ff ff       	call   80103ef0 <myproc>
80106c0f:	85 c0                	test   %eax,%eax
80106c11:	0f 85 6c fe ff ff    	jne    80106a83 <trap+0x43>
80106c17:	e9 84 fe ff ff       	jmp    80106aa0 <trap+0x60>
80106c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106c20:	e8 4b c0 ff ff       	call   80102c70 <kbdintr>
    lapiceoi();
80106c25:	e8 86 c1 ff ff       	call   80102db0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106c2a:	e8 c1 d2 ff ff       	call   80103ef0 <myproc>
80106c2f:	85 c0                	test   %eax,%eax
80106c31:	0f 85 4c fe ff ff    	jne    80106a83 <trap+0x43>
80106c37:	e9 64 fe ff ff       	jmp    80106aa0 <trap+0x60>
80106c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106c40:	e8 8b d2 ff ff       	call   80103ed0 <cpuid>
80106c45:	85 c0                	test   %eax,%eax
80106c47:	0f 85 28 fe ff ff    	jne    80106a75 <trap+0x35>
      acquire(&tickslock);
80106c4d:	83 ec 0c             	sub    $0xc,%esp
80106c50:	68 00 50 11 80       	push   $0x80115000
80106c55:	e8 36 e9 ff ff       	call   80105590 <acquire>
      wakeup(&ticks);
80106c5a:	c7 04 24 e0 4f 11 80 	movl   $0x80114fe0,(%esp)
      ticks++;
80106c61:	83 05 e0 4f 11 80 01 	addl   $0x1,0x80114fe0
      wakeup(&ticks);
80106c68:	e8 a3 dc ff ff       	call   80104910 <wakeup>
      release(&tickslock);
80106c6d:	c7 04 24 00 50 11 80 	movl   $0x80115000,(%esp)
80106c74:	e8 b7 e8 ff ff       	call   80105530 <release>
80106c79:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106c7c:	e9 f4 fd ff ff       	jmp    80106a75 <trap+0x35>
80106c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106c88:	e8 13 d9 ff ff       	call   801045a0 <exit>
80106c8d:	e9 0e fe ff ff       	jmp    80106aa0 <trap+0x60>
80106c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106c98:	e8 03 d9 ff ff       	call   801045a0 <exit>
80106c9d:	e9 2e ff ff ff       	jmp    80106bd0 <trap+0x190>
80106ca2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106ca5:	e8 26 d2 ff ff       	call   80103ed0 <cpuid>
80106caa:	83 ec 0c             	sub    $0xc,%esp
80106cad:	56                   	push   %esi
80106cae:	57                   	push   %edi
80106caf:	50                   	push   %eax
80106cb0:	ff 73 30             	push   0x30(%ebx)
80106cb3:	68 0c 8d 10 80       	push   $0x80108d0c
80106cb8:	e8 33 9a ff ff       	call   801006f0 <cprintf>
      panic("trap");
80106cbd:	83 c4 14             	add    $0x14,%esp
80106cc0:	68 e3 8c 10 80       	push   $0x80108ce3
80106cc5:	e8 b6 96 ff ff       	call   80100380 <panic>
80106cca:	66 90                	xchg   %ax,%ax
80106ccc:	66 90                	xchg   %ax,%ax
80106cce:	66 90                	xchg   %ax,%ax

80106cd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106cd0:	a1 40 58 11 80       	mov    0x80115840,%eax
80106cd5:	85 c0                	test   %eax,%eax
80106cd7:	74 17                	je     80106cf0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106cd9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106cde:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106cdf:	a8 01                	test   $0x1,%al
80106ce1:	74 0d                	je     80106cf0 <uartgetc+0x20>
80106ce3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106ce8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106ce9:	0f b6 c0             	movzbl %al,%eax
80106cec:	c3                   	ret    
80106ced:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cf5:	c3                   	ret    
80106cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cfd:	8d 76 00             	lea    0x0(%esi),%esi

80106d00 <uartinit>:
{
80106d00:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d01:	31 c9                	xor    %ecx,%ecx
80106d03:	89 c8                	mov    %ecx,%eax
80106d05:	89 e5                	mov    %esp,%ebp
80106d07:	57                   	push   %edi
80106d08:	bf fa 03 00 00       	mov    $0x3fa,%edi
80106d0d:	56                   	push   %esi
80106d0e:	89 fa                	mov    %edi,%edx
80106d10:	53                   	push   %ebx
80106d11:	83 ec 1c             	sub    $0x1c,%esp
80106d14:	ee                   	out    %al,(%dx)
80106d15:	be fb 03 00 00       	mov    $0x3fb,%esi
80106d1a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106d1f:	89 f2                	mov    %esi,%edx
80106d21:	ee                   	out    %al,(%dx)
80106d22:	b8 0c 00 00 00       	mov    $0xc,%eax
80106d27:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d2c:	ee                   	out    %al,(%dx)
80106d2d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106d32:	89 c8                	mov    %ecx,%eax
80106d34:	89 da                	mov    %ebx,%edx
80106d36:	ee                   	out    %al,(%dx)
80106d37:	b8 03 00 00 00       	mov    $0x3,%eax
80106d3c:	89 f2                	mov    %esi,%edx
80106d3e:	ee                   	out    %al,(%dx)
80106d3f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106d44:	89 c8                	mov    %ecx,%eax
80106d46:	ee                   	out    %al,(%dx)
80106d47:	b8 01 00 00 00       	mov    $0x1,%eax
80106d4c:	89 da                	mov    %ebx,%edx
80106d4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d4f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106d54:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106d55:	3c ff                	cmp    $0xff,%al
80106d57:	74 78                	je     80106dd1 <uartinit+0xd1>
  uart = 1;
80106d59:	c7 05 40 58 11 80 01 	movl   $0x1,0x80115840
80106d60:	00 00 00 
80106d63:	89 fa                	mov    %edi,%edx
80106d65:	ec                   	in     (%dx),%al
80106d66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106d6b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106d6c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106d6f:	bf 04 8e 10 80       	mov    $0x80108e04,%edi
80106d74:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80106d79:	6a 00                	push   $0x0
80106d7b:	6a 04                	push   $0x4
80106d7d:	e8 9e bb ff ff       	call   80102920 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80106d82:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
80106d86:	83 c4 10             	add    $0x10,%esp
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106d90:	a1 40 58 11 80       	mov    0x80115840,%eax
80106d95:	bb 80 00 00 00       	mov    $0x80,%ebx
80106d9a:	85 c0                	test   %eax,%eax
80106d9c:	75 14                	jne    80106db2 <uartinit+0xb2>
80106d9e:	eb 23                	jmp    80106dc3 <uartinit+0xc3>
    microdelay(10);
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	6a 0a                	push   $0xa
80106da5:	e8 26 c0 ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106daa:	83 c4 10             	add    $0x10,%esp
80106dad:	83 eb 01             	sub    $0x1,%ebx
80106db0:	74 07                	je     80106db9 <uartinit+0xb9>
80106db2:	89 f2                	mov    %esi,%edx
80106db4:	ec                   	in     (%dx),%al
80106db5:	a8 20                	test   $0x20,%al
80106db7:	74 e7                	je     80106da0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106db9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80106dbd:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106dc2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106dc3:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106dc7:	83 c7 01             	add    $0x1,%edi
80106dca:	88 45 e7             	mov    %al,-0x19(%ebp)
80106dcd:	84 c0                	test   %al,%al
80106dcf:	75 bf                	jne    80106d90 <uartinit+0x90>
}
80106dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd4:	5b                   	pop    %ebx
80106dd5:	5e                   	pop    %esi
80106dd6:	5f                   	pop    %edi
80106dd7:	5d                   	pop    %ebp
80106dd8:	c3                   	ret    
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106de0 <uartputc>:
  if(!uart)
80106de0:	a1 40 58 11 80       	mov    0x80115840,%eax
80106de5:	85 c0                	test   %eax,%eax
80106de7:	74 47                	je     80106e30 <uartputc+0x50>
{
80106de9:	55                   	push   %ebp
80106dea:	89 e5                	mov    %esp,%ebp
80106dec:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106ded:	be fd 03 00 00       	mov    $0x3fd,%esi
80106df2:	53                   	push   %ebx
80106df3:	bb 80 00 00 00       	mov    $0x80,%ebx
80106df8:	eb 18                	jmp    80106e12 <uartputc+0x32>
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106e00:	83 ec 0c             	sub    $0xc,%esp
80106e03:	6a 0a                	push   $0xa
80106e05:	e8 c6 bf ff ff       	call   80102dd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106e0a:	83 c4 10             	add    $0x10,%esp
80106e0d:	83 eb 01             	sub    $0x1,%ebx
80106e10:	74 07                	je     80106e19 <uartputc+0x39>
80106e12:	89 f2                	mov    %esi,%edx
80106e14:	ec                   	in     (%dx),%al
80106e15:	a8 20                	test   $0x20,%al
80106e17:	74 e7                	je     80106e00 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e19:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106e21:	ee                   	out    %al,(%dx)
}
80106e22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5d                   	pop    %ebp
80106e28:	c3                   	ret    
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e30:	c3                   	ret    
80106e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop

80106e40 <uartintr>:

void
uartintr(void)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106e46:	68 d0 6c 10 80       	push   $0x80106cd0
80106e4b:	e8 e0 9d ff ff       	call   80100c30 <consoleintr>
}
80106e50:	83 c4 10             	add    $0x10,%esp
80106e53:	c9                   	leave  
80106e54:	c3                   	ret    

80106e55 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106e55:	6a 00                	push   $0x0
  pushl $0
80106e57:	6a 00                	push   $0x0
  jmp alltraps
80106e59:	e9 07 fb ff ff       	jmp    80106965 <alltraps>

80106e5e <vector1>:
.globl vector1
vector1:
  pushl $0
80106e5e:	6a 00                	push   $0x0
  pushl $1
80106e60:	6a 01                	push   $0x1
  jmp alltraps
80106e62:	e9 fe fa ff ff       	jmp    80106965 <alltraps>

80106e67 <vector2>:
.globl vector2
vector2:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $2
80106e69:	6a 02                	push   $0x2
  jmp alltraps
80106e6b:	e9 f5 fa ff ff       	jmp    80106965 <alltraps>

80106e70 <vector3>:
.globl vector3
vector3:
  pushl $0
80106e70:	6a 00                	push   $0x0
  pushl $3
80106e72:	6a 03                	push   $0x3
  jmp alltraps
80106e74:	e9 ec fa ff ff       	jmp    80106965 <alltraps>

80106e79 <vector4>:
.globl vector4
vector4:
  pushl $0
80106e79:	6a 00                	push   $0x0
  pushl $4
80106e7b:	6a 04                	push   $0x4
  jmp alltraps
80106e7d:	e9 e3 fa ff ff       	jmp    80106965 <alltraps>

80106e82 <vector5>:
.globl vector5
vector5:
  pushl $0
80106e82:	6a 00                	push   $0x0
  pushl $5
80106e84:	6a 05                	push   $0x5
  jmp alltraps
80106e86:	e9 da fa ff ff       	jmp    80106965 <alltraps>

80106e8b <vector6>:
.globl vector6
vector6:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $6
80106e8d:	6a 06                	push   $0x6
  jmp alltraps
80106e8f:	e9 d1 fa ff ff       	jmp    80106965 <alltraps>

80106e94 <vector7>:
.globl vector7
vector7:
  pushl $0
80106e94:	6a 00                	push   $0x0
  pushl $7
80106e96:	6a 07                	push   $0x7
  jmp alltraps
80106e98:	e9 c8 fa ff ff       	jmp    80106965 <alltraps>

80106e9d <vector8>:
.globl vector8
vector8:
  pushl $8
80106e9d:	6a 08                	push   $0x8
  jmp alltraps
80106e9f:	e9 c1 fa ff ff       	jmp    80106965 <alltraps>

80106ea4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $9
80106ea6:	6a 09                	push   $0x9
  jmp alltraps
80106ea8:	e9 b8 fa ff ff       	jmp    80106965 <alltraps>

80106ead <vector10>:
.globl vector10
vector10:
  pushl $10
80106ead:	6a 0a                	push   $0xa
  jmp alltraps
80106eaf:	e9 b1 fa ff ff       	jmp    80106965 <alltraps>

80106eb4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106eb4:	6a 0b                	push   $0xb
  jmp alltraps
80106eb6:	e9 aa fa ff ff       	jmp    80106965 <alltraps>

80106ebb <vector12>:
.globl vector12
vector12:
  pushl $12
80106ebb:	6a 0c                	push   $0xc
  jmp alltraps
80106ebd:	e9 a3 fa ff ff       	jmp    80106965 <alltraps>

80106ec2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ec2:	6a 0d                	push   $0xd
  jmp alltraps
80106ec4:	e9 9c fa ff ff       	jmp    80106965 <alltraps>

80106ec9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ec9:	6a 0e                	push   $0xe
  jmp alltraps
80106ecb:	e9 95 fa ff ff       	jmp    80106965 <alltraps>

80106ed0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $15
80106ed2:	6a 0f                	push   $0xf
  jmp alltraps
80106ed4:	e9 8c fa ff ff       	jmp    80106965 <alltraps>

80106ed9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $16
80106edb:	6a 10                	push   $0x10
  jmp alltraps
80106edd:	e9 83 fa ff ff       	jmp    80106965 <alltraps>

80106ee2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ee2:	6a 11                	push   $0x11
  jmp alltraps
80106ee4:	e9 7c fa ff ff       	jmp    80106965 <alltraps>

80106ee9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ee9:	6a 00                	push   $0x0
  pushl $18
80106eeb:	6a 12                	push   $0x12
  jmp alltraps
80106eed:	e9 73 fa ff ff       	jmp    80106965 <alltraps>

80106ef2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ef2:	6a 00                	push   $0x0
  pushl $19
80106ef4:	6a 13                	push   $0x13
  jmp alltraps
80106ef6:	e9 6a fa ff ff       	jmp    80106965 <alltraps>

80106efb <vector20>:
.globl vector20
vector20:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $20
80106efd:	6a 14                	push   $0x14
  jmp alltraps
80106eff:	e9 61 fa ff ff       	jmp    80106965 <alltraps>

80106f04 <vector21>:
.globl vector21
vector21:
  pushl $0
80106f04:	6a 00                	push   $0x0
  pushl $21
80106f06:	6a 15                	push   $0x15
  jmp alltraps
80106f08:	e9 58 fa ff ff       	jmp    80106965 <alltraps>

80106f0d <vector22>:
.globl vector22
vector22:
  pushl $0
80106f0d:	6a 00                	push   $0x0
  pushl $22
80106f0f:	6a 16                	push   $0x16
  jmp alltraps
80106f11:	e9 4f fa ff ff       	jmp    80106965 <alltraps>

80106f16 <vector23>:
.globl vector23
vector23:
  pushl $0
80106f16:	6a 00                	push   $0x0
  pushl $23
80106f18:	6a 17                	push   $0x17
  jmp alltraps
80106f1a:	e9 46 fa ff ff       	jmp    80106965 <alltraps>

80106f1f <vector24>:
.globl vector24
vector24:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $24
80106f21:	6a 18                	push   $0x18
  jmp alltraps
80106f23:	e9 3d fa ff ff       	jmp    80106965 <alltraps>

80106f28 <vector25>:
.globl vector25
vector25:
  pushl $0
80106f28:	6a 00                	push   $0x0
  pushl $25
80106f2a:	6a 19                	push   $0x19
  jmp alltraps
80106f2c:	e9 34 fa ff ff       	jmp    80106965 <alltraps>

80106f31 <vector26>:
.globl vector26
vector26:
  pushl $0
80106f31:	6a 00                	push   $0x0
  pushl $26
80106f33:	6a 1a                	push   $0x1a
  jmp alltraps
80106f35:	e9 2b fa ff ff       	jmp    80106965 <alltraps>

80106f3a <vector27>:
.globl vector27
vector27:
  pushl $0
80106f3a:	6a 00                	push   $0x0
  pushl $27
80106f3c:	6a 1b                	push   $0x1b
  jmp alltraps
80106f3e:	e9 22 fa ff ff       	jmp    80106965 <alltraps>

80106f43 <vector28>:
.globl vector28
vector28:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $28
80106f45:	6a 1c                	push   $0x1c
  jmp alltraps
80106f47:	e9 19 fa ff ff       	jmp    80106965 <alltraps>

80106f4c <vector29>:
.globl vector29
vector29:
  pushl $0
80106f4c:	6a 00                	push   $0x0
  pushl $29
80106f4e:	6a 1d                	push   $0x1d
  jmp alltraps
80106f50:	e9 10 fa ff ff       	jmp    80106965 <alltraps>

80106f55 <vector30>:
.globl vector30
vector30:
  pushl $0
80106f55:	6a 00                	push   $0x0
  pushl $30
80106f57:	6a 1e                	push   $0x1e
  jmp alltraps
80106f59:	e9 07 fa ff ff       	jmp    80106965 <alltraps>

80106f5e <vector31>:
.globl vector31
vector31:
  pushl $0
80106f5e:	6a 00                	push   $0x0
  pushl $31
80106f60:	6a 1f                	push   $0x1f
  jmp alltraps
80106f62:	e9 fe f9 ff ff       	jmp    80106965 <alltraps>

80106f67 <vector32>:
.globl vector32
vector32:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $32
80106f69:	6a 20                	push   $0x20
  jmp alltraps
80106f6b:	e9 f5 f9 ff ff       	jmp    80106965 <alltraps>

80106f70 <vector33>:
.globl vector33
vector33:
  pushl $0
80106f70:	6a 00                	push   $0x0
  pushl $33
80106f72:	6a 21                	push   $0x21
  jmp alltraps
80106f74:	e9 ec f9 ff ff       	jmp    80106965 <alltraps>

80106f79 <vector34>:
.globl vector34
vector34:
  pushl $0
80106f79:	6a 00                	push   $0x0
  pushl $34
80106f7b:	6a 22                	push   $0x22
  jmp alltraps
80106f7d:	e9 e3 f9 ff ff       	jmp    80106965 <alltraps>

80106f82 <vector35>:
.globl vector35
vector35:
  pushl $0
80106f82:	6a 00                	push   $0x0
  pushl $35
80106f84:	6a 23                	push   $0x23
  jmp alltraps
80106f86:	e9 da f9 ff ff       	jmp    80106965 <alltraps>

80106f8b <vector36>:
.globl vector36
vector36:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $36
80106f8d:	6a 24                	push   $0x24
  jmp alltraps
80106f8f:	e9 d1 f9 ff ff       	jmp    80106965 <alltraps>

80106f94 <vector37>:
.globl vector37
vector37:
  pushl $0
80106f94:	6a 00                	push   $0x0
  pushl $37
80106f96:	6a 25                	push   $0x25
  jmp alltraps
80106f98:	e9 c8 f9 ff ff       	jmp    80106965 <alltraps>

80106f9d <vector38>:
.globl vector38
vector38:
  pushl $0
80106f9d:	6a 00                	push   $0x0
  pushl $38
80106f9f:	6a 26                	push   $0x26
  jmp alltraps
80106fa1:	e9 bf f9 ff ff       	jmp    80106965 <alltraps>

80106fa6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $39
80106fa8:	6a 27                	push   $0x27
  jmp alltraps
80106faa:	e9 b6 f9 ff ff       	jmp    80106965 <alltraps>

80106faf <vector40>:
.globl vector40
vector40:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $40
80106fb1:	6a 28                	push   $0x28
  jmp alltraps
80106fb3:	e9 ad f9 ff ff       	jmp    80106965 <alltraps>

80106fb8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106fb8:	6a 00                	push   $0x0
  pushl $41
80106fba:	6a 29                	push   $0x29
  jmp alltraps
80106fbc:	e9 a4 f9 ff ff       	jmp    80106965 <alltraps>

80106fc1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106fc1:	6a 00                	push   $0x0
  pushl $42
80106fc3:	6a 2a                	push   $0x2a
  jmp alltraps
80106fc5:	e9 9b f9 ff ff       	jmp    80106965 <alltraps>

80106fca <vector43>:
.globl vector43
vector43:
  pushl $0
80106fca:	6a 00                	push   $0x0
  pushl $43
80106fcc:	6a 2b                	push   $0x2b
  jmp alltraps
80106fce:	e9 92 f9 ff ff       	jmp    80106965 <alltraps>

80106fd3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $44
80106fd5:	6a 2c                	push   $0x2c
  jmp alltraps
80106fd7:	e9 89 f9 ff ff       	jmp    80106965 <alltraps>

80106fdc <vector45>:
.globl vector45
vector45:
  pushl $0
80106fdc:	6a 00                	push   $0x0
  pushl $45
80106fde:	6a 2d                	push   $0x2d
  jmp alltraps
80106fe0:	e9 80 f9 ff ff       	jmp    80106965 <alltraps>

80106fe5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106fe5:	6a 00                	push   $0x0
  pushl $46
80106fe7:	6a 2e                	push   $0x2e
  jmp alltraps
80106fe9:	e9 77 f9 ff ff       	jmp    80106965 <alltraps>

80106fee <vector47>:
.globl vector47
vector47:
  pushl $0
80106fee:	6a 00                	push   $0x0
  pushl $47
80106ff0:	6a 2f                	push   $0x2f
  jmp alltraps
80106ff2:	e9 6e f9 ff ff       	jmp    80106965 <alltraps>

80106ff7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $48
80106ff9:	6a 30                	push   $0x30
  jmp alltraps
80106ffb:	e9 65 f9 ff ff       	jmp    80106965 <alltraps>

80107000 <vector49>:
.globl vector49
vector49:
  pushl $0
80107000:	6a 00                	push   $0x0
  pushl $49
80107002:	6a 31                	push   $0x31
  jmp alltraps
80107004:	e9 5c f9 ff ff       	jmp    80106965 <alltraps>

80107009 <vector50>:
.globl vector50
vector50:
  pushl $0
80107009:	6a 00                	push   $0x0
  pushl $50
8010700b:	6a 32                	push   $0x32
  jmp alltraps
8010700d:	e9 53 f9 ff ff       	jmp    80106965 <alltraps>

80107012 <vector51>:
.globl vector51
vector51:
  pushl $0
80107012:	6a 00                	push   $0x0
  pushl $51
80107014:	6a 33                	push   $0x33
  jmp alltraps
80107016:	e9 4a f9 ff ff       	jmp    80106965 <alltraps>

8010701b <vector52>:
.globl vector52
vector52:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $52
8010701d:	6a 34                	push   $0x34
  jmp alltraps
8010701f:	e9 41 f9 ff ff       	jmp    80106965 <alltraps>

80107024 <vector53>:
.globl vector53
vector53:
  pushl $0
80107024:	6a 00                	push   $0x0
  pushl $53
80107026:	6a 35                	push   $0x35
  jmp alltraps
80107028:	e9 38 f9 ff ff       	jmp    80106965 <alltraps>

8010702d <vector54>:
.globl vector54
vector54:
  pushl $0
8010702d:	6a 00                	push   $0x0
  pushl $54
8010702f:	6a 36                	push   $0x36
  jmp alltraps
80107031:	e9 2f f9 ff ff       	jmp    80106965 <alltraps>

80107036 <vector55>:
.globl vector55
vector55:
  pushl $0
80107036:	6a 00                	push   $0x0
  pushl $55
80107038:	6a 37                	push   $0x37
  jmp alltraps
8010703a:	e9 26 f9 ff ff       	jmp    80106965 <alltraps>

8010703f <vector56>:
.globl vector56
vector56:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $56
80107041:	6a 38                	push   $0x38
  jmp alltraps
80107043:	e9 1d f9 ff ff       	jmp    80106965 <alltraps>

80107048 <vector57>:
.globl vector57
vector57:
  pushl $0
80107048:	6a 00                	push   $0x0
  pushl $57
8010704a:	6a 39                	push   $0x39
  jmp alltraps
8010704c:	e9 14 f9 ff ff       	jmp    80106965 <alltraps>

80107051 <vector58>:
.globl vector58
vector58:
  pushl $0
80107051:	6a 00                	push   $0x0
  pushl $58
80107053:	6a 3a                	push   $0x3a
  jmp alltraps
80107055:	e9 0b f9 ff ff       	jmp    80106965 <alltraps>

8010705a <vector59>:
.globl vector59
vector59:
  pushl $0
8010705a:	6a 00                	push   $0x0
  pushl $59
8010705c:	6a 3b                	push   $0x3b
  jmp alltraps
8010705e:	e9 02 f9 ff ff       	jmp    80106965 <alltraps>

80107063 <vector60>:
.globl vector60
vector60:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $60
80107065:	6a 3c                	push   $0x3c
  jmp alltraps
80107067:	e9 f9 f8 ff ff       	jmp    80106965 <alltraps>

8010706c <vector61>:
.globl vector61
vector61:
  pushl $0
8010706c:	6a 00                	push   $0x0
  pushl $61
8010706e:	6a 3d                	push   $0x3d
  jmp alltraps
80107070:	e9 f0 f8 ff ff       	jmp    80106965 <alltraps>

80107075 <vector62>:
.globl vector62
vector62:
  pushl $0
80107075:	6a 00                	push   $0x0
  pushl $62
80107077:	6a 3e                	push   $0x3e
  jmp alltraps
80107079:	e9 e7 f8 ff ff       	jmp    80106965 <alltraps>

8010707e <vector63>:
.globl vector63
vector63:
  pushl $0
8010707e:	6a 00                	push   $0x0
  pushl $63
80107080:	6a 3f                	push   $0x3f
  jmp alltraps
80107082:	e9 de f8 ff ff       	jmp    80106965 <alltraps>

80107087 <vector64>:
.globl vector64
vector64:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $64
80107089:	6a 40                	push   $0x40
  jmp alltraps
8010708b:	e9 d5 f8 ff ff       	jmp    80106965 <alltraps>

80107090 <vector65>:
.globl vector65
vector65:
  pushl $0
80107090:	6a 00                	push   $0x0
  pushl $65
80107092:	6a 41                	push   $0x41
  jmp alltraps
80107094:	e9 cc f8 ff ff       	jmp    80106965 <alltraps>

80107099 <vector66>:
.globl vector66
vector66:
  pushl $0
80107099:	6a 00                	push   $0x0
  pushl $66
8010709b:	6a 42                	push   $0x42
  jmp alltraps
8010709d:	e9 c3 f8 ff ff       	jmp    80106965 <alltraps>

801070a2 <vector67>:
.globl vector67
vector67:
  pushl $0
801070a2:	6a 00                	push   $0x0
  pushl $67
801070a4:	6a 43                	push   $0x43
  jmp alltraps
801070a6:	e9 ba f8 ff ff       	jmp    80106965 <alltraps>

801070ab <vector68>:
.globl vector68
vector68:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $68
801070ad:	6a 44                	push   $0x44
  jmp alltraps
801070af:	e9 b1 f8 ff ff       	jmp    80106965 <alltraps>

801070b4 <vector69>:
.globl vector69
vector69:
  pushl $0
801070b4:	6a 00                	push   $0x0
  pushl $69
801070b6:	6a 45                	push   $0x45
  jmp alltraps
801070b8:	e9 a8 f8 ff ff       	jmp    80106965 <alltraps>

801070bd <vector70>:
.globl vector70
vector70:
  pushl $0
801070bd:	6a 00                	push   $0x0
  pushl $70
801070bf:	6a 46                	push   $0x46
  jmp alltraps
801070c1:	e9 9f f8 ff ff       	jmp    80106965 <alltraps>

801070c6 <vector71>:
.globl vector71
vector71:
  pushl $0
801070c6:	6a 00                	push   $0x0
  pushl $71
801070c8:	6a 47                	push   $0x47
  jmp alltraps
801070ca:	e9 96 f8 ff ff       	jmp    80106965 <alltraps>

801070cf <vector72>:
.globl vector72
vector72:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $72
801070d1:	6a 48                	push   $0x48
  jmp alltraps
801070d3:	e9 8d f8 ff ff       	jmp    80106965 <alltraps>

801070d8 <vector73>:
.globl vector73
vector73:
  pushl $0
801070d8:	6a 00                	push   $0x0
  pushl $73
801070da:	6a 49                	push   $0x49
  jmp alltraps
801070dc:	e9 84 f8 ff ff       	jmp    80106965 <alltraps>

801070e1 <vector74>:
.globl vector74
vector74:
  pushl $0
801070e1:	6a 00                	push   $0x0
  pushl $74
801070e3:	6a 4a                	push   $0x4a
  jmp alltraps
801070e5:	e9 7b f8 ff ff       	jmp    80106965 <alltraps>

801070ea <vector75>:
.globl vector75
vector75:
  pushl $0
801070ea:	6a 00                	push   $0x0
  pushl $75
801070ec:	6a 4b                	push   $0x4b
  jmp alltraps
801070ee:	e9 72 f8 ff ff       	jmp    80106965 <alltraps>

801070f3 <vector76>:
.globl vector76
vector76:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $76
801070f5:	6a 4c                	push   $0x4c
  jmp alltraps
801070f7:	e9 69 f8 ff ff       	jmp    80106965 <alltraps>

801070fc <vector77>:
.globl vector77
vector77:
  pushl $0
801070fc:	6a 00                	push   $0x0
  pushl $77
801070fe:	6a 4d                	push   $0x4d
  jmp alltraps
80107100:	e9 60 f8 ff ff       	jmp    80106965 <alltraps>

80107105 <vector78>:
.globl vector78
vector78:
  pushl $0
80107105:	6a 00                	push   $0x0
  pushl $78
80107107:	6a 4e                	push   $0x4e
  jmp alltraps
80107109:	e9 57 f8 ff ff       	jmp    80106965 <alltraps>

8010710e <vector79>:
.globl vector79
vector79:
  pushl $0
8010710e:	6a 00                	push   $0x0
  pushl $79
80107110:	6a 4f                	push   $0x4f
  jmp alltraps
80107112:	e9 4e f8 ff ff       	jmp    80106965 <alltraps>

80107117 <vector80>:
.globl vector80
vector80:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $80
80107119:	6a 50                	push   $0x50
  jmp alltraps
8010711b:	e9 45 f8 ff ff       	jmp    80106965 <alltraps>

80107120 <vector81>:
.globl vector81
vector81:
  pushl $0
80107120:	6a 00                	push   $0x0
  pushl $81
80107122:	6a 51                	push   $0x51
  jmp alltraps
80107124:	e9 3c f8 ff ff       	jmp    80106965 <alltraps>

80107129 <vector82>:
.globl vector82
vector82:
  pushl $0
80107129:	6a 00                	push   $0x0
  pushl $82
8010712b:	6a 52                	push   $0x52
  jmp alltraps
8010712d:	e9 33 f8 ff ff       	jmp    80106965 <alltraps>

80107132 <vector83>:
.globl vector83
vector83:
  pushl $0
80107132:	6a 00                	push   $0x0
  pushl $83
80107134:	6a 53                	push   $0x53
  jmp alltraps
80107136:	e9 2a f8 ff ff       	jmp    80106965 <alltraps>

8010713b <vector84>:
.globl vector84
vector84:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $84
8010713d:	6a 54                	push   $0x54
  jmp alltraps
8010713f:	e9 21 f8 ff ff       	jmp    80106965 <alltraps>

80107144 <vector85>:
.globl vector85
vector85:
  pushl $0
80107144:	6a 00                	push   $0x0
  pushl $85
80107146:	6a 55                	push   $0x55
  jmp alltraps
80107148:	e9 18 f8 ff ff       	jmp    80106965 <alltraps>

8010714d <vector86>:
.globl vector86
vector86:
  pushl $0
8010714d:	6a 00                	push   $0x0
  pushl $86
8010714f:	6a 56                	push   $0x56
  jmp alltraps
80107151:	e9 0f f8 ff ff       	jmp    80106965 <alltraps>

80107156 <vector87>:
.globl vector87
vector87:
  pushl $0
80107156:	6a 00                	push   $0x0
  pushl $87
80107158:	6a 57                	push   $0x57
  jmp alltraps
8010715a:	e9 06 f8 ff ff       	jmp    80106965 <alltraps>

8010715f <vector88>:
.globl vector88
vector88:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $88
80107161:	6a 58                	push   $0x58
  jmp alltraps
80107163:	e9 fd f7 ff ff       	jmp    80106965 <alltraps>

80107168 <vector89>:
.globl vector89
vector89:
  pushl $0
80107168:	6a 00                	push   $0x0
  pushl $89
8010716a:	6a 59                	push   $0x59
  jmp alltraps
8010716c:	e9 f4 f7 ff ff       	jmp    80106965 <alltraps>

80107171 <vector90>:
.globl vector90
vector90:
  pushl $0
80107171:	6a 00                	push   $0x0
  pushl $90
80107173:	6a 5a                	push   $0x5a
  jmp alltraps
80107175:	e9 eb f7 ff ff       	jmp    80106965 <alltraps>

8010717a <vector91>:
.globl vector91
vector91:
  pushl $0
8010717a:	6a 00                	push   $0x0
  pushl $91
8010717c:	6a 5b                	push   $0x5b
  jmp alltraps
8010717e:	e9 e2 f7 ff ff       	jmp    80106965 <alltraps>

80107183 <vector92>:
.globl vector92
vector92:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $92
80107185:	6a 5c                	push   $0x5c
  jmp alltraps
80107187:	e9 d9 f7 ff ff       	jmp    80106965 <alltraps>

8010718c <vector93>:
.globl vector93
vector93:
  pushl $0
8010718c:	6a 00                	push   $0x0
  pushl $93
8010718e:	6a 5d                	push   $0x5d
  jmp alltraps
80107190:	e9 d0 f7 ff ff       	jmp    80106965 <alltraps>

80107195 <vector94>:
.globl vector94
vector94:
  pushl $0
80107195:	6a 00                	push   $0x0
  pushl $94
80107197:	6a 5e                	push   $0x5e
  jmp alltraps
80107199:	e9 c7 f7 ff ff       	jmp    80106965 <alltraps>

8010719e <vector95>:
.globl vector95
vector95:
  pushl $0
8010719e:	6a 00                	push   $0x0
  pushl $95
801071a0:	6a 5f                	push   $0x5f
  jmp alltraps
801071a2:	e9 be f7 ff ff       	jmp    80106965 <alltraps>

801071a7 <vector96>:
.globl vector96
vector96:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $96
801071a9:	6a 60                	push   $0x60
  jmp alltraps
801071ab:	e9 b5 f7 ff ff       	jmp    80106965 <alltraps>

801071b0 <vector97>:
.globl vector97
vector97:
  pushl $0
801071b0:	6a 00                	push   $0x0
  pushl $97
801071b2:	6a 61                	push   $0x61
  jmp alltraps
801071b4:	e9 ac f7 ff ff       	jmp    80106965 <alltraps>

801071b9 <vector98>:
.globl vector98
vector98:
  pushl $0
801071b9:	6a 00                	push   $0x0
  pushl $98
801071bb:	6a 62                	push   $0x62
  jmp alltraps
801071bd:	e9 a3 f7 ff ff       	jmp    80106965 <alltraps>

801071c2 <vector99>:
.globl vector99
vector99:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $99
801071c4:	6a 63                	push   $0x63
  jmp alltraps
801071c6:	e9 9a f7 ff ff       	jmp    80106965 <alltraps>

801071cb <vector100>:
.globl vector100
vector100:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $100
801071cd:	6a 64                	push   $0x64
  jmp alltraps
801071cf:	e9 91 f7 ff ff       	jmp    80106965 <alltraps>

801071d4 <vector101>:
.globl vector101
vector101:
  pushl $0
801071d4:	6a 00                	push   $0x0
  pushl $101
801071d6:	6a 65                	push   $0x65
  jmp alltraps
801071d8:	e9 88 f7 ff ff       	jmp    80106965 <alltraps>

801071dd <vector102>:
.globl vector102
vector102:
  pushl $0
801071dd:	6a 00                	push   $0x0
  pushl $102
801071df:	6a 66                	push   $0x66
  jmp alltraps
801071e1:	e9 7f f7 ff ff       	jmp    80106965 <alltraps>

801071e6 <vector103>:
.globl vector103
vector103:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $103
801071e8:	6a 67                	push   $0x67
  jmp alltraps
801071ea:	e9 76 f7 ff ff       	jmp    80106965 <alltraps>

801071ef <vector104>:
.globl vector104
vector104:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $104
801071f1:	6a 68                	push   $0x68
  jmp alltraps
801071f3:	e9 6d f7 ff ff       	jmp    80106965 <alltraps>

801071f8 <vector105>:
.globl vector105
vector105:
  pushl $0
801071f8:	6a 00                	push   $0x0
  pushl $105
801071fa:	6a 69                	push   $0x69
  jmp alltraps
801071fc:	e9 64 f7 ff ff       	jmp    80106965 <alltraps>

80107201 <vector106>:
.globl vector106
vector106:
  pushl $0
80107201:	6a 00                	push   $0x0
  pushl $106
80107203:	6a 6a                	push   $0x6a
  jmp alltraps
80107205:	e9 5b f7 ff ff       	jmp    80106965 <alltraps>

8010720a <vector107>:
.globl vector107
vector107:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $107
8010720c:	6a 6b                	push   $0x6b
  jmp alltraps
8010720e:	e9 52 f7 ff ff       	jmp    80106965 <alltraps>

80107213 <vector108>:
.globl vector108
vector108:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $108
80107215:	6a 6c                	push   $0x6c
  jmp alltraps
80107217:	e9 49 f7 ff ff       	jmp    80106965 <alltraps>

8010721c <vector109>:
.globl vector109
vector109:
  pushl $0
8010721c:	6a 00                	push   $0x0
  pushl $109
8010721e:	6a 6d                	push   $0x6d
  jmp alltraps
80107220:	e9 40 f7 ff ff       	jmp    80106965 <alltraps>

80107225 <vector110>:
.globl vector110
vector110:
  pushl $0
80107225:	6a 00                	push   $0x0
  pushl $110
80107227:	6a 6e                	push   $0x6e
  jmp alltraps
80107229:	e9 37 f7 ff ff       	jmp    80106965 <alltraps>

8010722e <vector111>:
.globl vector111
vector111:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $111
80107230:	6a 6f                	push   $0x6f
  jmp alltraps
80107232:	e9 2e f7 ff ff       	jmp    80106965 <alltraps>

80107237 <vector112>:
.globl vector112
vector112:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $112
80107239:	6a 70                	push   $0x70
  jmp alltraps
8010723b:	e9 25 f7 ff ff       	jmp    80106965 <alltraps>

80107240 <vector113>:
.globl vector113
vector113:
  pushl $0
80107240:	6a 00                	push   $0x0
  pushl $113
80107242:	6a 71                	push   $0x71
  jmp alltraps
80107244:	e9 1c f7 ff ff       	jmp    80106965 <alltraps>

80107249 <vector114>:
.globl vector114
vector114:
  pushl $0
80107249:	6a 00                	push   $0x0
  pushl $114
8010724b:	6a 72                	push   $0x72
  jmp alltraps
8010724d:	e9 13 f7 ff ff       	jmp    80106965 <alltraps>

80107252 <vector115>:
.globl vector115
vector115:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $115
80107254:	6a 73                	push   $0x73
  jmp alltraps
80107256:	e9 0a f7 ff ff       	jmp    80106965 <alltraps>

8010725b <vector116>:
.globl vector116
vector116:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $116
8010725d:	6a 74                	push   $0x74
  jmp alltraps
8010725f:	e9 01 f7 ff ff       	jmp    80106965 <alltraps>

80107264 <vector117>:
.globl vector117
vector117:
  pushl $0
80107264:	6a 00                	push   $0x0
  pushl $117
80107266:	6a 75                	push   $0x75
  jmp alltraps
80107268:	e9 f8 f6 ff ff       	jmp    80106965 <alltraps>

8010726d <vector118>:
.globl vector118
vector118:
  pushl $0
8010726d:	6a 00                	push   $0x0
  pushl $118
8010726f:	6a 76                	push   $0x76
  jmp alltraps
80107271:	e9 ef f6 ff ff       	jmp    80106965 <alltraps>

80107276 <vector119>:
.globl vector119
vector119:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $119
80107278:	6a 77                	push   $0x77
  jmp alltraps
8010727a:	e9 e6 f6 ff ff       	jmp    80106965 <alltraps>

8010727f <vector120>:
.globl vector120
vector120:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $120
80107281:	6a 78                	push   $0x78
  jmp alltraps
80107283:	e9 dd f6 ff ff       	jmp    80106965 <alltraps>

80107288 <vector121>:
.globl vector121
vector121:
  pushl $0
80107288:	6a 00                	push   $0x0
  pushl $121
8010728a:	6a 79                	push   $0x79
  jmp alltraps
8010728c:	e9 d4 f6 ff ff       	jmp    80106965 <alltraps>

80107291 <vector122>:
.globl vector122
vector122:
  pushl $0
80107291:	6a 00                	push   $0x0
  pushl $122
80107293:	6a 7a                	push   $0x7a
  jmp alltraps
80107295:	e9 cb f6 ff ff       	jmp    80106965 <alltraps>

8010729a <vector123>:
.globl vector123
vector123:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $123
8010729c:	6a 7b                	push   $0x7b
  jmp alltraps
8010729e:	e9 c2 f6 ff ff       	jmp    80106965 <alltraps>

801072a3 <vector124>:
.globl vector124
vector124:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $124
801072a5:	6a 7c                	push   $0x7c
  jmp alltraps
801072a7:	e9 b9 f6 ff ff       	jmp    80106965 <alltraps>

801072ac <vector125>:
.globl vector125
vector125:
  pushl $0
801072ac:	6a 00                	push   $0x0
  pushl $125
801072ae:	6a 7d                	push   $0x7d
  jmp alltraps
801072b0:	e9 b0 f6 ff ff       	jmp    80106965 <alltraps>

801072b5 <vector126>:
.globl vector126
vector126:
  pushl $0
801072b5:	6a 00                	push   $0x0
  pushl $126
801072b7:	6a 7e                	push   $0x7e
  jmp alltraps
801072b9:	e9 a7 f6 ff ff       	jmp    80106965 <alltraps>

801072be <vector127>:
.globl vector127
vector127:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $127
801072c0:	6a 7f                	push   $0x7f
  jmp alltraps
801072c2:	e9 9e f6 ff ff       	jmp    80106965 <alltraps>

801072c7 <vector128>:
.globl vector128
vector128:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $128
801072c9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801072ce:	e9 92 f6 ff ff       	jmp    80106965 <alltraps>

801072d3 <vector129>:
.globl vector129
vector129:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $129
801072d5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801072da:	e9 86 f6 ff ff       	jmp    80106965 <alltraps>

801072df <vector130>:
.globl vector130
vector130:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $130
801072e1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801072e6:	e9 7a f6 ff ff       	jmp    80106965 <alltraps>

801072eb <vector131>:
.globl vector131
vector131:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $131
801072ed:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801072f2:	e9 6e f6 ff ff       	jmp    80106965 <alltraps>

801072f7 <vector132>:
.globl vector132
vector132:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $132
801072f9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801072fe:	e9 62 f6 ff ff       	jmp    80106965 <alltraps>

80107303 <vector133>:
.globl vector133
vector133:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $133
80107305:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010730a:	e9 56 f6 ff ff       	jmp    80106965 <alltraps>

8010730f <vector134>:
.globl vector134
vector134:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $134
80107311:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107316:	e9 4a f6 ff ff       	jmp    80106965 <alltraps>

8010731b <vector135>:
.globl vector135
vector135:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $135
8010731d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107322:	e9 3e f6 ff ff       	jmp    80106965 <alltraps>

80107327 <vector136>:
.globl vector136
vector136:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $136
80107329:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010732e:	e9 32 f6 ff ff       	jmp    80106965 <alltraps>

80107333 <vector137>:
.globl vector137
vector137:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $137
80107335:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010733a:	e9 26 f6 ff ff       	jmp    80106965 <alltraps>

8010733f <vector138>:
.globl vector138
vector138:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $138
80107341:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107346:	e9 1a f6 ff ff       	jmp    80106965 <alltraps>

8010734b <vector139>:
.globl vector139
vector139:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $139
8010734d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107352:	e9 0e f6 ff ff       	jmp    80106965 <alltraps>

80107357 <vector140>:
.globl vector140
vector140:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $140
80107359:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010735e:	e9 02 f6 ff ff       	jmp    80106965 <alltraps>

80107363 <vector141>:
.globl vector141
vector141:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $141
80107365:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010736a:	e9 f6 f5 ff ff       	jmp    80106965 <alltraps>

8010736f <vector142>:
.globl vector142
vector142:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $142
80107371:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107376:	e9 ea f5 ff ff       	jmp    80106965 <alltraps>

8010737b <vector143>:
.globl vector143
vector143:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $143
8010737d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107382:	e9 de f5 ff ff       	jmp    80106965 <alltraps>

80107387 <vector144>:
.globl vector144
vector144:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $144
80107389:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010738e:	e9 d2 f5 ff ff       	jmp    80106965 <alltraps>

80107393 <vector145>:
.globl vector145
vector145:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $145
80107395:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010739a:	e9 c6 f5 ff ff       	jmp    80106965 <alltraps>

8010739f <vector146>:
.globl vector146
vector146:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $146
801073a1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801073a6:	e9 ba f5 ff ff       	jmp    80106965 <alltraps>

801073ab <vector147>:
.globl vector147
vector147:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $147
801073ad:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801073b2:	e9 ae f5 ff ff       	jmp    80106965 <alltraps>

801073b7 <vector148>:
.globl vector148
vector148:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $148
801073b9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801073be:	e9 a2 f5 ff ff       	jmp    80106965 <alltraps>

801073c3 <vector149>:
.globl vector149
vector149:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $149
801073c5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801073ca:	e9 96 f5 ff ff       	jmp    80106965 <alltraps>

801073cf <vector150>:
.globl vector150
vector150:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $150
801073d1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801073d6:	e9 8a f5 ff ff       	jmp    80106965 <alltraps>

801073db <vector151>:
.globl vector151
vector151:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $151
801073dd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801073e2:	e9 7e f5 ff ff       	jmp    80106965 <alltraps>

801073e7 <vector152>:
.globl vector152
vector152:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $152
801073e9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801073ee:	e9 72 f5 ff ff       	jmp    80106965 <alltraps>

801073f3 <vector153>:
.globl vector153
vector153:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $153
801073f5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801073fa:	e9 66 f5 ff ff       	jmp    80106965 <alltraps>

801073ff <vector154>:
.globl vector154
vector154:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $154
80107401:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107406:	e9 5a f5 ff ff       	jmp    80106965 <alltraps>

8010740b <vector155>:
.globl vector155
vector155:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $155
8010740d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107412:	e9 4e f5 ff ff       	jmp    80106965 <alltraps>

80107417 <vector156>:
.globl vector156
vector156:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $156
80107419:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010741e:	e9 42 f5 ff ff       	jmp    80106965 <alltraps>

80107423 <vector157>:
.globl vector157
vector157:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $157
80107425:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010742a:	e9 36 f5 ff ff       	jmp    80106965 <alltraps>

8010742f <vector158>:
.globl vector158
vector158:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $158
80107431:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107436:	e9 2a f5 ff ff       	jmp    80106965 <alltraps>

8010743b <vector159>:
.globl vector159
vector159:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $159
8010743d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107442:	e9 1e f5 ff ff       	jmp    80106965 <alltraps>

80107447 <vector160>:
.globl vector160
vector160:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $160
80107449:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010744e:	e9 12 f5 ff ff       	jmp    80106965 <alltraps>

80107453 <vector161>:
.globl vector161
vector161:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $161
80107455:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010745a:	e9 06 f5 ff ff       	jmp    80106965 <alltraps>

8010745f <vector162>:
.globl vector162
vector162:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $162
80107461:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107466:	e9 fa f4 ff ff       	jmp    80106965 <alltraps>

8010746b <vector163>:
.globl vector163
vector163:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $163
8010746d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107472:	e9 ee f4 ff ff       	jmp    80106965 <alltraps>

80107477 <vector164>:
.globl vector164
vector164:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $164
80107479:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010747e:	e9 e2 f4 ff ff       	jmp    80106965 <alltraps>

80107483 <vector165>:
.globl vector165
vector165:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $165
80107485:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010748a:	e9 d6 f4 ff ff       	jmp    80106965 <alltraps>

8010748f <vector166>:
.globl vector166
vector166:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $166
80107491:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107496:	e9 ca f4 ff ff       	jmp    80106965 <alltraps>

8010749b <vector167>:
.globl vector167
vector167:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $167
8010749d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801074a2:	e9 be f4 ff ff       	jmp    80106965 <alltraps>

801074a7 <vector168>:
.globl vector168
vector168:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $168
801074a9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801074ae:	e9 b2 f4 ff ff       	jmp    80106965 <alltraps>

801074b3 <vector169>:
.globl vector169
vector169:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $169
801074b5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801074ba:	e9 a6 f4 ff ff       	jmp    80106965 <alltraps>

801074bf <vector170>:
.globl vector170
vector170:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $170
801074c1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801074c6:	e9 9a f4 ff ff       	jmp    80106965 <alltraps>

801074cb <vector171>:
.globl vector171
vector171:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $171
801074cd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801074d2:	e9 8e f4 ff ff       	jmp    80106965 <alltraps>

801074d7 <vector172>:
.globl vector172
vector172:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $172
801074d9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801074de:	e9 82 f4 ff ff       	jmp    80106965 <alltraps>

801074e3 <vector173>:
.globl vector173
vector173:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $173
801074e5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801074ea:	e9 76 f4 ff ff       	jmp    80106965 <alltraps>

801074ef <vector174>:
.globl vector174
vector174:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $174
801074f1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801074f6:	e9 6a f4 ff ff       	jmp    80106965 <alltraps>

801074fb <vector175>:
.globl vector175
vector175:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $175
801074fd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107502:	e9 5e f4 ff ff       	jmp    80106965 <alltraps>

80107507 <vector176>:
.globl vector176
vector176:
  pushl $0
80107507:	6a 00                	push   $0x0
  pushl $176
80107509:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010750e:	e9 52 f4 ff ff       	jmp    80106965 <alltraps>

80107513 <vector177>:
.globl vector177
vector177:
  pushl $0
80107513:	6a 00                	push   $0x0
  pushl $177
80107515:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010751a:	e9 46 f4 ff ff       	jmp    80106965 <alltraps>

8010751f <vector178>:
.globl vector178
vector178:
  pushl $0
8010751f:	6a 00                	push   $0x0
  pushl $178
80107521:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107526:	e9 3a f4 ff ff       	jmp    80106965 <alltraps>

8010752b <vector179>:
.globl vector179
vector179:
  pushl $0
8010752b:	6a 00                	push   $0x0
  pushl $179
8010752d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107532:	e9 2e f4 ff ff       	jmp    80106965 <alltraps>

80107537 <vector180>:
.globl vector180
vector180:
  pushl $0
80107537:	6a 00                	push   $0x0
  pushl $180
80107539:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010753e:	e9 22 f4 ff ff       	jmp    80106965 <alltraps>

80107543 <vector181>:
.globl vector181
vector181:
  pushl $0
80107543:	6a 00                	push   $0x0
  pushl $181
80107545:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010754a:	e9 16 f4 ff ff       	jmp    80106965 <alltraps>

8010754f <vector182>:
.globl vector182
vector182:
  pushl $0
8010754f:	6a 00                	push   $0x0
  pushl $182
80107551:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107556:	e9 0a f4 ff ff       	jmp    80106965 <alltraps>

8010755b <vector183>:
.globl vector183
vector183:
  pushl $0
8010755b:	6a 00                	push   $0x0
  pushl $183
8010755d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107562:	e9 fe f3 ff ff       	jmp    80106965 <alltraps>

80107567 <vector184>:
.globl vector184
vector184:
  pushl $0
80107567:	6a 00                	push   $0x0
  pushl $184
80107569:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010756e:	e9 f2 f3 ff ff       	jmp    80106965 <alltraps>

80107573 <vector185>:
.globl vector185
vector185:
  pushl $0
80107573:	6a 00                	push   $0x0
  pushl $185
80107575:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010757a:	e9 e6 f3 ff ff       	jmp    80106965 <alltraps>

8010757f <vector186>:
.globl vector186
vector186:
  pushl $0
8010757f:	6a 00                	push   $0x0
  pushl $186
80107581:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107586:	e9 da f3 ff ff       	jmp    80106965 <alltraps>

8010758b <vector187>:
.globl vector187
vector187:
  pushl $0
8010758b:	6a 00                	push   $0x0
  pushl $187
8010758d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107592:	e9 ce f3 ff ff       	jmp    80106965 <alltraps>

80107597 <vector188>:
.globl vector188
vector188:
  pushl $0
80107597:	6a 00                	push   $0x0
  pushl $188
80107599:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010759e:	e9 c2 f3 ff ff       	jmp    80106965 <alltraps>

801075a3 <vector189>:
.globl vector189
vector189:
  pushl $0
801075a3:	6a 00                	push   $0x0
  pushl $189
801075a5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801075aa:	e9 b6 f3 ff ff       	jmp    80106965 <alltraps>

801075af <vector190>:
.globl vector190
vector190:
  pushl $0
801075af:	6a 00                	push   $0x0
  pushl $190
801075b1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801075b6:	e9 aa f3 ff ff       	jmp    80106965 <alltraps>

801075bb <vector191>:
.globl vector191
vector191:
  pushl $0
801075bb:	6a 00                	push   $0x0
  pushl $191
801075bd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801075c2:	e9 9e f3 ff ff       	jmp    80106965 <alltraps>

801075c7 <vector192>:
.globl vector192
vector192:
  pushl $0
801075c7:	6a 00                	push   $0x0
  pushl $192
801075c9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801075ce:	e9 92 f3 ff ff       	jmp    80106965 <alltraps>

801075d3 <vector193>:
.globl vector193
vector193:
  pushl $0
801075d3:	6a 00                	push   $0x0
  pushl $193
801075d5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801075da:	e9 86 f3 ff ff       	jmp    80106965 <alltraps>

801075df <vector194>:
.globl vector194
vector194:
  pushl $0
801075df:	6a 00                	push   $0x0
  pushl $194
801075e1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801075e6:	e9 7a f3 ff ff       	jmp    80106965 <alltraps>

801075eb <vector195>:
.globl vector195
vector195:
  pushl $0
801075eb:	6a 00                	push   $0x0
  pushl $195
801075ed:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801075f2:	e9 6e f3 ff ff       	jmp    80106965 <alltraps>

801075f7 <vector196>:
.globl vector196
vector196:
  pushl $0
801075f7:	6a 00                	push   $0x0
  pushl $196
801075f9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801075fe:	e9 62 f3 ff ff       	jmp    80106965 <alltraps>

80107603 <vector197>:
.globl vector197
vector197:
  pushl $0
80107603:	6a 00                	push   $0x0
  pushl $197
80107605:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010760a:	e9 56 f3 ff ff       	jmp    80106965 <alltraps>

8010760f <vector198>:
.globl vector198
vector198:
  pushl $0
8010760f:	6a 00                	push   $0x0
  pushl $198
80107611:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107616:	e9 4a f3 ff ff       	jmp    80106965 <alltraps>

8010761b <vector199>:
.globl vector199
vector199:
  pushl $0
8010761b:	6a 00                	push   $0x0
  pushl $199
8010761d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107622:	e9 3e f3 ff ff       	jmp    80106965 <alltraps>

80107627 <vector200>:
.globl vector200
vector200:
  pushl $0
80107627:	6a 00                	push   $0x0
  pushl $200
80107629:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010762e:	e9 32 f3 ff ff       	jmp    80106965 <alltraps>

80107633 <vector201>:
.globl vector201
vector201:
  pushl $0
80107633:	6a 00                	push   $0x0
  pushl $201
80107635:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010763a:	e9 26 f3 ff ff       	jmp    80106965 <alltraps>

8010763f <vector202>:
.globl vector202
vector202:
  pushl $0
8010763f:	6a 00                	push   $0x0
  pushl $202
80107641:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107646:	e9 1a f3 ff ff       	jmp    80106965 <alltraps>

8010764b <vector203>:
.globl vector203
vector203:
  pushl $0
8010764b:	6a 00                	push   $0x0
  pushl $203
8010764d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107652:	e9 0e f3 ff ff       	jmp    80106965 <alltraps>

80107657 <vector204>:
.globl vector204
vector204:
  pushl $0
80107657:	6a 00                	push   $0x0
  pushl $204
80107659:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010765e:	e9 02 f3 ff ff       	jmp    80106965 <alltraps>

80107663 <vector205>:
.globl vector205
vector205:
  pushl $0
80107663:	6a 00                	push   $0x0
  pushl $205
80107665:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010766a:	e9 f6 f2 ff ff       	jmp    80106965 <alltraps>

8010766f <vector206>:
.globl vector206
vector206:
  pushl $0
8010766f:	6a 00                	push   $0x0
  pushl $206
80107671:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107676:	e9 ea f2 ff ff       	jmp    80106965 <alltraps>

8010767b <vector207>:
.globl vector207
vector207:
  pushl $0
8010767b:	6a 00                	push   $0x0
  pushl $207
8010767d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107682:	e9 de f2 ff ff       	jmp    80106965 <alltraps>

80107687 <vector208>:
.globl vector208
vector208:
  pushl $0
80107687:	6a 00                	push   $0x0
  pushl $208
80107689:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010768e:	e9 d2 f2 ff ff       	jmp    80106965 <alltraps>

80107693 <vector209>:
.globl vector209
vector209:
  pushl $0
80107693:	6a 00                	push   $0x0
  pushl $209
80107695:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010769a:	e9 c6 f2 ff ff       	jmp    80106965 <alltraps>

8010769f <vector210>:
.globl vector210
vector210:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $210
801076a1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801076a6:	e9 ba f2 ff ff       	jmp    80106965 <alltraps>

801076ab <vector211>:
.globl vector211
vector211:
  pushl $0
801076ab:	6a 00                	push   $0x0
  pushl $211
801076ad:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801076b2:	e9 ae f2 ff ff       	jmp    80106965 <alltraps>

801076b7 <vector212>:
.globl vector212
vector212:
  pushl $0
801076b7:	6a 00                	push   $0x0
  pushl $212
801076b9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801076be:	e9 a2 f2 ff ff       	jmp    80106965 <alltraps>

801076c3 <vector213>:
.globl vector213
vector213:
  pushl $0
801076c3:	6a 00                	push   $0x0
  pushl $213
801076c5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801076ca:	e9 96 f2 ff ff       	jmp    80106965 <alltraps>

801076cf <vector214>:
.globl vector214
vector214:
  pushl $0
801076cf:	6a 00                	push   $0x0
  pushl $214
801076d1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801076d6:	e9 8a f2 ff ff       	jmp    80106965 <alltraps>

801076db <vector215>:
.globl vector215
vector215:
  pushl $0
801076db:	6a 00                	push   $0x0
  pushl $215
801076dd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801076e2:	e9 7e f2 ff ff       	jmp    80106965 <alltraps>

801076e7 <vector216>:
.globl vector216
vector216:
  pushl $0
801076e7:	6a 00                	push   $0x0
  pushl $216
801076e9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801076ee:	e9 72 f2 ff ff       	jmp    80106965 <alltraps>

801076f3 <vector217>:
.globl vector217
vector217:
  pushl $0
801076f3:	6a 00                	push   $0x0
  pushl $217
801076f5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801076fa:	e9 66 f2 ff ff       	jmp    80106965 <alltraps>

801076ff <vector218>:
.globl vector218
vector218:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $218
80107701:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107706:	e9 5a f2 ff ff       	jmp    80106965 <alltraps>

8010770b <vector219>:
.globl vector219
vector219:
  pushl $0
8010770b:	6a 00                	push   $0x0
  pushl $219
8010770d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107712:	e9 4e f2 ff ff       	jmp    80106965 <alltraps>

80107717 <vector220>:
.globl vector220
vector220:
  pushl $0
80107717:	6a 00                	push   $0x0
  pushl $220
80107719:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010771e:	e9 42 f2 ff ff       	jmp    80106965 <alltraps>

80107723 <vector221>:
.globl vector221
vector221:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $221
80107725:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010772a:	e9 36 f2 ff ff       	jmp    80106965 <alltraps>

8010772f <vector222>:
.globl vector222
vector222:
  pushl $0
8010772f:	6a 00                	push   $0x0
  pushl $222
80107731:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107736:	e9 2a f2 ff ff       	jmp    80106965 <alltraps>

8010773b <vector223>:
.globl vector223
vector223:
  pushl $0
8010773b:	6a 00                	push   $0x0
  pushl $223
8010773d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107742:	e9 1e f2 ff ff       	jmp    80106965 <alltraps>

80107747 <vector224>:
.globl vector224
vector224:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $224
80107749:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010774e:	e9 12 f2 ff ff       	jmp    80106965 <alltraps>

80107753 <vector225>:
.globl vector225
vector225:
  pushl $0
80107753:	6a 00                	push   $0x0
  pushl $225
80107755:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010775a:	e9 06 f2 ff ff       	jmp    80106965 <alltraps>

8010775f <vector226>:
.globl vector226
vector226:
  pushl $0
8010775f:	6a 00                	push   $0x0
  pushl $226
80107761:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107766:	e9 fa f1 ff ff       	jmp    80106965 <alltraps>

8010776b <vector227>:
.globl vector227
vector227:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $227
8010776d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107772:	e9 ee f1 ff ff       	jmp    80106965 <alltraps>

80107777 <vector228>:
.globl vector228
vector228:
  pushl $0
80107777:	6a 00                	push   $0x0
  pushl $228
80107779:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010777e:	e9 e2 f1 ff ff       	jmp    80106965 <alltraps>

80107783 <vector229>:
.globl vector229
vector229:
  pushl $0
80107783:	6a 00                	push   $0x0
  pushl $229
80107785:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010778a:	e9 d6 f1 ff ff       	jmp    80106965 <alltraps>

8010778f <vector230>:
.globl vector230
vector230:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $230
80107791:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107796:	e9 ca f1 ff ff       	jmp    80106965 <alltraps>

8010779b <vector231>:
.globl vector231
vector231:
  pushl $0
8010779b:	6a 00                	push   $0x0
  pushl $231
8010779d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801077a2:	e9 be f1 ff ff       	jmp    80106965 <alltraps>

801077a7 <vector232>:
.globl vector232
vector232:
  pushl $0
801077a7:	6a 00                	push   $0x0
  pushl $232
801077a9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801077ae:	e9 b2 f1 ff ff       	jmp    80106965 <alltraps>

801077b3 <vector233>:
.globl vector233
vector233:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $233
801077b5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801077ba:	e9 a6 f1 ff ff       	jmp    80106965 <alltraps>

801077bf <vector234>:
.globl vector234
vector234:
  pushl $0
801077bf:	6a 00                	push   $0x0
  pushl $234
801077c1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801077c6:	e9 9a f1 ff ff       	jmp    80106965 <alltraps>

801077cb <vector235>:
.globl vector235
vector235:
  pushl $0
801077cb:	6a 00                	push   $0x0
  pushl $235
801077cd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801077d2:	e9 8e f1 ff ff       	jmp    80106965 <alltraps>

801077d7 <vector236>:
.globl vector236
vector236:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $236
801077d9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801077de:	e9 82 f1 ff ff       	jmp    80106965 <alltraps>

801077e3 <vector237>:
.globl vector237
vector237:
  pushl $0
801077e3:	6a 00                	push   $0x0
  pushl $237
801077e5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801077ea:	e9 76 f1 ff ff       	jmp    80106965 <alltraps>

801077ef <vector238>:
.globl vector238
vector238:
  pushl $0
801077ef:	6a 00                	push   $0x0
  pushl $238
801077f1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801077f6:	e9 6a f1 ff ff       	jmp    80106965 <alltraps>

801077fb <vector239>:
.globl vector239
vector239:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $239
801077fd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107802:	e9 5e f1 ff ff       	jmp    80106965 <alltraps>

80107807 <vector240>:
.globl vector240
vector240:
  pushl $0
80107807:	6a 00                	push   $0x0
  pushl $240
80107809:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010780e:	e9 52 f1 ff ff       	jmp    80106965 <alltraps>

80107813 <vector241>:
.globl vector241
vector241:
  pushl $0
80107813:	6a 00                	push   $0x0
  pushl $241
80107815:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010781a:	e9 46 f1 ff ff       	jmp    80106965 <alltraps>

8010781f <vector242>:
.globl vector242
vector242:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $242
80107821:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107826:	e9 3a f1 ff ff       	jmp    80106965 <alltraps>

8010782b <vector243>:
.globl vector243
vector243:
  pushl $0
8010782b:	6a 00                	push   $0x0
  pushl $243
8010782d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107832:	e9 2e f1 ff ff       	jmp    80106965 <alltraps>

80107837 <vector244>:
.globl vector244
vector244:
  pushl $0
80107837:	6a 00                	push   $0x0
  pushl $244
80107839:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010783e:	e9 22 f1 ff ff       	jmp    80106965 <alltraps>

80107843 <vector245>:
.globl vector245
vector245:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $245
80107845:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010784a:	e9 16 f1 ff ff       	jmp    80106965 <alltraps>

8010784f <vector246>:
.globl vector246
vector246:
  pushl $0
8010784f:	6a 00                	push   $0x0
  pushl $246
80107851:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107856:	e9 0a f1 ff ff       	jmp    80106965 <alltraps>

8010785b <vector247>:
.globl vector247
vector247:
  pushl $0
8010785b:	6a 00                	push   $0x0
  pushl $247
8010785d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107862:	e9 fe f0 ff ff       	jmp    80106965 <alltraps>

80107867 <vector248>:
.globl vector248
vector248:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $248
80107869:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010786e:	e9 f2 f0 ff ff       	jmp    80106965 <alltraps>

80107873 <vector249>:
.globl vector249
vector249:
  pushl $0
80107873:	6a 00                	push   $0x0
  pushl $249
80107875:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010787a:	e9 e6 f0 ff ff       	jmp    80106965 <alltraps>

8010787f <vector250>:
.globl vector250
vector250:
  pushl $0
8010787f:	6a 00                	push   $0x0
  pushl $250
80107881:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107886:	e9 da f0 ff ff       	jmp    80106965 <alltraps>

8010788b <vector251>:
.globl vector251
vector251:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $251
8010788d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107892:	e9 ce f0 ff ff       	jmp    80106965 <alltraps>

80107897 <vector252>:
.globl vector252
vector252:
  pushl $0
80107897:	6a 00                	push   $0x0
  pushl $252
80107899:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010789e:	e9 c2 f0 ff ff       	jmp    80106965 <alltraps>

801078a3 <vector253>:
.globl vector253
vector253:
  pushl $0
801078a3:	6a 00                	push   $0x0
  pushl $253
801078a5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801078aa:	e9 b6 f0 ff ff       	jmp    80106965 <alltraps>

801078af <vector254>:
.globl vector254
vector254:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $254
801078b1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801078b6:	e9 aa f0 ff ff       	jmp    80106965 <alltraps>

801078bb <vector255>:
.globl vector255
vector255:
  pushl $0
801078bb:	6a 00                	push   $0x0
  pushl $255
801078bd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801078c2:	e9 9e f0 ff ff       	jmp    80106965 <alltraps>
801078c7:	66 90                	xchg   %ax,%ax
801078c9:	66 90                	xchg   %ax,%ax
801078cb:	66 90                	xchg   %ax,%ax
801078cd:	66 90                	xchg   %ax,%ax
801078cf:	90                   	nop

801078d0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	57                   	push   %edi
801078d4:	56                   	push   %esi
801078d5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801078d6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801078dc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801078e2:	83 ec 1c             	sub    $0x1c,%esp
801078e5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801078e8:	39 d3                	cmp    %edx,%ebx
801078ea:	73 49                	jae    80107935 <deallocuvm.part.0+0x65>
801078ec:	89 c7                	mov    %eax,%edi
801078ee:	eb 0c                	jmp    801078fc <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801078f0:	83 c0 01             	add    $0x1,%eax
801078f3:	c1 e0 16             	shl    $0x16,%eax
801078f6:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
801078f8:	39 da                	cmp    %ebx,%edx
801078fa:	76 39                	jbe    80107935 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
801078fc:	89 d8                	mov    %ebx,%eax
801078fe:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107901:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80107904:	f6 c1 01             	test   $0x1,%cl
80107907:	74 e7                	je     801078f0 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107909:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010790b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107911:	c1 ee 0a             	shr    $0xa,%esi
80107914:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
8010791a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80107921:	85 f6                	test   %esi,%esi
80107923:	74 cb                	je     801078f0 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107925:	8b 06                	mov    (%esi),%eax
80107927:	a8 01                	test   $0x1,%al
80107929:	75 15                	jne    80107940 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
8010792b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107931:	39 da                	cmp    %ebx,%edx
80107933:	77 c7                	ja     801078fc <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107935:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107938:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010793b:	5b                   	pop    %ebx
8010793c:	5e                   	pop    %esi
8010793d:	5f                   	pop    %edi
8010793e:	5d                   	pop    %ebp
8010793f:	c3                   	ret    
      if(pa == 0)
80107940:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107945:	74 25                	je     8010796c <deallocuvm.part.0+0x9c>
      kfree(v);
80107947:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010794a:	05 00 00 00 80       	add    $0x80000000,%eax
8010794f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107952:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107958:	50                   	push   %eax
80107959:	e8 02 b0 ff ff       	call   80102960 <kfree>
      *pte = 0;
8010795e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107964:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107967:	83 c4 10             	add    $0x10,%esp
8010796a:	eb 8c                	jmp    801078f8 <deallocuvm.part.0+0x28>
        panic("kfree");
8010796c:	83 ec 0c             	sub    $0xc,%esp
8010796f:	68 26 85 10 80       	push   $0x80108526
80107974:	e8 07 8a ff ff       	call   80100380 <panic>
80107979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107980 <mappages>:
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107986:	89 d3                	mov    %edx,%ebx
80107988:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010798e:	83 ec 1c             	sub    $0x1c,%esp
80107991:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107994:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107998:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010799d:	89 45 dc             	mov    %eax,-0x24(%ebp)
801079a0:	8b 45 08             	mov    0x8(%ebp),%eax
801079a3:	29 d8                	sub    %ebx,%eax
801079a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079a8:	eb 3d                	jmp    801079e7 <mappages+0x67>
801079aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801079b0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801079b7:	c1 ea 0a             	shr    $0xa,%edx
801079ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801079c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801079c7:	85 c0                	test   %eax,%eax
801079c9:	74 75                	je     80107a40 <mappages+0xc0>
    if(*pte & PTE_P)
801079cb:	f6 00 01             	testb  $0x1,(%eax)
801079ce:	0f 85 86 00 00 00    	jne    80107a5a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801079d4:	0b 75 0c             	or     0xc(%ebp),%esi
801079d7:	83 ce 01             	or     $0x1,%esi
801079da:	89 30                	mov    %esi,(%eax)
    if(a == last)
801079dc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801079df:	74 6f                	je     80107a50 <mappages+0xd0>
    a += PGSIZE;
801079e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801079e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
801079ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801079ed:	8d 34 18             	lea    (%eax,%ebx,1),%esi
801079f0:	89 d8                	mov    %ebx,%eax
801079f2:	c1 e8 16             	shr    $0x16,%eax
801079f5:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801079f8:	8b 07                	mov    (%edi),%eax
801079fa:	a8 01                	test   $0x1,%al
801079fc:	75 b2                	jne    801079b0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801079fe:	e8 1d b1 ff ff       	call   80102b20 <kalloc>
80107a03:	85 c0                	test   %eax,%eax
80107a05:	74 39                	je     80107a40 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107a07:	83 ec 04             	sub    $0x4,%esp
80107a0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107a0d:	68 00 10 00 00       	push   $0x1000
80107a12:	6a 00                	push   $0x0
80107a14:	50                   	push   %eax
80107a15:	e8 36 dc ff ff       	call   80105650 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107a1a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80107a1d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107a20:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107a26:	83 c8 07             	or     $0x7,%eax
80107a29:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80107a2b:	89 d8                	mov    %ebx,%eax
80107a2d:	c1 e8 0a             	shr    $0xa,%eax
80107a30:	25 fc 0f 00 00       	and    $0xffc,%eax
80107a35:	01 d0                	add    %edx,%eax
80107a37:	eb 92                	jmp    801079cb <mappages+0x4b>
80107a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107a40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a48:	5b                   	pop    %ebx
80107a49:	5e                   	pop    %esi
80107a4a:	5f                   	pop    %edi
80107a4b:	5d                   	pop    %ebp
80107a4c:	c3                   	ret    
80107a4d:	8d 76 00             	lea    0x0(%esi),%esi
80107a50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a53:	31 c0                	xor    %eax,%eax
}
80107a55:	5b                   	pop    %ebx
80107a56:	5e                   	pop    %esi
80107a57:	5f                   	pop    %edi
80107a58:	5d                   	pop    %ebp
80107a59:	c3                   	ret    
      panic("remap");
80107a5a:	83 ec 0c             	sub    $0xc,%esp
80107a5d:	68 0c 8e 10 80       	push   $0x80108e0c
80107a62:	e8 19 89 ff ff       	call   80100380 <panic>
80107a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a6e:	66 90                	xchg   %ax,%ax

80107a70 <seginit>:
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107a76:	e8 55 c4 ff ff       	call   80103ed0 <cpuid>
  pd[0] = size-1;
80107a7b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107a80:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107a86:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a8a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80107a91:	ff 00 00 
80107a94:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80107a9b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107a9e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80107aa5:	ff 00 00 
80107aa8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80107aaf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107ab2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80107ab9:	ff 00 00 
80107abc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80107ac3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107ac6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80107acd:	ff 00 00 
80107ad0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80107ad7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80107ada:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80107adf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107ae3:	c1 e8 10             	shr    $0x10,%eax
80107ae6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107aea:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107aed:	0f 01 10             	lgdtl  (%eax)
}
80107af0:	c9                   	leave  
80107af1:	c3                   	ret    
80107af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b00 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107b00:	a1 44 58 11 80       	mov    0x80115844,%eax
80107b05:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107b0a:	0f 22 d8             	mov    %eax,%cr3
}
80107b0d:	c3                   	ret    
80107b0e:	66 90                	xchg   %ax,%ax

80107b10 <switchuvm>:
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	57                   	push   %edi
80107b14:	56                   	push   %esi
80107b15:	53                   	push   %ebx
80107b16:	83 ec 1c             	sub    $0x1c,%esp
80107b19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107b1c:	85 f6                	test   %esi,%esi
80107b1e:	0f 84 cb 00 00 00    	je     80107bef <switchuvm+0xdf>
  if(p->kstack == 0)
80107b24:	8b 46 08             	mov    0x8(%esi),%eax
80107b27:	85 c0                	test   %eax,%eax
80107b29:	0f 84 da 00 00 00    	je     80107c09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80107b2f:	8b 46 04             	mov    0x4(%esi),%eax
80107b32:	85 c0                	test   %eax,%eax
80107b34:	0f 84 c2 00 00 00    	je     80107bfc <switchuvm+0xec>
  pushcli();
80107b3a:	e8 01 d9 ff ff       	call   80105440 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b3f:	e8 2c c3 ff ff       	call   80103e70 <mycpu>
80107b44:	89 c3                	mov    %eax,%ebx
80107b46:	e8 25 c3 ff ff       	call   80103e70 <mycpu>
80107b4b:	89 c7                	mov    %eax,%edi
80107b4d:	e8 1e c3 ff ff       	call   80103e70 <mycpu>
80107b52:	83 c7 08             	add    $0x8,%edi
80107b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107b58:	e8 13 c3 ff ff       	call   80103e70 <mycpu>
80107b5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107b60:	ba 67 00 00 00       	mov    $0x67,%edx
80107b65:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107b6c:	83 c0 08             	add    $0x8,%eax
80107b6f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107b76:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107b7b:	83 c1 08             	add    $0x8,%ecx
80107b7e:	c1 e8 18             	shr    $0x18,%eax
80107b81:	c1 e9 10             	shr    $0x10,%ecx
80107b84:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107b8a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107b90:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107b95:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107b9c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107ba1:	e8 ca c2 ff ff       	call   80103e70 <mycpu>
80107ba6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107bad:	e8 be c2 ff ff       	call   80103e70 <mycpu>
80107bb2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107bb6:	8b 5e 08             	mov    0x8(%esi),%ebx
80107bb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107bbf:	e8 ac c2 ff ff       	call   80103e70 <mycpu>
80107bc4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107bc7:	e8 a4 c2 ff ff       	call   80103e70 <mycpu>
80107bcc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107bd0:	b8 28 00 00 00       	mov    $0x28,%eax
80107bd5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107bd8:	8b 46 04             	mov    0x4(%esi),%eax
80107bdb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107be0:	0f 22 d8             	mov    %eax,%cr3
}
80107be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107be6:	5b                   	pop    %ebx
80107be7:	5e                   	pop    %esi
80107be8:	5f                   	pop    %edi
80107be9:	5d                   	pop    %ebp
  popcli();
80107bea:	e9 a1 d8 ff ff       	jmp    80105490 <popcli>
    panic("switchuvm: no process");
80107bef:	83 ec 0c             	sub    $0xc,%esp
80107bf2:	68 12 8e 10 80       	push   $0x80108e12
80107bf7:	e8 84 87 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80107bfc:	83 ec 0c             	sub    $0xc,%esp
80107bff:	68 3d 8e 10 80       	push   $0x80108e3d
80107c04:	e8 77 87 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107c09:	83 ec 0c             	sub    $0xc,%esp
80107c0c:	68 28 8e 10 80       	push   $0x80108e28
80107c11:	e8 6a 87 ff ff       	call   80100380 <panic>
80107c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c1d:	8d 76 00             	lea    0x0(%esi),%esi

80107c20 <inituvm>:
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
80107c23:	57                   	push   %edi
80107c24:	56                   	push   %esi
80107c25:	53                   	push   %ebx
80107c26:	83 ec 1c             	sub    $0x1c,%esp
80107c29:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c2c:	8b 75 10             	mov    0x10(%ebp),%esi
80107c2f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107c32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107c35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107c3b:	77 4b                	ja     80107c88 <inituvm+0x68>
  mem = kalloc();
80107c3d:	e8 de ae ff ff       	call   80102b20 <kalloc>
  memset(mem, 0, PGSIZE);
80107c42:	83 ec 04             	sub    $0x4,%esp
80107c45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80107c4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107c4c:	6a 00                	push   $0x0
80107c4e:	50                   	push   %eax
80107c4f:	e8 fc d9 ff ff       	call   80105650 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107c54:	58                   	pop    %eax
80107c55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107c5b:	5a                   	pop    %edx
80107c5c:	6a 06                	push   $0x6
80107c5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c63:	31 d2                	xor    %edx,%edx
80107c65:	50                   	push   %eax
80107c66:	89 f8                	mov    %edi,%eax
80107c68:	e8 13 fd ff ff       	call   80107980 <mappages>
  memmove(mem, init, sz);
80107c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c70:	89 75 10             	mov    %esi,0x10(%ebp)
80107c73:	83 c4 10             	add    $0x10,%esp
80107c76:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107c79:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c7f:	5b                   	pop    %ebx
80107c80:	5e                   	pop    %esi
80107c81:	5f                   	pop    %edi
80107c82:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107c83:	e9 68 da ff ff       	jmp    801056f0 <memmove>
    panic("inituvm: more than a page");
80107c88:	83 ec 0c             	sub    $0xc,%esp
80107c8b:	68 51 8e 10 80       	push   $0x80108e51
80107c90:	e8 eb 86 ff ff       	call   80100380 <panic>
80107c95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ca0 <loaduvm>:
{
80107ca0:	55                   	push   %ebp
80107ca1:	89 e5                	mov    %esp,%ebp
80107ca3:	57                   	push   %edi
80107ca4:	56                   	push   %esi
80107ca5:	53                   	push   %ebx
80107ca6:	83 ec 1c             	sub    $0x1c,%esp
80107ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107caf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107cb4:	0f 85 bb 00 00 00    	jne    80107d75 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
80107cba:	01 f0                	add    %esi,%eax
80107cbc:	89 f3                	mov    %esi,%ebx
80107cbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107cc1:	8b 45 14             	mov    0x14(%ebp),%eax
80107cc4:	01 f0                	add    %esi,%eax
80107cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107cc9:	85 f6                	test   %esi,%esi
80107ccb:	0f 84 87 00 00 00    	je     80107d58 <loaduvm+0xb8>
80107cd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
80107cdb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107cde:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107ce0:	89 c2                	mov    %eax,%edx
80107ce2:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107ce5:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107ce8:	f6 c2 01             	test   $0x1,%dl
80107ceb:	75 13                	jne    80107d00 <loaduvm+0x60>
      panic("loaduvm: address should exist");
80107ced:	83 ec 0c             	sub    $0xc,%esp
80107cf0:	68 6b 8e 10 80       	push   $0x80108e6b
80107cf5:	e8 86 86 ff ff       	call   80100380 <panic>
80107cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107d00:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107d03:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107d09:	25 fc 0f 00 00       	and    $0xffc,%eax
80107d0e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107d15:	85 c0                	test   %eax,%eax
80107d17:	74 d4                	je     80107ced <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107d19:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d1b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80107d1e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107d23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107d28:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107d2e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107d31:	29 d9                	sub    %ebx,%ecx
80107d33:	05 00 00 00 80       	add    $0x80000000,%eax
80107d38:	57                   	push   %edi
80107d39:	51                   	push   %ecx
80107d3a:	50                   	push   %eax
80107d3b:	ff 75 10             	push   0x10(%ebp)
80107d3e:	e8 ed a1 ff ff       	call   80101f30 <readi>
80107d43:	83 c4 10             	add    $0x10,%esp
80107d46:	39 f8                	cmp    %edi,%eax
80107d48:	75 1e                	jne    80107d68 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107d4a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107d50:	89 f0                	mov    %esi,%eax
80107d52:	29 d8                	sub    %ebx,%eax
80107d54:	39 c6                	cmp    %eax,%esi
80107d56:	77 80                	ja     80107cd8 <loaduvm+0x38>
}
80107d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107d5b:	31 c0                	xor    %eax,%eax
}
80107d5d:	5b                   	pop    %ebx
80107d5e:	5e                   	pop    %esi
80107d5f:	5f                   	pop    %edi
80107d60:	5d                   	pop    %ebp
80107d61:	c3                   	ret    
80107d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d70:	5b                   	pop    %ebx
80107d71:	5e                   	pop    %esi
80107d72:	5f                   	pop    %edi
80107d73:	5d                   	pop    %ebp
80107d74:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107d75:	83 ec 0c             	sub    $0xc,%esp
80107d78:	68 0c 8f 10 80       	push   $0x80108f0c
80107d7d:	e8 fe 85 ff ff       	call   80100380 <panic>
80107d82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107d90 <allocuvm>:
{
80107d90:	55                   	push   %ebp
80107d91:	89 e5                	mov    %esp,%ebp
80107d93:	57                   	push   %edi
80107d94:	56                   	push   %esi
80107d95:	53                   	push   %ebx
80107d96:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107d99:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107d9c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107d9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107da2:	85 c0                	test   %eax,%eax
80107da4:	0f 88 b6 00 00 00    	js     80107e60 <allocuvm+0xd0>
  if(newsz < oldsz)
80107daa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107dad:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107db0:	0f 82 9a 00 00 00    	jb     80107e50 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107db6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107dbc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107dc2:	39 75 10             	cmp    %esi,0x10(%ebp)
80107dc5:	77 44                	ja     80107e0b <allocuvm+0x7b>
80107dc7:	e9 87 00 00 00       	jmp    80107e53 <allocuvm+0xc3>
80107dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107dd0:	83 ec 04             	sub    $0x4,%esp
80107dd3:	68 00 10 00 00       	push   $0x1000
80107dd8:	6a 00                	push   $0x0
80107dda:	50                   	push   %eax
80107ddb:	e8 70 d8 ff ff       	call   80105650 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107de0:	58                   	pop    %eax
80107de1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107de7:	5a                   	pop    %edx
80107de8:	6a 06                	push   $0x6
80107dea:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107def:	89 f2                	mov    %esi,%edx
80107df1:	50                   	push   %eax
80107df2:	89 f8                	mov    %edi,%eax
80107df4:	e8 87 fb ff ff       	call   80107980 <mappages>
80107df9:	83 c4 10             	add    $0x10,%esp
80107dfc:	85 c0                	test   %eax,%eax
80107dfe:	78 78                	js     80107e78 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107e00:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107e06:	39 75 10             	cmp    %esi,0x10(%ebp)
80107e09:	76 48                	jbe    80107e53 <allocuvm+0xc3>
    mem = kalloc();
80107e0b:	e8 10 ad ff ff       	call   80102b20 <kalloc>
80107e10:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107e12:	85 c0                	test   %eax,%eax
80107e14:	75 ba                	jne    80107dd0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107e16:	83 ec 0c             	sub    $0xc,%esp
80107e19:	68 89 8e 10 80       	push   $0x80108e89
80107e1e:	e8 cd 88 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107e23:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e26:	83 c4 10             	add    $0x10,%esp
80107e29:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e2c:	74 32                	je     80107e60 <allocuvm+0xd0>
80107e2e:	8b 55 10             	mov    0x10(%ebp),%edx
80107e31:	89 c1                	mov    %eax,%ecx
80107e33:	89 f8                	mov    %edi,%eax
80107e35:	e8 96 fa ff ff       	call   801078d0 <deallocuvm.part.0>
      return 0;
80107e3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e47:	5b                   	pop    %ebx
80107e48:	5e                   	pop    %esi
80107e49:	5f                   	pop    %edi
80107e4a:	5d                   	pop    %ebp
80107e4b:	c3                   	ret    
80107e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e59:	5b                   	pop    %ebx
80107e5a:	5e                   	pop    %esi
80107e5b:	5f                   	pop    %edi
80107e5c:	5d                   	pop    %ebp
80107e5d:	c3                   	ret    
80107e5e:	66 90                	xchg   %ax,%ax
    return 0;
80107e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107e67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e6d:	5b                   	pop    %ebx
80107e6e:	5e                   	pop    %esi
80107e6f:	5f                   	pop    %edi
80107e70:	5d                   	pop    %ebp
80107e71:	c3                   	ret    
80107e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107e78:	83 ec 0c             	sub    $0xc,%esp
80107e7b:	68 a1 8e 10 80       	push   $0x80108ea1
80107e80:	e8 6b 88 ff ff       	call   801006f0 <cprintf>
  if(newsz >= oldsz)
80107e85:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e88:	83 c4 10             	add    $0x10,%esp
80107e8b:	39 45 10             	cmp    %eax,0x10(%ebp)
80107e8e:	74 0c                	je     80107e9c <allocuvm+0x10c>
80107e90:	8b 55 10             	mov    0x10(%ebp),%edx
80107e93:	89 c1                	mov    %eax,%ecx
80107e95:	89 f8                	mov    %edi,%eax
80107e97:	e8 34 fa ff ff       	call   801078d0 <deallocuvm.part.0>
      kfree(mem);
80107e9c:	83 ec 0c             	sub    $0xc,%esp
80107e9f:	53                   	push   %ebx
80107ea0:	e8 bb aa ff ff       	call   80102960 <kfree>
      return 0;
80107ea5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107eac:	83 c4 10             	add    $0x10,%esp
}
80107eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107eb5:	5b                   	pop    %ebx
80107eb6:	5e                   	pop    %esi
80107eb7:	5f                   	pop    %edi
80107eb8:	5d                   	pop    %ebp
80107eb9:	c3                   	ret    
80107eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107ec0 <deallocuvm>:
{
80107ec0:	55                   	push   %ebp
80107ec1:	89 e5                	mov    %esp,%ebp
80107ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
80107ec6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107ecc:	39 d1                	cmp    %edx,%ecx
80107ece:	73 10                	jae    80107ee0 <deallocuvm+0x20>
}
80107ed0:	5d                   	pop    %ebp
80107ed1:	e9 fa f9 ff ff       	jmp    801078d0 <deallocuvm.part.0>
80107ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107edd:	8d 76 00             	lea    0x0(%esi),%esi
80107ee0:	89 d0                	mov    %edx,%eax
80107ee2:	5d                   	pop    %ebp
80107ee3:	c3                   	ret    
80107ee4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107eef:	90                   	nop

80107ef0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ef0:	55                   	push   %ebp
80107ef1:	89 e5                	mov    %esp,%ebp
80107ef3:	57                   	push   %edi
80107ef4:	56                   	push   %esi
80107ef5:	53                   	push   %ebx
80107ef6:	83 ec 0c             	sub    $0xc,%esp
80107ef9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107efc:	85 f6                	test   %esi,%esi
80107efe:	74 59                	je     80107f59 <freevm+0x69>
  if(newsz >= oldsz)
80107f00:	31 c9                	xor    %ecx,%ecx
80107f02:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107f07:	89 f0                	mov    %esi,%eax
80107f09:	89 f3                	mov    %esi,%ebx
80107f0b:	e8 c0 f9 ff ff       	call   801078d0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107f10:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107f16:	eb 0f                	jmp    80107f27 <freevm+0x37>
80107f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f1f:	90                   	nop
80107f20:	83 c3 04             	add    $0x4,%ebx
80107f23:	39 df                	cmp    %ebx,%edi
80107f25:	74 23                	je     80107f4a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107f27:	8b 03                	mov    (%ebx),%eax
80107f29:	a8 01                	test   $0x1,%al
80107f2b:	74 f3                	je     80107f20 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107f32:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f35:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107f38:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107f3d:	50                   	push   %eax
80107f3e:	e8 1d aa ff ff       	call   80102960 <kfree>
80107f43:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107f46:	39 df                	cmp    %ebx,%edi
80107f48:	75 dd                	jne    80107f27 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107f4a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f50:	5b                   	pop    %ebx
80107f51:	5e                   	pop    %esi
80107f52:	5f                   	pop    %edi
80107f53:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107f54:	e9 07 aa ff ff       	jmp    80102960 <kfree>
    panic("freevm: no pgdir");
80107f59:	83 ec 0c             	sub    $0xc,%esp
80107f5c:	68 bd 8e 10 80       	push   $0x80108ebd
80107f61:	e8 1a 84 ff ff       	call   80100380 <panic>
80107f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f6d:	8d 76 00             	lea    0x0(%esi),%esi

80107f70 <setupkvm>:
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	56                   	push   %esi
80107f74:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107f75:	e8 a6 ab ff ff       	call   80102b20 <kalloc>
80107f7a:	89 c6                	mov    %eax,%esi
80107f7c:	85 c0                	test   %eax,%eax
80107f7e:	74 42                	je     80107fc2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107f80:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107f83:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107f88:	68 00 10 00 00       	push   $0x1000
80107f8d:	6a 00                	push   $0x0
80107f8f:	50                   	push   %eax
80107f90:	e8 bb d6 ff ff       	call   80105650 <memset>
80107f95:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107f98:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107f9b:	83 ec 08             	sub    $0x8,%esp
80107f9e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107fa1:	ff 73 0c             	push   0xc(%ebx)
80107fa4:	8b 13                	mov    (%ebx),%edx
80107fa6:	50                   	push   %eax
80107fa7:	29 c1                	sub    %eax,%ecx
80107fa9:	89 f0                	mov    %esi,%eax
80107fab:	e8 d0 f9 ff ff       	call   80107980 <mappages>
80107fb0:	83 c4 10             	add    $0x10,%esp
80107fb3:	85 c0                	test   %eax,%eax
80107fb5:	78 19                	js     80107fd0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107fb7:	83 c3 10             	add    $0x10,%ebx
80107fba:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107fc0:	75 d6                	jne    80107f98 <setupkvm+0x28>
}
80107fc2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fc5:	89 f0                	mov    %esi,%eax
80107fc7:	5b                   	pop    %ebx
80107fc8:	5e                   	pop    %esi
80107fc9:	5d                   	pop    %ebp
80107fca:	c3                   	ret    
80107fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107fcf:	90                   	nop
      freevm(pgdir);
80107fd0:	83 ec 0c             	sub    $0xc,%esp
80107fd3:	56                   	push   %esi
      return 0;
80107fd4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107fd6:	e8 15 ff ff ff       	call   80107ef0 <freevm>
      return 0;
80107fdb:	83 c4 10             	add    $0x10,%esp
}
80107fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107fe1:	89 f0                	mov    %esi,%eax
80107fe3:	5b                   	pop    %ebx
80107fe4:	5e                   	pop    %esi
80107fe5:	5d                   	pop    %ebp
80107fe6:	c3                   	ret    
80107fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fee:	66 90                	xchg   %ax,%ax

80107ff0 <kvmalloc>:
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ff6:	e8 75 ff ff ff       	call   80107f70 <setupkvm>
80107ffb:	a3 44 58 11 80       	mov    %eax,0x80115844
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108000:	05 00 00 00 80       	add    $0x80000000,%eax
80108005:	0f 22 d8             	mov    %eax,%cr3
}
80108008:	c9                   	leave  
80108009:	c3                   	ret    
8010800a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108010 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108010:	55                   	push   %ebp
80108011:	89 e5                	mov    %esp,%ebp
80108013:	83 ec 08             	sub    $0x8,%esp
80108016:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108019:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010801c:	89 c1                	mov    %eax,%ecx
8010801e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80108021:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80108024:	f6 c2 01             	test   $0x1,%dl
80108027:	75 17                	jne    80108040 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80108029:	83 ec 0c             	sub    $0xc,%esp
8010802c:	68 ce 8e 10 80       	push   $0x80108ece
80108031:	e8 4a 83 ff ff       	call   80100380 <panic>
80108036:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010803d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80108040:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108043:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80108049:	25 fc 0f 00 00       	and    $0xffc,%eax
8010804e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80108055:	85 c0                	test   %eax,%eax
80108057:	74 d0                	je     80108029 <clearpteu+0x19>
  *pte &= ~PTE_U;
80108059:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010805c:	c9                   	leave  
8010805d:	c3                   	ret    
8010805e:	66 90                	xchg   %ax,%ax

80108060 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	57                   	push   %edi
80108064:	56                   	push   %esi
80108065:	53                   	push   %ebx
80108066:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108069:	e8 02 ff ff ff       	call   80107f70 <setupkvm>
8010806e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108071:	85 c0                	test   %eax,%eax
80108073:	0f 84 bd 00 00 00    	je     80108136 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010807c:	85 c9                	test   %ecx,%ecx
8010807e:	0f 84 b2 00 00 00    	je     80108136 <copyuvm+0xd6>
80108084:	31 f6                	xor    %esi,%esi
80108086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010808d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
80108090:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80108093:	89 f0                	mov    %esi,%eax
80108095:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80108098:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010809b:	a8 01                	test   $0x1,%al
8010809d:	75 11                	jne    801080b0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010809f:	83 ec 0c             	sub    $0xc,%esp
801080a2:	68 d8 8e 10 80       	push   $0x80108ed8
801080a7:	e8 d4 82 ff ff       	call   80100380 <panic>
801080ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801080b0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801080b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801080b7:	c1 ea 0a             	shr    $0xa,%edx
801080ba:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801080c0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080c7:	85 c0                	test   %eax,%eax
801080c9:	74 d4                	je     8010809f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801080cb:	8b 00                	mov    (%eax),%eax
801080cd:	a8 01                	test   $0x1,%al
801080cf:	0f 84 9f 00 00 00    	je     80108174 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801080d5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801080d7:	25 ff 0f 00 00       	and    $0xfff,%eax
801080dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801080df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801080e5:	e8 36 aa ff ff       	call   80102b20 <kalloc>
801080ea:	89 c3                	mov    %eax,%ebx
801080ec:	85 c0                	test   %eax,%eax
801080ee:	74 64                	je     80108154 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801080f0:	83 ec 04             	sub    $0x4,%esp
801080f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801080f9:	68 00 10 00 00       	push   $0x1000
801080fe:	57                   	push   %edi
801080ff:	50                   	push   %eax
80108100:	e8 eb d5 ff ff       	call   801056f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108105:	58                   	pop    %eax
80108106:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010810c:	5a                   	pop    %edx
8010810d:	ff 75 e4             	push   -0x1c(%ebp)
80108110:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108115:	89 f2                	mov    %esi,%edx
80108117:	50                   	push   %eax
80108118:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010811b:	e8 60 f8 ff ff       	call   80107980 <mappages>
80108120:	83 c4 10             	add    $0x10,%esp
80108123:	85 c0                	test   %eax,%eax
80108125:	78 21                	js     80108148 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108127:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010812d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108130:	0f 87 5a ff ff ff    	ja     80108090 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80108136:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108139:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010813c:	5b                   	pop    %ebx
8010813d:	5e                   	pop    %esi
8010813e:	5f                   	pop    %edi
8010813f:	5d                   	pop    %ebp
80108140:	c3                   	ret    
80108141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80108148:	83 ec 0c             	sub    $0xc,%esp
8010814b:	53                   	push   %ebx
8010814c:	e8 0f a8 ff ff       	call   80102960 <kfree>
      goto bad;
80108151:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80108154:	83 ec 0c             	sub    $0xc,%esp
80108157:	ff 75 e0             	push   -0x20(%ebp)
8010815a:	e8 91 fd ff ff       	call   80107ef0 <freevm>
  return 0;
8010815f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108166:	83 c4 10             	add    $0x10,%esp
}
80108169:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010816c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010816f:	5b                   	pop    %ebx
80108170:	5e                   	pop    %esi
80108171:	5f                   	pop    %edi
80108172:	5d                   	pop    %ebp
80108173:	c3                   	ret    
      panic("copyuvm: page not present");
80108174:	83 ec 0c             	sub    $0xc,%esp
80108177:	68 f2 8e 10 80       	push   $0x80108ef2
8010817c:	e8 ff 81 ff ff       	call   80100380 <panic>
80108181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010818f:	90                   	nop

80108190 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108190:	55                   	push   %ebp
80108191:	89 e5                	mov    %esp,%ebp
80108193:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80108196:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80108199:	89 c1                	mov    %eax,%ecx
8010819b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010819e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801081a1:	f6 c2 01             	test   $0x1,%dl
801081a4:	0f 84 00 01 00 00    	je     801082aa <uva2ka.cold>
  return &pgtab[PTX(va)];
801081aa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801081ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801081b3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801081b4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801081b9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801081c0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801081c7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081ca:	05 00 00 00 80       	add    $0x80000000,%eax
801081cf:	83 fa 05             	cmp    $0x5,%edx
801081d2:	ba 00 00 00 00       	mov    $0x0,%edx
801081d7:	0f 45 c2             	cmovne %edx,%eax
}
801081da:	c3                   	ret    
801081db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081df:	90                   	nop

801081e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081e0:	55                   	push   %ebp
801081e1:	89 e5                	mov    %esp,%ebp
801081e3:	57                   	push   %edi
801081e4:	56                   	push   %esi
801081e5:	53                   	push   %ebx
801081e6:	83 ec 0c             	sub    $0xc,%esp
801081e9:	8b 75 14             	mov    0x14(%ebp),%esi
801081ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081f2:	85 f6                	test   %esi,%esi
801081f4:	75 51                	jne    80108247 <copyout+0x67>
801081f6:	e9 a5 00 00 00       	jmp    801082a0 <copyout+0xc0>
801081fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801081ff:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80108200:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80108206:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010820c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80108212:	74 75                	je     80108289 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80108214:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108216:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80108219:	29 c3                	sub    %eax,%ebx
8010821b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108221:	39 f3                	cmp    %esi,%ebx
80108223:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80108226:	29 f8                	sub    %edi,%eax
80108228:	83 ec 04             	sub    $0x4,%esp
8010822b:	01 c1                	add    %eax,%ecx
8010822d:	53                   	push   %ebx
8010822e:	52                   	push   %edx
8010822f:	51                   	push   %ecx
80108230:	e8 bb d4 ff ff       	call   801056f0 <memmove>
    len -= n;
    buf += n;
80108235:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80108238:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010823e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80108241:	01 da                	add    %ebx,%edx
  while(len > 0){
80108243:	29 de                	sub    %ebx,%esi
80108245:	74 59                	je     801082a0 <copyout+0xc0>
  if(*pde & PTE_P){
80108247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010824a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010824c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010824e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80108251:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80108257:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010825a:	f6 c1 01             	test   $0x1,%cl
8010825d:	0f 84 4e 00 00 00    	je     801082b1 <copyout.cold>
  return &pgtab[PTX(va)];
80108263:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108265:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010826b:	c1 eb 0c             	shr    $0xc,%ebx
8010826e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80108274:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010827b:	89 d9                	mov    %ebx,%ecx
8010827d:	83 e1 05             	and    $0x5,%ecx
80108280:	83 f9 05             	cmp    $0x5,%ecx
80108283:	0f 84 77 ff ff ff    	je     80108200 <copyout+0x20>
  }
  return 0;
}
80108289:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010828c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108291:	5b                   	pop    %ebx
80108292:	5e                   	pop    %esi
80108293:	5f                   	pop    %edi
80108294:	5d                   	pop    %ebp
80108295:	c3                   	ret    
80108296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010829d:	8d 76 00             	lea    0x0(%esi),%esi
801082a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082a3:	31 c0                	xor    %eax,%eax
}
801082a5:	5b                   	pop    %ebx
801082a6:	5e                   	pop    %esi
801082a7:	5f                   	pop    %edi
801082a8:	5d                   	pop    %ebp
801082a9:	c3                   	ret    

801082aa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801082aa:	a1 00 00 00 00       	mov    0x0,%eax
801082af:	0f 0b                	ud2    

801082b1 <copyout.cold>:
801082b1:	a1 00 00 00 00       	mov    0x0,%eax
801082b6:	0f 0b                	ud2    
