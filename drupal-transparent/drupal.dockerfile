FROM drupal:7

RUN echo "Sujith"

WORKDIR /var/www/html

# # Product version
# ARG VERSION
# ENV VERSION ${VERSION:-0.0.0}
# # Link to the product repository
# ARG VCS_URL
# # Hash of the commit
# ARG VCS_REF
# # Repository branch
# ARG VCS_BRANCH
# # Date of the build
# ARG BUILD_DATE
# # Include metadata, additionally use label-schema namespace
# LABEL org.label-schema.schema-version="1.0" \
#     org.label-schema.vendor="Cossack Labs" \
#     org.label-schema.url="https://cossacklabs.com" \
#     org.label-schema.name="AcraEngineeringDemo - drupal-transparent - drupalproject" \
#     org.label-schema.description="AcraEngineeringDemo demonstrates features of main components of Acra Suite" \
#     org.label-schema.version=$VERSION \
#     org.label-schema.vcs-url=$VCS_URL \
#     org.label-schema.vcs-ref=$VCS_REF \
#     org.label-schema.build-date=$BUILD_DATE \
#     com.cossacklabs.product.name="acra-engdemo" \
#     com.cossacklabs.product.version=$VERSION \
#     com.cossacklabs.product.vcs-ref=$VCS_REF \
#     com.cossacklabs.product.vcs-branch=$VCS_BRANCH \
#     com.cossacklabs.product.component="acra-engdemo-drupal-transparent-drupalproject" \
#     com.cossacklabs.docker.container.build-date=$BUILD_DATE \
#     com.cossacklabs.docker.container.type="product"

RUN echo "Sujith2"
# Apply patch
COPY ./configs/user.patch /var/www/html/
RUN patch -p1 < user.patch

RUN mkdir /app
RUN mkdir -p /app/docker
COPY ./entry.sh /app/docker/
RUN chmod +x /app/docker/entry.sh

RUN echo "Sujith3"

ENTRYPOINT ["/app/docker/entry.sh"]
