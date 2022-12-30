//#include <memory> // needed for map assignment
//#include <new>
import test;
import example;
import std;

//using namespace test;
//using namespace with_lambdas;

int main()
{
    test::with_lambdas::foo(1);
    test::with_lambdas::bar(1.0);
    test::with_lambdas::bar(2);

    std::clog << "test" << std::endl;

    auto list = std::list<std::string>{};
    auto map = std::map<std::string,int>{};

    map["test"] = 2112;

    std::cout << map["test"] << std::endl;

    return 0;
}
