# Regenerates the app icons for West Trojan Run.
#
#   powershell -ExecutionPolicy Bypass -File tools\make-icons.ps1
#
# The artwork is the same shield as the start-screen badge in index.html, kept
# in sync by hand: shield path, plume path, and colours are copied from that
# SVG. Uses only .NET's System.Drawing, so it needs no Node, Python, or npm.
#
# After regenerating, re-inline the apple-touch-icon data URI in index.html if
# the art changed -- the <link rel="apple-touch-icon"> holds its own base64 copy.


Add-Type -AssemblyName System.Drawing

$Out = Split-Path -Parent $PSScriptRoot

$BG     = [System.Drawing.ColorTranslator]::FromHtml('#141414')
$ShieldFill = [System.Drawing.ColorTranslator]::FromHtml('#191919')
$GOLD   = [System.Drawing.ColorTranslator]::FromHtml('#E8B33C')
$RED    = [System.Drawing.ColorTranslator]::FromHtml('#CC0022')

# Badge geometry copied from the start-screen SVG (64x64 viewBox).
# Shield bbox is x 8..56, y 4..60  ->  48 wide, 56 tall.
function New-BadgeIcon {
  param([int]$Size, [double]$Frac, [string]$Name)

  $bmp = New-Object System.Drawing.Bitmap($Size, $Size)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic

  $bgBrush = New-Object System.Drawing.SolidBrush($BG)
  $g.FillRectangle($bgBrush, 0, 0, $Size, $Size)

  $s  = ($Frac * $Size) / 56.0
  $tx = ($Size - 48.0 * $s) / 2.0 - 8.0 * $s
  $ty = ($Size - 56.0 * $s) / 2.0 - 4.0 * $s
  $g.TranslateTransform($tx, $ty)
  $g.ScaleTransform($s, $s)

  $shieldPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $shieldPath.AddLine(32.0, 4.0, 56.0, 12.0)
  $shieldPath.AddLine(56.0, 12.0, 56.0, 32.0)
  $shieldPath.AddBezier(56.0, 32.0, 56.0, 47.0, 45.0, 56.0, 32.0, 60.0)
  $shieldPath.AddBezier(32.0, 60.0, 19.0, 56.0, 8.0, 47.0, 8.0, 32.0)
  $shieldPath.AddLine(8.0, 32.0, 8.0, 12.0)
  $shieldPath.CloseFigure()

  $sb = New-Object System.Drawing.SolidBrush($ShieldFill)
  $g.FillPath($sb, $shieldPath)

  $pen = New-Object System.Drawing.Pen($GOLD, 3.0)
  $pen.LineJoin = [System.Drawing.Drawing2D.LineJoin]::Round
  $g.DrawPath($pen, $shieldPath)

  $plume = New-Object System.Drawing.Drawing2D.GraphicsPath
  $plume.AddPolygon(@(
    (New-Object System.Drawing.PointF(32.0, 16.0)),
    (New-Object System.Drawing.PointF(40.0, 24.0)),
    (New-Object System.Drawing.PointF(32.0, 48.0)),
    (New-Object System.Drawing.PointF(24.0, 24.0))
  ))
  $rb = New-Object System.Drawing.SolidBrush($RED)
  $g.FillPath($rb, $plume)

  $g.ResetTransform()
  $path = Join-Path $Out $Name
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)

  $shieldPath.Dispose(); $plume.Dispose(); $pen.Dispose()
  $sb.Dispose(); $rb.Dispose(); $bgBrush.Dispose()
  $g.Dispose(); $bmp.Dispose()

  "{0}  {1}x{1}  {2} bytes" -f $Name, $Size, (Get-Item $path).Length
}

# Regular icons: badge at 76% of the canvas.
New-BadgeIcon -Size 192  -Frac 0.76 -Name 'icon-192.png'
New-BadgeIcon -Size 512  -Frac 0.76 -Name 'icon-512.png'
New-BadgeIcon -Size 180  -Frac 0.76 -Name 'apple-touch-icon.png'
# Maskable: Android crops to a circle, so keep art inside the central 80%.
New-BadgeIcon -Size 512  -Frac 0.60 -Name 'icon-maskable-512.png'
