#!/bin/bash
# Author Lubos Rendek <web@linuxconfig.org>

# If no argument supplied, start 20 random question multiplication practice test. 

if [ -z $1 ]; then 
    num=20
else 
    if ! [[ $1 =~ ^-?[0-9]+$ ]] ; then # Sanity check for a valid interger argument.
        echo "Supplied argument is not a valid number. Please try again!" >&2; exit 1
    fi
    num=$1
fi

# This variable holds the amount of wrong answers.
errors=0

# Create an array of 100 questions and answers.
for j in $( seq 1 10); do 
    for i in $( seq 1 10); do 
        questions[((element++))]="$i x $j=$(($i*$j))"
    done
done

# Function to grab a random question from pool.
function get_question {

    rand=$(( ( RANDOM % 100 )  + 1 ))
    question=$(echo ${questions[$rand]} | cut -d = -f1)
    result=$(echo ${questions[$rand]} | cut -d = -f2)

}

# Function to print questions.
function print_question {

    echo "################################"
    printf "\033[0;36mWhat is the product of $question ?\e[0m\n"
    echo -n "Your answer: "
}

# A core function to ask a question and compare response with a valid result.
function ask_question {

response=0

while [ $response -ne $result ]; do 

    
    print_question
    read response
    
    # Keep asking for a response until we get a valid integer.
    while [[ $((response)) != $response ]]; do
        print_question
        read response
    done
    

    if [ $response -eq $result ]; then
        printf "\033[1;32mCorrect !!!\e[0m\n"
        num=$[$num-1]
        printf "\033[0;33mRemaining questions: $num \e[0m\n"
    else
        printf "\033[1;31mWrong answer, try again !!!\e[0m\n"
        errors=$[$errors+1]
        printf "\033[0;33mRemaining questions: $num \e[0m\n"
    fi
    
done

}

# Main while loop to process the requested number of questions.
until [  $num -eq 0 ]; do
    get_question; ask_question;
done

echo "Congratulations, your multiplication practice test is finished!!!"
echo "Wrong answers: $errors"
