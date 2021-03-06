# Sun Grid Engine translator
submit() {
    echo ${ARGS[@]}
	for ARG in ${ARGS[@]}
	do
		ANAME=`echo $ARG | cut -d ':' -f1`
		AVAL=`echo $ARG | cut -d ':' -f2`
		if [ $ANAME = "cpu" ]
		then
			SUBARGS="$SUBARGS -pe $SGE_PE $(($AVAL<$ARG_JOB_CPU_MAX?$AVAL:$ARG_JOB_CPU_MAX))"
		fi
		
		if [ $ANAME = "array" ]
		then
			SUBARGS="$SUBARGS -t ${AVAL//,/:}"
		fi
	done

	# Obtain hold ids, replace splitting tag by actual arguments
	HOLDFOR=`getHoldIds`
	HOLDFOR=${HOLDFOR//;/ -hold_jid }

	# Submit to SGE
	JOBID=`qsub \
		$HOLDFOR \
		-V \
		-N $JOB_NAME \
		-e $FILE_LOG_ERR \
		-o $FILE_LOG_OUT \
		$SUBARGS \
		$NODE \
		$ADDS`
	
	# Fix the JobID
	JOBID=`echo $JOBID | cut -d\  -f3 | cut -d. -f1`
}
