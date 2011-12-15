package manaba;
use Dancer ':syntax';

use YAML::Tiny;

our $VERSION = '0.1';

my $CONFIG;

get '/' => sub {
    template 'index';
};

my $SCRAPER = {
    daum => scraper{
        process(
            'table.viewList tr td.title',
            'items[] ',
            scraper{
                process 'a', link => '@href';
            }
        );
    },
};

sub load_manaba {
    $yaml   = YAML::Tiny->read( 'file.yml' );
    $CONFIG = $yaml->[0];
}

sub update {
    my $id = shift;
    next unless $id;

    my $webtoon = $CONFIG->{webtoon};
    next unless $webtoon;

    my $site_name = $webtoon->{$id}{site};
    next unless $site_name;

    my $site = $CONFIG->{site};
    next unless $site;

    my $start_url = sprintf(
        $site->{$site_name}{ 'start_url' },
        $webtoon->{$id}{ 'code' },
    );

    my $scraper = $scraper->scrape( URI->new($start_url) )->{items};
    my @links = map { $_->{link} } @$items;

    given ( $site_name ) {
        update_daum_link($id, @links) when 'daum';
    }

    next unless $id;
    next unless $id;
}

sub update_all {
    my $webtoon = $CONFIG->{webtoon};

    for my $id ( keys %$webtoons ) {
        update($id);
    }
}

load_manaba();

true;
