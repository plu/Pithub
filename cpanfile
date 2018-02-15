requires "Array::Iterator" => "0";
requires "Cache::LRU" => "0";
requires "Carp" => "0";
requires "HTTP::Headers" => "0";
requires "HTTP::Request" => "0";
requires "HTTP::Request::Common" => "0";
requires "JSON::MaybeXS" => "0";
requires "LWP::UserAgent" => "0";
requires "Moo" => "0";
requires "Moo::Role" => "0";
requires "URI" => "0";
requires "perl" => "5.010";

on 'test' => sub {
  requires "Exporter" => "0";
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "FindBin" => "0";
  requires "HTTP::Response" => "0";
  requires "Import::Into" => "0";
  requires "MIME::Base64" => "0";
  requires "Path::Tiny" => "0";
  requires "Scalar::Util" => "0";
  requires "Test::More" => "0";
  requires "Test::Most" => "0";
  requires "lib" => "0";
  requires "perl" => "5.010";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::More" => "0.96";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Synopsis" => "0";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'develop' => sub {
  recommends "Dist::Zilla::PluginBundle::Git::VersionManager" => "0.005";
};
