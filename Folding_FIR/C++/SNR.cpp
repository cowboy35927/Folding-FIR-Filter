#include <iostream>
#include <cmath>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <iomanip>
#include<map>
using namespace std;
using std::fixed;
using std::setprecision;
constexpr int MOD = 998244353;
 
string dec_to_hex(int dec, int num){
    map<int, char> m;
    char digit = '0';
    char c = 'A';
    for(int i=0; i<16; i++){
        if(i < 10){
            m[i] = digit++;
        }
        else{
            m[i] = c++;
        }
    }

    string hex = "";
    if(dec == 0){
        return "0";
    }
    if(dec > 0){
        for(int j=0; j<num; j++){
            hex = m[dec % 16] + hex;
            dec /= 16;
        }
    }
    else{
        unsigned int d = dec;
        for(int j=0; j<num; j++){
            hex = m[d % 16] + hex;
            d /= 16;
        }
    }
    return hex;

}
double firfilter(vector<double> orignal, vector<double> quantized,vector<double> coef,  int fixedpoint_width)
{   
    double error = 0;
    double quantized_power = 0;
    double original_power = 0;
    int n = orignal.size(), m = coef.size();
    int sum=0;
    double SNR = 0;
    // Stores the final array
    vector<double> original_c(n + m - 1);
    vector<double> quantized_c(n + m - 1);
    // Traverse the two given arrays
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < m; ++j) {
              // Update the convolution array
            original_c[i + j] += orignal[i] * coef[j] ;
            quantized_c[i + j] += quantized[i] * coef[j];

        }
    }
 
    // Print the convolution array c[]
   
    for (int k = 0; k < original_c.size(); ++k) {
        original_power = original_power + pow(original_c[k], 2);
        error = original_c[k] - quantized_c[k];
        quantized_power = quantized_power + pow(error, 2);
    }
    SNR = 10 * log10(original_power / quantized_power);
    //cout<<"width:"<<fixedpoint_width<<",original_power :"<<original_power <<",quantized_power :"<<quantized_power<<endl;
     /*if(fixedpoint_width==15){
        ofstream dataFile;
       dataFile.open("quantized_output.txt", ofstream::app);
        fstream file("quantized_output.txt", ios::out);
        for(int i=0;i<quantized_c.size();i++){

            dataFile << dec_to_hex(quantized_c[i]*pow(2,15),4)<<endl;     // 写入数据
        }
        
        dataFile.close();  
        dataFile.open("coef_output.txt", ofstream::app);
        fstream file("coef_output.txt", ios::out);
        for(int i=0;i<coef.size();i++){
            dataFile <<  dec_to_hex(coef[i]*pow(2,15),4)<<endl;     // 写入数据
        }
        dataFile.open("output8bits_hex.txt", ofstream::app);
        fstream file("output8bits_hex.txt", ios::out);
        for(int i=0;i<quantized.size();i++){
            dataFile <<  dec_to_hex(quantized[i],4)<<endl;     // 写入数据
        }
        dataFile.close();  
    }*/
    return SNR;
};

double Cal_SNR(vector<double> orignal, vector<double> quantized,vector<double> coef, int fixedpoint_width)
{
    int fixed_point = 0;
    vector<double> fixed_point_quantized;
    vector<double> fixed_point_coef ;
    double error = 0;
    double quantized_power = 0;
    double SNR = 0;
    for (int i = 0; i < orignal.size(); i++)
    {
        fixed_point_quantized.push_back(round(quantized[i] * pow(2, fixedpoint_width))*pow(2, -fixedpoint_width)) ;
    }
    for (int i = 0; i < coef.size(); i++)
    {
        
        fixed_point_coef.push_back(round(coef[i] * pow(2, fixedpoint_width))*pow(2, -fixedpoint_width));
    }
    // cout << "quantized_power" << quantized_power << endl;
    SNR = firfilter(orignal,fixed_point_quantized, fixed_point_coef, fixedpoint_width);
    return SNR;
};
int main()
{
    vector<double> input_24;
    vector<double> input_8;
    vector<double> coef;
    vector<double> SNR_value;
    double orignal_power = 0;
    string line;

    stringstream sstream;
    float floatResult;
    ifstream input_24file("input_24bits.txt");
    ifstream input_8file("input_8bits.txt");
    ifstream input_coef("coef.txt");
    while (getline(input_24file, line)) // 获取每一行数据
    {
        istringstream isb_str(line);
        isb_str >> floatResult;
        input_24.push_back(floatResult); // 将每一行依次存入到vector中
        //orignal_power = orignal_power + pow(floatResult, 2);
    }
    input_24file.close();
    while (getline(input_8file, line)) // 获取每一行数据
    {
        istringstream isb_str(line);
        isb_str >> floatResult;
        input_8.push_back(floatResult); // 将每一行依次存入到vector中
    }
    input_8file.close();
    while (getline(input_coef, line)) // 获取每一行数据
    {
        istringstream isb_str(line);
        isb_str >> floatResult;
        coef.push_back(floatResult); // 将每一行依次存入到vector中
    }
    input_coef.close();
    //cout << "oringinal:" << orignal_power << endl;
    for (int i = 0; i < 32; i++)
    {
        SNR_value.push_back(Cal_SNR(input_24, input_8, coef, i));
        cout << SNR_value[i] << endl;
    }
    
}