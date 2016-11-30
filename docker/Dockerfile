FROM ubuntu:14.04
MAINTAINER Mike Halagan <mhalagan@nmdp.org>

WORKDIR /opt

COPY hap1.1.tar.gz /opt/hap1.1.tar.gz
COPY ngs-tools_1.9.deb /opt/ngs-tools_1.9.deb

RUN PERL_MM_USE_DEFAULT=1 apt-get update -q \
    && apt-get dist-upgrade -qy \
    && apt-get install -qyy openjdk-7-jre-headless  perl-doc wget curl build-essential git \
    && sudo apt-get -qy install libssl-dev \
    && cpan JSON::Schema::AsType YAML Plack Plack::Handler::Starman Template JSON Getopt::Long Data::Dumper LWP::UserAgent Test::More Dancer \
    && cpan Net::SSLeay IO::Socket::SSL REST::Client Math::Round Moose File::Spec XML::DOM Log::Log4perl Dancer::Plugin::Swagger \
    && curl -fsSL get.nextflow.io | bash \
    && cd /opt && tar -xzf hap1.1.tar.gz && export PATH=/opt/hap1.1:/opt:$PATH \
    && wget http://www.clustal.org/omega/clustalo-1.2.3-Ubuntu-x86_64 \
    && mv clustalo-1.2.3-Ubuntu-x86_64 /opt/hap1.1/clustalo \
    && chmod a+x /opt/hap1.1/clustalo \
    && dpkg --install /opt/ngs-tools_1.9.deb \
    && export PATH=/opt/hap1.1:/opt/ngs-tools/bin:/opt/service-gfe-submission/gfe_submission/bin:$PATH \
    && cd /opt && git clone https://github.com/nmdp-bioinformatics/service-gfe-submission \
    && cd service-gfe-submission && mv -i GFE_Submission gfe_submission && cd gfe_submission \
    && perl Makefile.PL && make && make test && make install

EXPOSE 8080
EXPOSE 5050

WORKDIR /opt/service-gfe-submission/gfe_submission
VOLUME /opt/service-gfe-submission/gfe_submission

ENV PATH /opt/hap1.1:/opt/ngs-tools/bin:/opt/service-gfe-submission/gfe_submission/bin:$PATH

CMD plackup -E deployment -s Starman --workers=10 -p 5050 -a /opt/service-gfe-submission/gfe_submission/bin/app.pl
