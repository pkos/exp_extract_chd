use strict;
use warnings;
use String::Scanf;
use Class::Struct;
use String::Scanf;
no warnings "experimental::refaliasing";
use feature "refaliasing";
use feature 'declared_refs';
no warnings "experimental::declared_refs";
 
my $cdimage = "H:/ROMS/3 Ninjas Kick Back (USA).chd";

#----- init constants ----
my $SECTOR_SIZE = 2352;
my $SUBCODE_SIZE = 96;
my $TRACK_PAD = 4;

my $CHDSTREAM_TRACK_LAST = -2;
my $CHDSTREAM_TRACK_PRIMARY = -3;
my $CHDSTREAM_TRACK_FIRST_DATA = -1;

my $CDROM_OLD_METADATA_TAG = 0x43484344;
my $CDROM_TRACK_METADATA_TAG = 0x43485452;
my $CDROM_TRACK_METADATA_FORMAT = "TRACK:%u TYPE:%s SUBTYPE:%s FRAMES:%u";
my $CDROM_TRACK_METADATA2_TAG = 0x43485432;
#my $CDROM_TRACK_METADATA2_FORMAT = "TRACK:%u TYPE:%s SUBTYPE:%s FRAMES:%u PREGAP:%u PGTYPE:%s PGSUB:%s POSTGAP:%u";
my $GDROM_TRACK_METADATA_TAG = 0x43484744;
my $GDROM_TRACK_METADATA_FORMAT = "TRACK:%u TYPE:%s SUBTYPE:%s FRAMES:%u PAD:%u PREGAP:%u PGTYPE:%s PGSUB:%s POSTGAP:%u";

my $SEEK_SET = 0;
my $SEEK_CUR = 1;
my $SEEK_END = -1;

my $CHD_OPEN_READ;

my $data;

#----- structs -----
struct V5_header => {
  tag => '$',
  len => '$',
  version => '$',
  compressors => '$',
  logicalbytes => '$',
  mapoffset => '$',
  metaoffset => '$', 
  hunkbytes => '$',
  unitbytes => '$',
  rawsha1 => '$',
  sha1 => '$',
  parentsha1 => '$'
};

struct chdstream => {
  chd_file => '$',
  swab => '$',
  frame_size => '$',
  frame_offset => '$',
  frames_per_hunk => '$',
  track_frame => '$',
  track_start => '$', 
  track_end => '$',
  offset => '$',
  hunknum => '$',
  hunkmem => '$'
};

struct metadata_t => {
  type => '$',
  subtype => '$',
  pgtype => '$',
  pgsub => '$',
  frame_offset => '$',
  frames => '$',
  pad => '$',
  extra => '$',
  pregap => '$',
  postgap => '$',
  track => '$'
};

#struct chdstream => {
#  chdstream_t => '$'
#};

my $md = new metadata_t;
$md->type("\0" x 64);
$md->subtype("\0" x 32);
$md->pgtype("\0" x 32);
$md->pgsub("\0" x 32);

my $meta = new metadata_t;
$meta->type("\0" x 64);
$meta->subtype("\0" x 32);
$meta->pgtype("\0" x 32);
$meta->pgsub("\0" x 32);

my $stream = new chdstream;

my $hd = new V5_header;
$hd->tag("\0" x 8);
$hd->compressors("\0" x 4);
$hd->rawsha1("\0" x 20);
$hd->sha1("\0" x 20);
$hd->parentsha1("\0" x 20);

#----- program -----------------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------------------------------

print "chd_get_header (bool): " . chd_get_header($cdimage) . "\n";
   print "tag: ", $hd->tag, "\n";
   print "length: ", $hd->len, "\n";
   print "version: ", $hd->version, "\n";
   print "compressors: ", $hd->compressors, "\n";
   print "logicalbytes: ", $hd->logicalbytes, "\n";
   print "mapoffset: ", $hd->mapoffset, "\n";
   print "metaoffset: ", $hd->metaoffset, "\n";
   print "hunkbytes: ", $hd->hunkbytes, "\n";
   print "unitbytes: ", $hd->unitbytes, "\n";
   print "rawsha1: ", $hd->rawsha1, "\n";
   print "sha1: ", $hd->sha1, "\n";
   print "parentsha1: ", $hd->parentsha1, "\n";
   print "\n";
   
print "chdstream_get_meta (bool): " . chdstream_get_meta($cdimage, 1, $md) . "\n";
   print "track:", $meta->track, "\n";
   print "postgap:", $meta->postgap, "\n";
   print "pregap:", $meta->pregap, "\n";
   print "frames:", $meta->frames, "\n";
   print "pgsub:", $meta->pgsub, "\n";
   print "pgtype:", $meta->pgtype, "\n";
   print "subtype:", $meta->subtype, "\n";
   print "type:", $meta->type, "\n";
   print "extra:", $meta->extra, "\n";
   print "\n";
  
   
print "chdstream_find_track_number (bool): " . chdstream_find_track_number($cdimage, 1) . "\n";
print "chdstream_find_special_track (bool): " . chdstream_find_special_track($cdimage, 1) . "\n";
print "chdstream_open: " . chdstream_open($cdimage, 1) . "\n";;
print "chdstream_load_hunk (bool): " . chdstream_load_hunk(1) . "\n";
print "chdstream_read (bytes): " . chdstream_read(100) . "\n";
print "chdstream_getc (int): " . chdstream_getc() . "\n";
print "chdstream_gets (buffer): " . chdstream_gets(" ", 200) . "\n";
print "chdstream_tell (int): " . chdstream_tell() . "\n"; 
print "chdstream_rewind (int): " . chdstream_rewind() . "\n";
print "chdstream_seek (int:) " . chdstream_seek(0, 1) . "\n";
print "chdstream_get_size (int): " . chdstream_get_size() . "\n";
print "chdstream_get_track_start (int): " . chdstream_get_track_start($cdimage) . "\n";
print "chdstream_get_frame_size (int): " . chdstream_get_frame_size() . "\n";
   
   print "\n";
   print "chd_file: ", $stream->chd_file, "\n";
   #print "swab:", $stream->swab, "\n";
   print "frame_size: ", $stream->frame_size, "\n";
   print "frame_offset: ", $stream->frame_offset, "\n";
   print "frames_per_hunk: ", $stream->frames_per_hunk, "\n";
   print "track_frame: ", $stream->track_frame, "\n";
   print "track_start: ", $stream->track_start, "\n";
   print "track_end: ", $stream->track_end, "\n";
   print "offset: ", $stream->offset, "\n";
   print "hunknum: ", $stream->hunknum, "\n";
   #print "hunkmem:", $stream->hunkmem, "\n";
   print "\n";   

exit;

#----- subs -----------

sub chd_get_header{

   my ($chd_file) = @_;

   my $offset;
   my $read;
   my $temp;

   open(CHD, $chd_file) or die "Could not open CHD '$chd_file' $!";
   binmode CHD;
   
   $offset = 0x0000;
   seek CHD, $offset, 1;
   if ($read = read CHD, $temp, 8) {
      $hd->tag($temp);
   }
      
   $offset = 0x0008;
   seek CHD, $offset, 1;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
 	  $hd->len(hex($temp));
   }
   
   $offset = 0x0012;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
	  $hd->version(hex($temp));
   }

   $offset = 0x0016;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $hd->compressors($temp);
   }
 
   $offset = 0x0032;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
      $hd->logicalbytes(hex($temp));
   }

   $offset = 0x0040;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
	  $hd->mapoffset(hex($temp));
   }

   $offset = 0x0048;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
      $hd->metaoffset(hex($temp));
   }   

   $offset = 0x0056;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
      $hd->hunkbytes(hex($temp));
   }

   $offset = 0x0060;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $temp =~ s/(.)/sprintf("%x",ord($1))/eg;
	  $hd->unitbytes(hex($temp));
   }

   $offset = 0x0064;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 20) {
      $hd->rawsha1($temp);
   }
   
   $offset = 0x0084;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 20) {
      $hd->sha1($temp);
   }

   $offset = 0x00104;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 20) {
      $hd->parentsha1($temp);
   }
      
   close CHD;

   return 1;
}
  
#sub chd_open {
#  my ($filename, $mode, $chd_file_parent, $chd_file_chd) = @_;
#}

#sub chd_get_metadata {
#  my ($chd_file, $searchtag, $searchindex, $output, $outputlen, $resultlen, $resulttag, $resultflags) = @_;
#}

#static uint32_t padding_frames(uint32_t frames)
sub padding_frames {
   my $frames = @_;
   return (($frames + $TRACK_PAD - 1) & ~($TRACK_PAD - 1)) - $frames;
}

#chdstream_get_meta(chd_file *chd, int idx, metadata_t *md)
sub chdstream_get_meta {
   
   my ($chd_file, $idx) = @_;
   
   #my $meta = "\0" x  256;
   my $meta_size = 0;
   my $err;
   
   #memset(md, 0, sizeof(*md));
   #my $mdlen = 0 x length($md);
   #print $mdlen;
   
   #$err = chd_get_metadata($chd_file, $CDROM_TRACK_METADATA2_TAG, $idx, $meta, 
   #  length($meta), \$meta_size, "", "");
   #print $err . "\n";
	  
   #if ($err == 0) {
   #my @meta = sscanf("TRACK:%u TYPE:%s SUBTYPE:%s FRAMES:%u PREGAP:%u PGTYPE:%s PGSUB:%s POSTGAP:%u",
   #      \$md->track, $md->type,
   #      $md->subtype, \$md->frames, \$md->pregap,
   #      $md->pgtype, $md->pgsub,
   #      \$md->postgap);
   #  $md->extra(padding_frames($md->frames));
   #  print @meta;
   #	 return 1
   #}
   
   #$err = chd_get_metadata($chd_file, $GDROM_TRACK_METADATA_TAG, $idx, $meta,
   #      length($meta), \$meta_size, "", "");
   #print $err . "\n";

   #if ($err == 0)
   #{
   #   sscanf($meta, $GDROM_TRACK_METADATA_FORMAT,
   #     \$md->track, $md->type,
   #     $md->subtype, \$md->frames, $md->pad, $md->pregap, $md->pgtype,
   #     $md->pgsub, $md->postgap);
   #   $md->extra = padding_frames($md->frames);
   #   return 1;
   #}

   my $offset;
   my $read;
   my $temp;

   open(CHD, $chd_file) or die "Could not open CHD '$chd_file' $!";
   binmode CHD;
   
   #format: CDROM_TRACK_METADATA2_FORMAT
   $offset = 0x0092;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 1) {
      $meta->track($temp);
   }
      
   $offset = 0x0099;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 9) {
      $meta->type($temp);
   }
   
   $offset = 0x00ab;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $meta->subtype($temp);
   }

   $offset = 0x00b7;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 5) {
      $meta->frames($temp);
   }
 
   $offset = 0x00c4;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 1) {
      $meta->pregap($temp);
   }

   $offset = 0x00cd;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 5) {
      $meta->pgtype($temp);
   }

   $offset = 0x00d9;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $meta->pgsub($temp);
   }   

   $offset = 0x00e6;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 1) {
      $meta->postgap($temp);
   }

   $offset = 0x00d9;
   seek CHD, $offset, 0;
   if ($read = read CHD, $temp, 4) {
      $meta->pgsub($temp);
   }

   $meta->extra(padding_frames($meta->frames));
   
   close CHD;
  
   return 1;
}

#chdstream_find_track_number(chd_file *fd, int32_t track, metadata_t *meta)
sub chdstream_find_track_number {

   #my ($chd_file, $track, $meta) = @_;
   my ($chd_file, $track) = @_;
   my $i;
   my $frame_offset = 0;
   my $true = 1;
   for ($i = 0, $true == 1, ++$i)
   {
      if (!chdstream_get_meta($chd_file, $i)) {
         return 0;
      }

      if ($track == $meta->track) {
         $meta->frame_offset($frame_offset);
         return 1;
      }

      $frame_offset += $meta->frames + $meta->extra;
   }
   
   return 0;
}

#chdstream_find_special_track(chd_file *fd, int32_t track, metadata_t *meta)
sub chdstream_find_special_track {

   #my ($chd_file, $track, $meta) = @_;
   my ($chd_file, $track) = @_;
   my $i;
   my $iter = metadata_t->new();
   my $largest_track = 0;
   my $largest_size = 0;
   my $true = 1;
   
   for ($i = 1, $true == 1, ++$i) {

      #if (chdstream_find_track_number($chd_file, $i, \$iter))
      if (chdstream_find_track_number($chd_file, $i))
	  {
         if ($track == $CHDSTREAM_TRACK_LAST && $i > 1)
         {
            $$meta = $iter;
            return 1;
         }
         elsif ($track == $CHDSTREAM_TRACK_PRIMARY && $largest_track != 0) {
            #return chdstream_find_track_number($chd_file, $largest_track, $meta);
			return chdstream_find_track_number($chd_file, $largest_track);
         }
	  }
      
      if ($track == $CHDSTREAM_TRACK_FIRST_DATA) {
        if ($iter->type eq "AUDIO") {
          $$meta = $iter;
          return 1;
        }
        last;
	  } elsif ($track == $CHDSTREAM_TRACK_PRIMARY) {
        if (($iter->type eq "AUDIO") && $iter->frames > $largest_size)
        {
          $largest_size = $iter->frames;
          $largest_track = $iter->track;
        }
        last;
      } else {
        last;
      }
   }
   
   return 0;
}

#chdstream_find_track(chd_file *fd, int32_t track, metadata_t *meta)
sub chdstream_find_track {
   
   #my ($chd_file, $track, $meta) = @_;
   my ($chd_file, $track) = @_;
   if ($track < 0) {
      return chdstream_find_special_track($chd_file, $track, $meta);
   } else {
     #return chdstream_find_track_number($chd_file, $track, $meta);
	 return chdstream_find_track_number($chd_file, $track);
   }
}

#chdstream_t *chdstream_open(const char *path, int32_t track)   
sub chdstream_open {

   my ($chd_file, $track) = @_;
   
   #my $meta;
   my $pregap = 0;
   my $chd_header = ""; # const chd_header *hd = NULL;
   my $chdstream_t = ""; #chdstream_t *stream  = NULL;
   #chdstream_t *stream  = NULL;
   #chd_file *chd        = NULL;
   #my $chd_file = "";
   #chd_error err        = chd_open(path, CHD_OPEN_READ, NULL, &chd);
   #$my $err = chd_open($chd_file, $CHD_OPEN_READ, "", \$chd_file);
   
   #if (err != CHDERR_NONE)
   #   goto error;
   
   #if (!chdstream_find_track($chd_file, $track, \$meta)) {   
   if (!chdstream_find_track($chd_file, $track)) {
      goto error;
   }
   
   #$stream = ($chdstream_t*)calloc(1, length($stream));
   #if (!$stream) {
   #   goto error;
   #}

   #$hd = chd_get_header($chd_file);
   
   #stream->hunkmem = (uint8_t*)malloc(hd->hunkbytes);
   $stream->hunkmem("\0" x $hd->hunkbytes);
   
   if (!$stream->hunkmem) {
      goto error;
   }
   
   if ($meta->type eq "MODE1_RAW") {
      $stream->frame_size($SECTOR_SIZE);
      $stream->frame_offset(0);
   }
   elsif ($meta->type eq "MODE2_RAW") {
      $stream->frame_size($SECTOR_SIZE);
      $stream->frame_offset(0);
   }
   elsif ($meta->type eq "AUDIO") {
      $stream->frame_size($SECTOR_SIZE);
      $stream->frame_offset(0);
      $stream->swab(1);
   } else {
      $stream->frame_size($hd->unitbytes);
      $stream->frame_offset(0);
   }

   #/* Only include pregap data if it was in the track file */
   if ($meta->pgtype ne 'V') {
      $pregap = $meta->pregap;
   } else {
      $pregap = 0;
   }
 
   $stream->chd_file($chd_file);
   $stream->frames_per_hunk($hd->hunkbytes / $hd->unitbytes); #hd->hunkbytes / hd->unitbytes;
   $stream->track_frame($meta->frame_offset); #= meta.frame_offset;
   $stream->track_start(length $pregap * $stream->frame_size); #(size_t)pregap * stream->frame_size;
   $stream->track_end($stream->track_start + length $meta->frames * $stream->frame_size); #= stream->track_start + (size_t)meta.frames * stream->frame_size;
   $stream->offset(0);
   $stream->hunknum(-1);

   return $stream;

   error:

   chdstream_close();
   
   if ($chd_file) {
     chd_close($chd_file);
   }
   
   return "";
}

#void chdstream_close(chdstream_t *stream)
sub chdstream_close {

   if ($$stream) {
     if ($stream->hunkmem) {
        free($stream->hunkmem);
     }
     if ($stream->chd_file) {
        chd_close($stream->chd);
     }
     free($stream);
   }
}

#chdstream_load_hunk(chdstream_t *stream, uint32_t hunknum)
sub chdstream_load_hunk {
   
   my ($hunknum) = @_;
   
   my $err;
   my @array;
   my $i;
   my $count;
   
   if ($hunknum == $stream->hunknum) {
      return 1;
   }
   
   open(CHD, "<", $stream->chd_file) or die "Could not open CHD '$stream->chd_file' $!";
   binmode CHD;
   read(CHD, $data, \$stream->hunkmem);
   close CHD;
   
   #open(OUT, ">", "chd_hunk_temp") or die "Could not open chd_hunk_temp $!";
   #binmode OUT;
   #print OUT $data;
   #close OUT;
   
   if ($stream->swab)
   {
      $count = chd_get_header($stream->chd)->hunkbytes / 2; 
      @array = $stream->hunknum;
      for ($i = 0, $i < $count, ++$i) {
         $array[$i] = SWAP16($array[$i]);
      }
   }

   $stream->hunknum($hunknum);
   return 1;
}

#ssize_t chdstream_read(chdstream_t *stream, void *data, size_t bytes)
sub chdstream_read {
   
   my ($bytes) = @_;
   
   my $end;
   my $frame_offset;
   my $hunk_offset;
   my $chd_frame;
   my $hunk;
   my $amount;
   my $data_offset= 0;
   my $chd_header = chd_get_header($stream->chd_file); #const chd_header *hd = chd_get_header(stream->chd);
   my $out = $data; #uint8_t         *out = (uint8_t*)data;

   if ($stream->track_end - $stream->offset < $bytes) {
      $bytes = $stream->track_end - $stream->offset;
   }
  
   $end = $stream->offset + $bytes;
   while ($stream->offset < $end)
   {
      $frame_offset = $stream->offset % $stream->frame_size;
      $amount = $stream->frame_size - $frame_offset;
      if ($amount > $end - $stream->offset) {
         $amount = $end - $stream->offset;
      }
	  
      #/* In pregap */
      if ($stream->offset < $stream->track_start) {
         #memset(out + data_offset, 0, amount);
		 $out = substr $out, $data_offset, 0, "/0" x $amount; #insert into string at postions $data_offset
		 #print "out: $out\n";
      } else {
         $chd_frame = $stream->track_frame + 
		   ($stream->offset - $stream->track_start) / $stream->frame_size;
         $hunk = $chd_frame / $stream->frames_per_hunk;
         $hunk_offset = ($chd_frame % $stream->frames_per_hunk) * $hd->unitbytes;

         if (!chdstream_load_hunk($hunk))
         {
            return -1;
         }
         #memcpy(out + data_offset, stream->hunkmem + frame_offset + hunk_offset + stream->frame_offset, amount);
         $out = substr $out, $data_offset, $amount, $stream->hunkmem + $frame_offset + $hunk_offset + $stream->frame_offset;
		 #print "out: $out\n";
	  }

      $data_offset += $amount;
      $stream->offset($stream->offset + $amount);
   }

   return $bytes;
}

#int chdstream_getc(chdstream_t *stream)
sub chdstream_getc {
   
   my $c = 0;

   if (chdstream_read(\$c, length($c) != length($c))) {
     return -1;
   }
   return $c;
}

#char *chdstream_gets(chdstream_t *stream, char *buffer, size_t len)
sub chdstream_gets {
   
   my ($buffer, $len) = @_;
   my $c;
   my $offset = 0;
   
   while ($offset < $len && ($c = chdstream_getc()) != -1) {
     $offset++;
	 substr $buffer, $offset, length($c), $c;
   }
   
   if ($offset < $len) {
     substr $buffer, $offset, 1, '\0';
   }
   
   return $buffer;
}

#uint64_t chdstream_tell(chdstream_t *stream)
sub chdstream_tell {

   return $stream->offset;
}

#void chdstream_rewind(chdstream_t *stream)
sub chdstream_rewind {

   $stream->offset(0);
}

#int64_t chdstream_seek(chdstream_t *stream, int64_t offset, int whence)
sub chdstream_seek {
   
   my ($offset, $whence) = @_;
   
   my $new_offset;
   
   if ($whence == $SEEK_SET) {
     $new_offset = $offset;
     #exit;
   } elsif ($whence == $SEEK_CUR) {
     $new_offset = $stream->offset + $offset;
     #exit;
   } elsif ($whence == $SEEK_END) {
     $new_offset = $stream->track_end + $offset;
     #exit;
   } else {
     return -1;
   }

   if ($new_offset < 0) {
      return -1;
   }
   
   if ($new_offset > $stream->track_end) {
      $new_offset = $stream->track_end;
   }
   
   $stream->offset($new_offset);
   return 0;
}

#ssize_t chdstream_get_size(chdstream_t *stream)
sub chdstream_get_size {

   return $stream->track_end - $stream->track_start;
}

#uint32_t chdstream_get_track_start(chdstream_t *stream)
sub chdstream_get_track_start {

   my ($chd_file) = @_;
   my $frame_offset = 0;
   my $i;

   for ($i = 0, chdstream_get_meta($chd_file, $stream->chd_file), ++$i) {
      if ($stream->track_frame == $frame_offset) {
         return $meta->pregap * $stream->frame_size;
      }
      $frame_offset += $meta->frames + $meta->extra;
   }

   return 0;
}

#uint32_t chdstream_get_frame_size(chdstream_t *stream)
sub chdstream_get_frame_size {
   
   return $stream->frame_size;
}
