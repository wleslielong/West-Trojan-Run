# Rebuilds the West Trojans logo PNGs from the source JPEG.
#
#   powershell -ExecutionPolicy Bypass -File tools\make-logo.ps1
#
# Source is "West Trojan - Red Black Logo.jpeg" in the project root. The JPEG has
# no alpha, so the output keeps its white ground; anything the mark is drawn on
# has to be white too. Uses only .NET System.Drawing — no Node, no Python.
#
# After regenerating, re-inline the base64 into the #logoImg data URI in
# index.html. That element is the single source of the artwork; the game canvas
# reads it back rather than storing a second copy.

Add-Type -AssemblyName System.Drawing
$dir = Split-Path -Parent $PSScriptRoot
$src = [System.Drawing.Image]::FromFile((Join-Path $dir 'West Trojan - Red Black Logo.jpeg'))
$in  = New-Object System.Drawing.Bitmap($src)

# Find the ink, ignoring the white margin.
$w = $in.Width; $h = $in.Height
$minX = $w; $maxX = 0; $minY = $h; $maxY = 0
for ($y=0; $y -lt $h; $y++) { for ($x=0; $x -lt $w; $x++) {
  $c = $in.GetPixel($x,$y)
  if ($c.R -lt 235 -or $c.G -lt 235 -or $c.B -lt 235) {
    if ($x -lt $minX) { $minX = $x }; if ($x -gt $maxX) { $maxX = $x }
    if ($y -lt $minY) { $minY = $y }; if ($y -gt $maxY) { $maxY = $y }
  }
}}
$bw = $maxX-$minX+1; $bh = $maxY-$minY+1
$side = [Math]::Max($bw,$bh) + 24                    # pad to a centred square
$sx = [int](($minX + $bw/2) - $side/2)
$sy = [int](($minY + $bh/2) - $side/2)

# Snap to the three real ink colours BEFORE scaling. The JPEG carries ringing
# noise around every outline; flattening it cleans the edges and roughly halves
# the PNG, which matters because this gets inlined as base64.
$sq = New-Object System.Drawing.Bitmap($side, $side)
$RED = [System.Drawing.Color]::FromArgb(150,2,18)
$BLK = [System.Drawing.Color]::FromArgb(13,13,13)
$WHT = [System.Drawing.Color]::White
for ($y=0; $y -lt $side; $y++) { for ($x=0; $x -lt $side; $x++) {
  $gx = $sx + $x; $gy = $sy + $y
  if ($gx -lt 0 -or $gy -lt 0 -or $gx -ge $w -or $gy -ge $h) { $sq.SetPixel($x,$y,$WHT); continue }
  $c = $in.GetPixel($gx,$gy)
  $lum = 0.299*$c.R + 0.587*$c.G + 0.114*$c.B
  if ($lum -gt 200) { $sq.SetPixel($x,$y,$WHT) }
  elseif ($c.R -gt $c.G + 40 -and $c.R -gt $c.B + 40) { $sq.SetPixel($x,$y,$RED) }
  else { $sq.SetPixel($x,$y,$BLK) }
}}

# Scale last, so the bicubic filter supplies the anti-aliasing.
foreach ($size in @(256, 512)) {
  $out = New-Object System.Drawing.Bitmap($size, $size)
  $g = [System.Drawing.Graphics]::FromImage($out)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode  = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.Clear([System.Drawing.Color]::White)
  $g.DrawImage($sq, 0, 0, $size, $size)
  $g.Dispose()
  $path = Join-Path $dir "trojan-logo-$size.png"
  $out.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  "{0}  {1} bytes" -f (Split-Path $path -Leaf), (Get-Item $path).Length
  $out.Dispose()
}
$sq.Dispose(); $in.Dispose(); $src.Dispose()
