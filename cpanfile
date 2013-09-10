requires 'Amon2';
requires 'Amon2::Declare';
requires 'Amon2::Web';
requires 'Class::Accessor::Lite';
requires 'Class::Load';
requires 'Data::Section::Simple';
requires 'Encode';
requires 'File::ShareDir';
requires 'Getopt::Compact::WithCmd';
requires 'Git::Repository';
requires 'JSON', '2';
requires 'List::MoreUtils';
requires 'Log::Minimal';
requires 'Module::Find';
requires 'Module::Functions';
requires 'Router::Simple::Declare';
requires 'Scalar::Util';
requires 'String::CamelCase';
requires 'TOML';
requires 'Text::Xslate', '1.6001';
requires 'Text::Xslate::Bridge';
requires 'Text::Markdown::Discount';
requires 'parent';
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::More';
};
