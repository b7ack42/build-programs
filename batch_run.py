import os
import sys
import shutil

import subprocess
from multiprocessing.pool import ThreadPool


targets = []
# targets.append('harfbuzz')
targets.append('libjpeg')
# targets.append('freetype')
# # targets.append('json')
# targets.append('libpng')
# targets.append('mbedtls')
# targets.append('nm')
# targets.append('objdump')
# targets.append('readelf')
# targets.append('size')
# targets.append('openssl')
# # targets.append('openthread')
# # targets.append('proj')
# # targets.append('re2')
# targets.append('sqlite')
# targets.append('vorbis')
# # targets.append('woff2')
# targets.append('xml')
# targets.append('curl')



# progs_dir = '/home/jinghan/build-programs/programs'
root_dir = '/out'

ce_fp = os.path.join(root_dir, 'fastgen')
# os.system('cp /home/jinghan/vivifuzz/fastgen/target/release/fastgen {}'.format(ce_fp))
inputs_dir = os.path.join(root_dir, 'inputs')
outputs_dir = os.path.join(root_dir, 'outputs')
logs_dir = os.path.join(root_dir, 'logs')



def safe_make(dir_path):
    if os.path.exists(dir_path):
        print "Clean {} first!".format(dir_path)
        return False
    else:
        os.mkdir(dir_path)
        return True




def run(prog):
    env = {'RUST_LOG', 'info'}
    args = [ce_fp]
    args += ['-i', os.path.join(inputs_dir, 'input_{}'.format(prog))]
    args += ['-o', os.path.join(outputs_dir, 'corpus_{}'.format(prog))]
    args += ['-t', os.path.join(progs_dir, '{}.track'.format(pro))]
    args += ['--']
    args += [os.path.join(progs_dir, '{}.fast'.format(pro))]
    if prog == 'objdump':
        args += ['-D']
    elif prog == 'nm':
        args += ['-C']
    elif prog == 'readelf':
        args += ['-a']
    
    log_fp = os.path.join(logs_dir, 'log_{}'.format(prog)

    with open(log_fp, 'w') as f:
        p = Popen(args, shell=True, stdout=f, stderr=f, env=env)
        p.wait()
    
    return prog



def batch(progs):
    for prog in progs:
        corpus_dir = os.path.join(ouputs_dir, 'corpus_{}'.format(prog))
        if not safe_make(corpus_dir):
            return
    
    pool = ThreadPool(20)
    ps = []
    for prog in progs:
        print "start {}".format(prog)
        p = pool.apply_async(run, (prog,))
        ps.append(p)
    
    for p in ps:
        prog = p.get()
        print "{} ends".format(prog)
    
    pool.close()
    pool.join()




if __name__ == '__main__':
    batch(targets)

    
