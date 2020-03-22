package covid19.datas;

class Sources {
    public static inline rawTom = 'https://raw.githubusercontent.com/tomwhite/covid-19-uk-data/master/data/';
    public static inline dataFolder = '../data/';
    public static inline cases      = 'covid-19-cases-uk.csv';
    public static inline indicators = 'covid-19-indicators-uk.csv'; 
    public inline 
    function getCases(): String {
        return rawTom + cases;
    }
    public inline 
    function getIndicators(): String {
        return rawTom + indicators;
    }
    public static inline var csvStats2       = '../data/covid19uk.csv';
}
