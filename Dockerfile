FROM jupyter/scipy-notebook

USER root

RUN apt-get update && \
   apt-get install -y --no-install-recommends libopencv-dev && \
   rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN conda install --quiet --yes \
   'numpy' \
   'opencv' \
   && \
   conda clean --all -f -y
