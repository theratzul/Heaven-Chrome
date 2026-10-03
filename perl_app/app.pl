#!/usr/bin/env perl
# ==============================================================================
# Heaven Chrome - Perl Application & Web Server
# Serves the HTML5/JS Celestial Game, Audio Synthesizer, Status API,
# and Direct APK Download endpoint for Android testing.
# ==============================================================================

use strict;
use warnings;
use utf8;
use IO::Socket::INET;
use File::Spec;
use File::Basename;
use Cwd qw(abs_path getcwd);
use Time::HiRes qw(time);
use POSIX qw(strftime);

$| = 1; # Autoflush output

# Resolve directories
my $script_dir = dirname(abs_path(__FILE__));
my $repo_root  = abs_path(File::Spec->catdir($script_dir, '..'));
my $web_dir    = File::Spec->catdir($repo_root, 'web');
my $apk_release= File::Spec->catfile($repo_root, 'android', 'app', 'build', 'outputs', 'apk', 'release', 'Heaven-Chrome.apk');
my $apk_debug  = File::Spec->catfile($repo_root, 'android', 'app', 'build', 'outputs', 'apk', 'debug', 'Heaven-Chrome.apk');

my $host = $ENV{HOST} || '0.0.0.0';
my $port = $ENV{PORT} || 5050;

# MIME type mapping
my %mime_types = (
    'html' => 'text/html; charset=utf-8',
    'htm'  => 'text/html; charset=utf-8',
    'js'   => 'application/javascript; charset=utf-8',
    'json' => 'application/json; charset=utf-8',
    'css'  => 'text/css; charset=utf-8',
    'png'  => 'image/png',
    'jpg'  => 'image/jpeg',
    'jpeg' => 'image/jpeg',
    'gif'  => 'image/gif',
    'svg'  => 'image/svg+xml',
    'ico'  => 'image/x-icon',
    'mid'  => 'audio/midi',
    'midi' => 'audio/midi',
    'wav'  => 'audio/wav',
    'mp3'  => 'audio/mpeg',
    'apk'  => 'application/vnd.android.package-archive',
    'txt'  => 'text/plain; charset=utf-8',
);

print "\n";
print "========================================================\n";
print "   HEAVEN CHROME - PERL APPLICATION SERVER               \n";
print "========================================================\n";
print " [i] Perl Version : $^V on $^O\n";
print " [i] Web Directory: $web_dir\n";
print " [i] Binding to   : http://$host:$port\n";
print " [i] Status API   : http://localhost:$port/api/status\n";
print " [i] APK Download : http://localhost:$port/download\n";
print "========================================================\n\n";

# Create listening TCP socket
my $server = IO::Socket::INET->new(
    LocalHost => $host,
    LocalPort => $port,
    Proto     => 'tcp',
    Listen    => 128,
    Reuse     => 1,
) or die "[-] Could not start Perl server on $host:$port: $!\n";

$SIG{INT} = sub {
    print "\n[!] Shutting down Perl application server gracefully...\n";
    close($server);
    exit 0;
};
$SIG{TERM} = $SIG{INT};

while (my $client = $server->accept()) {
    my $start_time = time();
    $client->autoflush(1);

    # Read HTTP Request Line
    my $request_line = <$client>;
    next unless defined $request_line;

    chomp $request_line;
    $request_line =~ s/\r$//;

    my ($method, $url, $proto) = split(/\s+/, $request_line);
    $method ||= 'GET';
    $url    ||= '/';

    # Read and discard headers
    my %headers;
    while (my $line = <$client>) {
        $line =~ s/\r?\n$//;
        last if $line eq '';
        if ($line =~ /^([^:]+):\s*(.*)$/) {
            $headers{lc($1)} = $2;
        }
    }

    # Clean URL path
    my ($path) = split(/\?/, $url);
    $path = '/' unless defined $path && length($path);

    my $status_code = 200;
    my $status_text = 'OK';
    my $content_type = 'text/plain';
    my $body = '';

    # Route: /api/status
    if ($path eq '/api/status') {
        $content_type = 'application/json';
        my $apk_avail = -f $apk_release ? "release" : (-f $apk_debug ? "debug" : "none");
        $body = sprintf(
            '{"status":"online","app":"Heaven Chrome","version":"1.0.0","runtime":"Perl %s","platform":"%s","levels":20,"apk_available":"%s"}',
            $^V, $^O, $apk_avail
        );
    }
    # Route: /download or /apk
    elsif ($path eq '/download' || $path eq '/apk' || $path eq '/Heaven-Chrome.apk') {
        my $target_apk = -f $apk_release ? $apk_release : $apk_debug;
        if (-f $target_apk) {
            my $apk_size = -s $target_apk;
            print $client "HTTP/1.1 200 OK\r\n";
            print $client "Content-Type: application/vnd.android.package-archive\r\n";
            print $client "Content-Disposition: attachment; filename=\"Heaven-Chrome.apk\"\r\n";
            print $client "Content-Length: $apk_size\r\n";
            print $client "Connection: close\r\n\r\n";

            if (open(my $fh, '<:raw', $target_apk)) {
                my $buffer;
                while (read($fh, $buffer, 65536)) {
                    print $client $buffer;
                }
                close($fh);
            }
            close($client);
            log_request($method, $path, 200, time() - $start_time);
            next;
        } else {
            $status_code = 404;
            $status_text = 'Not Found';
            $content_type = 'application/json';
            $body = '{"error":"APK not yet built. Run ./build-android.sh first."}';
        }
    }
    # Static files from web/
    else {
        my $rel_path = $path;
        $rel_path = '/index.html' if $rel_path eq '/';
        $rel_path =~ s/^\///; # strip leading slash

        # Security: prevent directory traversal
        if ($rel_path =~ /\.\./) {
            $status_code = 403;
            $status_text = 'Forbidden';
            $body = "403 Forbidden\n";
        } else {
            my $file_path = File::Spec->catfile($web_dir, $rel_path);

            if (-d $file_path) {
                $file_path = File::Spec->catfile($file_path, 'index.html');
            }

            if (-f $file_path && open(my $fh, '<:raw', $file_path)) {
                my ($ext) = ($file_path =~ /\.([^.]+)$/);
                $ext = lc($ext || '');
                $content_type = $mime_types{$ext} || 'application/octet-stream';
                my $file_size = -s $file_path;

                print $client "HTTP/1.1 200 OK\r\n";
                print $client "Content-Type: $content_type\r\n";
                print $client "Content-Length: $file_size\r\n";
                print $client "Access-Control-Allow-Origin: *\r\n";
                print $client "Connection: close\r\n\r\n";

                my $buffer;
                while (read($fh, $buffer, 65536)) {
                    print $client $buffer;
                }
                close($fh);
                close($client);
                log_request($method, $path, 200, time() - $start_time);
                next;
            } else {
                $status_code = 404;
                $status_text = 'Not Found';
                $content_type = 'text/html';
                $body = "<html><head><title>404 Not Found</title></head><body style='font-family:sans-serif;text-align:center;padding:50px;'><h1>404 Not Found</h1><p>Resource not found in Heaven Chrome web bundle.</p></body></html>\n";
            }
        }
    }

    # Send response
    my $content_len = length(Encode_utf8($body));
    print $client "HTTP/1.1 $status_code $status_text\r\n";
    print $client "Content-Type: $content_type\r\n";
    print $client "Content-Length: $content_len\r\n";
    print $client "Access-Control-Allow-Origin: *\r\n";
    print $client "Connection: close\r\n\r\n";
    print $client $body;
    close($client);

    log_request($method, $path, $status_code, time() - $start_time);
}

sub Encode_utf8 {
    my ($str) = @_;
    utf8::encode($str) if utf8::is_utf8($str);
    return $str;
}

sub log_request {
    my ($method, $path, $code, $elapsed) = @_;
    my $ts = strftime("%Y-%m-%d %H:%M:%S", localtime);
    my $ms = sprintf("%.2f ms", $elapsed * 1000);
    my $color = ($code >= 200 && $code < 300) ? "\e[32m" : ($code >= 400 ? "\e[31m" : "\e[33m");
    my $reset = "\e[0m";
    print "[$ts] $method $path -> $color$code$reset ($ms)\n";
}
