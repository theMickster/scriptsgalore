<##############################################################################
 Created By:   Mick Letofsky
 Create Date:  2018.08.15
 Creation:     Script to test send of emails from shared mailbox in O365.
##############################################################################>
$from = 'myname@mydomain.com'
$to = 'yourname@mydomain.com'

$username = 'mailserviceaccount@mydomain.com'
$password = 'HopefullyYouHaveAStrongPassword'

$emailMessage = New-Object System.Net.Mail.MailMessage( $from , $to )
$emailMessage.Subject = 'Email from PowerShell Obiwankenobi'
$emailMessage.IsBodyHtml = $true
$emailMessage.Body = 'hello from Mick test number #1'
$SMTPClient = New-Object System.Net.Mail.SmtpClient( 'mail.office365.com' , 587 )
$SMTPClient.EnableSsl = $true
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $username , $password );
$SMTPClient.Send( $emailMessage )


$tcp = New-Object System.Net.Sockets.TcpClient
$tcp.connect('mail.office365.com', 587) 
