#include <iostream>
#include <string>
using namespace std;
static bool bToprint = true;
void myprint(){
	cout<<endl;
}

template<typename Type, typename... Types>
void myprint(const Type& arg, const Types&... args)
{
	if(bToprint == true){
		cout<<arg<<" ";
		myprint(args...);
	}
}

int main()
{
	cout<<"first cpp file:"<<endl;
	bToprint = true;
	cout<<"hello, world!"<<endl;
	myprint("shuaiguo", 12.5);
	return 0;
}
