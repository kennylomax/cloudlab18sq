FROM sonarqube:8.4.2-community
COPY setsq.sh setsq.sh
CMD ["./setsq.sh"]