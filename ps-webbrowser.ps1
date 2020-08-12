Add-Type -assembly System.Windows.Forms
$global:webForm = New-Object System.Windows.Forms.Form -Property @{ Text = "HTML Doc" }
$global:txtForm = New-Object System.Windows.Forms.Form -Property @{ Text = "HTML Code" }
$global:web = New-Object System.Windows.Forms.WebBrowser -Property @{ Dock = 'Fill' }
$global:txt = New-Object System.Windows.Forms.TextBox -Property @{
    Multiline  = $true
    Dock       = 'Fill'
    ScrollBars = 'Both'
    Font       = New-Object System.Drawing.Font @('Consolas', 12)
    WordWrap   = $false
    AcceptsTab = $true
}
$webForm.DataBindings.Add((New-Object System.Windows.Forms.Binding @("Text", $web, "DocumentTitle")))
$webForm.Controls.Add($web)
$txtForm.Controls.Add($txt)
$txtForm.AddOwnedForm($webForm)
$txtForm.add_Load( { $webForm.Show() })
# Use Markdown support in PS 6
if (Get-Command ConvertFrom-Markdown 2>$null)
{
    $global:htmlgetter = { ($txt.Text | ConvertFrom-Markdown).Html }
}
else { $global:htmlgetter = { $txt.Text } }
$txt.add_TextChanged( { $web.DocumentText = &$htmlgetter })
$txt.Text = @"
<html>

<head>
    <title>Hello World!</title>
</head>

<body>
<h1>Hello World!</h1>

HTML primitives:
<ol>
    <li><i>Italic text</i></li>
    <li><b>Bold text</b></li>
    <li><code>inline code</code></li>
</ol>

Markdown primitives:
1. _Italic text_
2. **Bold Text**
3. ``inline code``

</body>

</html>
"@
$txtForm.ShowDialog() | Out-Null