FROM ubuntu:14.04
MAINTAINER Mike Halagan <mhalagan@nmdp.org>

COPY hap1.2.tar.gz /opt/hap1.2.tar.gz
COPY ngs-tools_1.9.deb /opt/ngs-tools_1.9.deb

RUN PERL_MM_USE_DEFAULT=1 apt-get update -q \
    && apt-get dist-upgrade -qy \
    && apt-get install -qyy openjdk-7-jre-headless  perl-doc wget curl build-essential git \
    && sudo apt-get -qy install expat libexpat1-dev libnet-ssleay-perl libssl-dev \
    && cd /opt && curl -fsSL get.nextflow.io | bash \
    && tar -xzf hap1.2.tar.gz && export PATH=/opt/hap1.2:/opt:$PATH \
    && wget http://www.clustal.org/omega/clustalo-1.2.3-Ubuntu-x86_64 \
    && mv clustalo-1.2.3-Ubuntu-x86_64 /opt/hap1.2/clustalo \
    && chmod a+x /opt/hap1.2/clustalo \
    && dpkg --install /opt/ngs-tools_1.9.deb \
    && export PATH=/opt/hap1.2:/opt/ngs-tools/bin:/opt/service-gfe-submission/gfe_submission/bin:$PATH \
    && cd /opt && git clone https://github.com/nmdp-bioinformatics/service-gfe-submission \
    && cd service-gfe-submission && mv -i GFE_Submission gfe_submission && cd gfe_submission \
    && curl -LO http://xrl.us/cpanm \
    && perl cpanm --quiet --notest Test::More@1.302075 \
    && perl cpanm --quiet --notest YAML@1.21 \
    && perl cpanm --quiet --notest Moose@2.2004 \
    && perl cpanm --quiet --notest Dancer@1.3202 \
    && perl cpanm --quiet --notest JSON@2.90 \
    && perl cpanm --quiet --notest Dancer::Plugin::Swagger@0.2.0 \
    && perl cpanm --quiet --notest Log::Log4perl@1.48 \
    && perl cpanm --quiet --notest JSON::Schema::AsType@0.1.0 \
    && perl cpanm --quiet --notest Plack::Handler::Starman \
    && perl cpanm --quiet --notest Plack@1.0042 \
    && perl cpanm --quiet --notest Template@2.26 \
    && perl cpanm --quiet --notest Getopt::Long \
    && perl cpanm --quiet --notest LWP::UserAgent@6.17 \
    && perl cpanm --quiet --notest Dancer::Plugin::Swagger@0.2.0 \
    && perl cpanm --quiet --notest Net::SSLeay@1.58 \
    && perl cpanm --quiet --notest JSON::Schema::AsType@0.1.0 \
    && perl cpanm --quiet --notest IO::Socket::SSL@2.044 \
    && perl cpanm --quiet --notest REST::Client@273 \
    && perl cpanm --quiet --notest Math::Round@0.07 \
    && perl cpanm --quiet --notest File::Spec@3.40 \
    && perl cpanm --quiet --notest XML::DOM@1.46 \
    && perl cpanm --quiet --notest Try::Tiny@0.28 \
    && perl cpanm --quiet --notest --skip-satisfied --installdeps . \
    && perl Makefile.PL && make && make test && make install

EXPOSE 5050

WORKDIR /opt/service-gfe-submission/gfe_submission
VOLUME /opt/service-gfe-submission/gfe_submission

ENV NXF_OPTS '-Xms512M -Xmx2G'
ENV PATH /opt:/opt/hap1.2:/opt/ngs-tools/bin:/opt/service-gfe-submission/gfe_submission/bin:$PATH

CMD plackup -E deployment -s Starman --workers=10 -p 5050 -a /opt/service-gfe-submission/gfe_submission/bin/app.pl
